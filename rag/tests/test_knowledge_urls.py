from pathlib import Path

from data.ingestion.knowledge_urls import load_knowledge_urls
from data.ingestion.loaders import DocumentLoader, _html_to_text


def test_load_knowledge_urls_skips_comments_and_duplicates(tmp_path: Path) -> None:
    url_file = tmp_path / "knowledge_urls.txt"
    url_file.write_text(
        "\n".join(
            [
                "# comment",
                "",
                "https://www.cdc.gov/sleep/about/index.html",
                "https://www.cdc.gov/sleep/about/index.html",
                "https://www.who.int/news-room/fact-sheets/detail/physical-activity",
            ]
        ),
        encoding="utf-8",
    )

    urls = load_knowledge_urls(url_file)

    assert urls == [
        "https://www.cdc.gov/sleep/about/index.html",
        "https://www.who.int/news-room/fact-sheets/detail/physical-activity",
    ]


def test_load_knowledge_urls_missing_file(tmp_path: Path) -> None:
    assert load_knowledge_urls(tmp_path / "missing.txt") == []
    assert load_knowledge_urls(None) == []


def test_document_loader_skips_governance_and_url_list(tmp_path: Path) -> None:
    (tmp_path / "README.md").write_text("# skip", encoding="utf-8")
    (tmp_path / "SOURCES.md").write_text("# skip", encoding="utf-8")
    (tmp_path / "VERSION.md").write_text("# skip", encoding="utf-8")
    (tmp_path / "knowledge_urls.txt").write_text(
        "https://example.com\n", encoding="utf-8"
    )
    (tmp_path / "topic.md").write_text("# Topic\n\nUseful knowledge.", encoding="utf-8")

    documents = DocumentLoader(documents=[str(tmp_path)]).load()

    assert len(documents) == 1
    assert documents[0].metadata["source"] == "topic.md"


def test_url_loader_skips_failed_fetch_and_keeps_local_docs(tmp_path: Path) -> None:
    topic = tmp_path / "topic.md"
    topic.write_text("# Topic\n\nLocal knowledge remains available.", encoding="utf-8")

    documents = DocumentLoader(
        documents=[str(tmp_path)],
        urls=["https://127.0.0.1:9/not-a-real-knowledge-page"],
    ).load()

    assert any("Local knowledge remains available" in doc.page_content for doc in documents)


def test_html_to_text_strips_scripts() -> None:
    text = _html_to_text(
        "<html><head><script>ignore()</script></head>"
        "<body><h1>Adult activity</h1><p>Adults need 150 minutes.</p></body></html>"
    )
    assert "Adult activity" in text
    assert "150 minutes" in text
    assert "ignore()" not in text


def test_packaged_url_list_has_no_sample_sources() -> None:
    url_file = Path(__file__).resolve().parents[1] / "docs" / "knowledge_urls.txt"
    urls = load_knowledge_urls(url_file)

    assert urls
    joined = "\n".join(urls).lower()
    assert "example.com" not in joined
    assert "sample" not in joined
    assert "localhost" not in joined
    assert any("who.int" in url for url in urls)
    assert any("cdc.gov" in url for url in urls)
    assert any("health.harvard.edu" in url for url in urls)
