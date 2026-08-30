from pathlib import Path

from langchain_core.documents import Document

from data.ingestion.loaders import DocumentLoader
from data.ingestion.splitters import DocumentTextSplitters
from domain.retriever.bm25_retriever import BM25SearchRetriever
from domain.retriever.query_expander import expand_query
from domain.retriever.query_processor import QueryProcessor

KNOWLEDGE_ROOT = Path(__file__).resolve().parents[1] / "docs" / "knowledge"

QUESTIONS = [
    ("What is diabetes?", ("diabetes/overview.md", "faq/diabetes_faq.md")),
    (
        "How can I control or manage this disease?",
        ("diabetes/management.md", "faq/diabetes_faq.md"),
    ),
    (
        "Which diet plans are suitables?",
        ("diabetes/diet.md", "faq/diabetes_faq.md", "diet/south_asian_patterns.md"),
    ),
    (
        "how the identify the diabetes?",
        ("diabetes/diagnosis.md", "faq/diabetes_faq.md"),
    ),
    ("What does glucose mean?", ("parameters/glucose.md", "faq/parameters_faq.md")),
    (
        "Why does the diabetes model use glucose?",
        ("parameters/glucose.md", "models/diabetes-model.md", "e_doc/diabetes-form.md"),
    ),
    ("What does BMI mean?", ("parameters/bmi.md", "faq/parameters_faq.md")),
    (
        "Why does the diabetes model use BMI?",
        ("parameters/bmi.md", "models/diabetes-model.md"),
    ),
    (
        "Is a high-risk prediction a diagnosis?",
        ("e_doc/predictions.md", "faq/e_doc_faq.md", "models/diabetes-model.md"),
    ),
    (
        "Does a positive prediction mean I have diabetes?",
        ("faq/diabetes_faq.md", "e_doc/predictions.md", "models/diabetes-model.md"),
    ),
    (
        "What does my glucose value mean?",
        ("parameters/glucose.md", "faq/parameters_faq.md"),
    ),
    (
        "Is my glucose value high?",
        ("parameters/glucose.md", "faq/parameters_faq.md"),
    ),
    (
        "Why is my blood pressure included?",
        ("parameters/blood_pressure.md", "models/diabetes-model.md"),
    ),
    (
        "What medications are used for diabetes?",
        ("diabetes/medications.md", "faq/diabetes_faq.md", "medications/diabetes.md"),
    ),
    (
        "What should I do during a diabetes emergency?",
        ("diabetes/emergencies.md", "faq/emergency_faq.md", "safety/emergency_warning_signs.md"),
    ),
    ("What is hypertension?", ("hypertension/overview.md", "faq/hypertension_faq.md")),
    (
        "How can I lower blood pressure?",
        ("hypertension/management.md", "faq/hypertension_faq.md"),
    ),
    (
        "What is heart disease?",
        ("heart_disease/overview.md", "faq/heart_disease_faq.md"),
    ),
    (
        "What are heart attack warning signs?",
        ("heart_disease/emergencies.md", "faq/heart_disease_faq.md", "faq/emergency_faq.md"),
    ),
    (
        "Why do diabetes and hypertension occur together?",
        ("combinations/diabetes_hypertension.md", "cross_disease/overview.md"),
    ),
]


def _load_chunks() -> list[Document]:
    documents = DocumentLoader(documents=[str(KNOWLEDGE_ROOT)]).load()
    splitter = DocumentTextSplitters(semantic=False, chunk_size=900, chunk_overlap=150)
    return splitter.load(documents)


def test_knowledge_files_cover_user_questions():
    text = "\n".join(
        path.read_text(encoding="utf-8")
        for path in KNOWLEDGE_ROOT.rglob("*.md")
        if path.name not in {"README.md", "SOURCES.md", "VERSION.md"}
    ).lower()
    assert "what is diabetes?" in text
    assert "how can i control or manage" in text
    assert "which diet plans are suitable" in text
    assert "how the identify the diabetes" in text
    assert "mmol/l" in text
    assert "diabetic / high risk" in text


def test_bm25_retrieves_relevant_diabetes_and_parameter_docs():
    chunks = _load_chunks()
    retriever = BM25SearchRetriever(
        documents=chunks,
        candidate_k=16,
        min_match_ratio=0.12,
        query_processor=QueryProcessor(),
    )
    context = (
        "Latest e-doc screening: diabetes prediction model. "
        "Glucose: 9.2 mmol/L. BMI: 29.5."
    )
    misses: list[str] = []
    for question, expected_sources in QUESTIONS:
        query = expand_query(question, context)
        results = retriever.search(query)
        sources = {str(doc.metadata.get("source", "")).replace("\\", "/") for doc, _ in results}
        if not any(source in sources for source in expected_sources):
            misses.append(f"{question} -> {sorted(sources)[:8]}")
    assert not misses, "BM25 missed expected files:\n" + "\n".join(misses)
