from pathlib import Path

from langchain_core.documents import Document
from langchain_core.messages import AIMessage

from data.ingestion.text_splitters import DocumentTextSplitters
from data.storage.local_db import LocalDatabase
from domain.pipeline.chain_manager import RAGPipeline
from domain.pipeline.setup import setup_rag_system
from domain.pipeline.token_budget import TokenBudget
from domain.retriever.hybrid import HybridRetriever


class FakeVectorStore:
    def __init__(self, results=None, ids=None):
        self.results = results or []
        self.ids = ids or []
        self.added_ids = []
        self.deleted_ids = []

    def similarity_search_with_relevance_scores(self, query, **kwargs):
        return self.results

    def get(self, **kwargs):
        return {"ids": self.ids}

    def add_documents(self, documents, ids):
        self.added_ids.extend(ids)

    def delete(self, ids):
        self.deleted_ids.extend(ids)


class FakeBM25:
    def __init__(self, documents):
        self.documents = documents

    def invoke(self, query):
        return self.documents


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


def test_recursive_chunker_uses_requested_size_and_overlap():
    document = Document(page_content=("alpha beta gamma delta " * 80).strip())
    chunks = DocumentTextSplitters.chunk(
        [document],
        embedding=None,
        is_semantic=False,
        chunk_size=120,
        chunk_overlap=20,
    )

    assert len(chunks) > 1
    assert all(len(chunk.page_content) <= 120 for chunk in chunks)
    assert [chunk.metadata["chunk_index"] for chunk in chunks] == list(
        range(len(chunks))
    )


def test_chunk_id_is_stable_and_changes_with_content():
    first = Document(
        page_content="same content",
        metadata={"source": "sample.pdf", "page": 0, "chunk_index": 0},
    )
    duplicate = Document(page_content=first.page_content, metadata=dict(first.metadata))
    changed = Document(page_content="changed content", metadata=dict(first.metadata))

    assert LocalDatabase.chunk_id(first) == LocalDatabase.chunk_id(duplicate)
    assert LocalDatabase.chunk_id(first) != LocalDatabase.chunk_id(changed)


def test_local_database_adds_only_missing_chunks(monkeypatch):
    first = Document(
        page_content="existing",
        metadata={"source": "sample.pdf", "page": 0, "chunk_index": 0},
    )
    second = Document(
        page_content="new",
        metadata={"source": "sample.pdf", "page": 0, "chunk_index": 1},
    )
    first_id = LocalDatabase.chunk_id(first)
    store = FakeVectorStore(ids=[first_id, "stale-id"])

    monkeypatch.setattr(
        "data.storage.local_db.ChromaClient.build",
        lambda self: store,
    )
    _, index_version = LocalDatabase.sync([first, second], embedding=object())

    assert store.added_ids == [LocalDatabase.chunk_id(second)]
    assert store.deleted_ids == ["stale-id"]
    assert len(index_version) == 16


def test_hybrid_search_applies_similarity_and_lexical_thresholds():
    relevant = Document(
        page_content="Blood pressure monitoring supports long-term health tracking.",
        metadata={"chunk_id": "relevant", "source": "medical.pdf"},
    )
    rejected = Document(
        page_content="Unrelated administration text.",
        metadata={"chunk_id": "rejected", "source": "medical.pdf"},
    )
    vector_store = FakeVectorStore(results=[(relevant, 0.91), (rejected, 0.30)])
    retriever = HybridRetriever(
        vector_store=vector_store,
        bm25_retriever=FakeBM25([relevant, rejected]),
        k=3,
        vector_candidate_k=5,
        similarity_threshold=0.55,
        bm25_min_match_ratio=0.2,
    )

    results = retriever.search("How is blood pressure monitored?")

    assert [doc.metadata["chunk_id"] for doc in results] == ["relevant"]
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
    retriever = HybridRetriever(
        vector_store=FakeVectorStore(results=[(lab, 0.9)]),
        bm25_retriever=FakeBM25([lab, note]),
        k=3,
        vector_candidate_k=5,
        similarity_threshold=0.55,
        bm25_min_match_ratio=0.2,
    )

    results = retriever.search(
        "blood glucose",
        metadata_filter={"document_type": "lab"},
    )

    assert {doc.metadata["document_type"] for doc in results} == {"lab"}


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
