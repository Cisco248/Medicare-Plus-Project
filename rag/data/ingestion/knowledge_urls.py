from pathlib import Path


def load_knowledge_urls(path: Path | str | None = None) -> list[str]:
    """Read real knowledge URLs from a comment-friendly text file."""
    if path is None:
        return []
    file_path = Path(path)
    if not file_path.is_file():
        return []

    urls: list[str] = []
    seen: set[str] = set()
    for raw_line in file_path.read_text(encoding="utf-8").splitlines():
        line = raw_line.strip()
        if not line or line.startswith("#"):
            continue
        if line in seen:
            continue
        seen.add(line)
        urls.append(line)
    return urls
