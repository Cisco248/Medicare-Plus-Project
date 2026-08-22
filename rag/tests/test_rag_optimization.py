from pathlib import Path

from langchain_core.documents import Document
from langchain_core.messages import AIMessage

from data.ingestion.loaders import DocumentLoader
from data.ingestion.splitters import DocumentTextSplitters
from data.model.request import EDocRequest, compose_edoc_question
from data.storage.store_manager import VectorStoreManager
from domain.pipeline.chain_manager import RAGPipeline
from domain.pipeline.setup import setup_rag_system
from domain.pipeline.token_budget import TokenBudget
from domain.retriever.hybrid import HybridRetriever
from domain.retriever.query_processor import QueryProcessor
from domain.retriever.rff_ranker import RRFRanker
from domain.retriever.result_formatter import RetrievalResultFormatter
from domain.retriever.metadata_filter import MetadataFilter


class FakeVectorStore:
    def __init__(self, results=None, ids=None):
        self.results = results or []
        self.ids = ids or []
        self.added_ids = []
        self.deleted_ids = []

    def similarity_search_with_relevance_scores(self, query, **kwargs):
        metadata_filter = kwargs.get("filter")
        results = self.results
        if metadata_filter:
            results = [
                (document, score)
                for document, score in results
                if all(
                    document.metadata.get(key) == value
                    for key, value in metadata_filter.items()
                )
            ]
        return results

    def get(self, **kwargs):
        return {"ids": self.ids}

    def add_documents(self, documents, ids):
        self.added_ids.extend(ids)

    def delete(self, ids):
        self.deleted_ids.extend(ids)


class FakeVectorRetriever:
    def __init__(self, results, candidate_k=8):
        self.results = results
        self.candidate_k = candidate_k

    def search(self, query, metadata_filter=None):
        if not metadata_filter:
            return list(self.results)
        return [
            (document, score)
            for document, score in self.results
            if all(
                document.metadata.get(key) == value
                for key, value in metadata_filter.items()
            )
        ]


class FakeBM25Retriever:
    def __init__(self, results):
        self.results = results

    def search(self, query, metadata_filter=None):
        if not metadata_filter:
            return list(self.results)
        return [
            (document, score)
            for document, score in self.results
            if all(
                document.metadata.get(key) == value
                for key, value in metadata_filter.items()
            )
        ]


class FakeRetriever:
    def __init__(self, documents):
        self.documents = documents
        self.calls = 0

    def search(self, question, metadata_filter=None, k=None):
        self.calls += 1
        return self.documents


class FakeLLM:
    def __init__(self):
        self.calls = 0

    def invoke(self, messages):
        self.calls += 1
        return AIMessage(
            content="Grounded answer.",
            usage_metadata={
                "input_tokens": 20,
                "output_tokens": 3,
                "total_tokens": 23,
            },
        )


def _hybrid(vector_results, bm25_results, k=3):
    return HybridRetriever(
        vector_store=FakeVectorStore(results=vector_results),
        k=k,
        vector_retriever=FakeVectorRetriever(vector_results),
        bm25_retriever=FakeBM25Retriever(bm25_results),
        ranker=RRFRanker(),
        result_formatter=RetrievalResultFormatter(),
        query_processor=QueryProcessor(),
        metadata_filter=MetadataFilter(),
    )


def test_loader_ingests_markdown_directory_and_skips_index_files(tmp_path: Path):
    (tmp_path / "README.md").write_text("# Index", encoding="utf-8")
    (tmp_path / "SOURCES.md").write_text("https://example.com", encoding="utf-8")
    topic = tmp_path / "diabetes"
    topic.mkdir()
    (topic / "overview.md").write_text("# Diabetes overview\nFacts.", encoding="utf-8")

    documents = DocumentLoader(documents=[str(tmp_path)]).load()

    assert len(documents) == 1
    assert documents[0].metadata["source"] == "diabetes/overview.md"
    assert "Diabetes overview" in documents[0].page_content


def test_recursive_chunker_uses_requested_size_and_overlap():
    document = Document(page_content=("alpha beta gamma delta " * 80).strip())
    splitter = DocumentTextSplitters(
        None,
        semantic=False,
        chunk_size=120,
        chunk_overlap=20,
    )
    chunks = splitter.load([document])

    assert len(chunks) > 1
    assert all(len(chunk.page_content) <= 120 for chunk in chunks)
    assert [chunk.metadata["chunk_index"] for chunk in chunks] == list(
        range(len(chunks))
    )


def test_chunk_id_is_stable_and_changes_with_content():
    manager = VectorStoreManager([], embeddings=object())
    first = Document(
        page_content="same content",
        metadata={"source": "sample.pdf", "page": 0, "chunk_index": 0},
    )
    duplicate = Document(page_content=first.page_content, metadata=dict(first.metadata))
    changed = Document(page_content="changed content", metadata=dict(first.metadata))

    assert manager._chunk_id(first) == manager._chunk_id(duplicate)
    assert manager._chunk_id(first) != manager._chunk_id(changed)


def test_hybrid_search_applies_similarity_and_lexical_thresholds():
    relevant = Document(
        page_content="Blood pressure monitoring supports long-term health tracking.",
        metadata={"chunk_id": "relevant", "source": "medical.md"},
    )
    rejected = Document(
        page_content="Unrelated administration text.",
        metadata={"chunk_id": "rejected", "source": "medical.md"},
    )
    retriever = HybridRetriever.build(
        vector_store=FakeVectorStore(results=[(relevant, 0.91), (rejected, 0.30)]),
        documents=[relevant, rejected],
        k=3,
        vector_candidate_k=5,
        similarity_threshold=0.55,
        bm25_min_match_ratio=0.2,
    )

    results = retriever.search("How is blood pressure monitored?")

    assert results
    assert results[0].metadata["chunk_id"] == "relevant"
    assert results[0].metadata["vector_similarity"] == 0.91
    assert "vector" in results[0].metadata["retrieval_sources"]


def test_hybrid_search_applies_metadata_filter():
    lab = Document(
        page_content="A blood glucose laboratory result.",
        metadata={"chunk_id": "lab", "document_type": "lab"},
    )
    note = Document(
        page_content="A blood glucose clinical note.",
        metadata={"chunk_id": "note", "document_type": "note"},
    )
    retriever = _hybrid(
        vector_results=[(lab, 0.9)],
        bm25_results=[(lab, 0.8), (note, 0.7)],
    )

    results = retriever.search(
        "blood glucose",
        metadata_filter={"document_type": "lab"},
    )

    assert {doc.metadata["document_type"] for doc in results} == {"lab"}


def test_hybrid_search_boosts_safety_documents():
    general = Document(
        page_content="General lifestyle advice for blood pressure.",
        metadata={"chunk_id": "general", "source": "hypertension/overview.md"},
    )
    safety = Document(
        page_content="Emergency warning signs require urgent care.",
        metadata={"chunk_id": "safety", "source": "safety/emergency_warning_signs.md"},
    )
    retriever = _hybrid(
        vector_results=[(general, 0.92), (safety, 0.70)],
        bm25_results=[(general, 0.6), (safety, 0.5)],
        k=2,
    )

    results = retriever.search("severe chest pressure and sudden stroke signs")

    assert results[0].metadata["chunk_id"] == "safety"


def test_token_budget_trims_context_to_limit():
    budget = TokenBudget(
        model="gpt-4o-mini",
        max_request_tokens=100,
        max_context_tokens=30,
    )
    documents = [
        Document(page_content="health information " * 100, metadata={"source": "a"})
    ]

    context = budget.build_context(documents)

    assert context.token_count <= 30
    assert context.document_count == 1


def test_pipeline_caches_identical_questions(monkeypatch):
    monkeypatch.setattr(
        "domain.pipeline.chain_manager.settings.OPENAI_API_KEY",
        "",
    )
    retriever = FakeRetriever(
        [Document(page_content="Verified context.", metadata={"source": "a"})]
    )
    pipeline = RAGPipeline(retriever=retriever, index_version="v1")
    fake_llm = FakeLLM()
    pipeline._llm = fake_llm

    assert pipeline.invoke("What is verified?") == "Grounded answer."
    assert pipeline.invoke("What is verified?") == "Grounded answer."

    assert fake_llm.calls == 1
    assert pipeline.usage_stats()["cache_hits"] == 1


def test_similarity_search_does_not_call_llm(monkeypatch):
    monkeypatch.setattr(
        "domain.pipeline.chain_manager.settings.OPENAI_API_KEY",
        "",
    )
    retriever = FakeRetriever(
        [Document(page_content="Verified context.", metadata={"source": "a"})]
    )
    pipeline = RAGPipeline(retriever=retriever, index_version="v1")
    fake_llm = FakeLLM()
    pipeline._llm = fake_llm

    results = pipeline.search("What is verified?")

    assert len(results) == 1
    assert fake_llm.calls == 0


def test_empty_knowledge_directory_starts_not_ready(tmp_path: Path):
    pipeline = setup_rag_system(tmp_path)

    assert pipeline.ready is False
    assert pipeline.invoke("What is in the knowledge base?").startswith("I don't know")


def test_missing_openai_key_starts_not_ready(tmp_path: Path, monkeypatch):
    (tmp_path / "note.md").write_text("# Note\nContent.", encoding="utf-8")
    monkeypatch.setattr("data.ingestion.embedding.settings.OPENAI_API_KEY", "")

    pipeline = setup_rag_system(tmp_path)

    assert pipeline.ready is False


def test_compose_edoc_question_uses_explicit_question():
    payload = EDocRequest(question="What is hypertension?", prediction="high")
    assert compose_edoc_question(payload) == "What is hypertension?"


def test_compose_edoc_question_from_prediction_fields():
    payload = EDocRequest(
        prediction="elevated risk",
        age=45,
        height=170,
        weight=70,
        bmi=24.2,
        hemoglobin_count=5.6,
        cholesterol_mgdl=180,
        diabetes_ordinal="normal",
        gender="male",
    )
    question = compose_edoc_question(payload)
    assert "elevated risk" in question
    assert "Age: 45" in question
    assert "Cholesterol: 180" in question
    assert "normal" in question
