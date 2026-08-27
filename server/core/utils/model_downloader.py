import logging
from pathlib import Path

from google.cloud import storage

from core.configs.server_configuration import ServerSettings

setting = ServerSettings()
logger = logging.getLogger("medicare.server")

BUCKET_PREFIXES = ("base/", "har/")

# Extra names that may exist in the bucket even if the app prefers
# the configured artifact filenames.
_ALIAS_OBJECTS = (
    "base/diabetes/labels.pkl",
    "base/diabetes/feature.pkl",
    "base/hypertension/model.pkl",
    "base/hypertension/features.pkl",
    "base/hypertension/labels.pkl",
    "base/heart_disease/features.pkl",
    "base/heart_disease/labels.pkl",
)


def _relative_blob_name(local_path: str) -> str:
    return Path(local_path).relative_to(setting.MODEL_DIR).as_posix()


def _known_model_objects() -> list[str]:
    configured = [
        setting.HYPERTENSION_MODEL_PATH,
        setting.HYPERTENSION_FEATURE_PATH,
        setting.HYPERTENSION_LABEL_PATH,
        setting.DIABETES_MODEL_PATH,
        setting.DIABETES_SCALER_PATH,
        setting.DIABETES_FEATURE_PATH,
        setting.HEART_DISEASE_MODEL_PATH,
        setting.HEART_DISEASE_SCALER_PATH,
        setting.HEART_DISEASE_FEATURE_PATH,
        setting.HEART_DISEASE_INFO_PATH,
        setting.HAR_MODEL_PATH,
    ]
    names = [_relative_blob_name(path) for path in configured]
    names.extend(_ALIAS_OBJECTS)
    return list(dict.fromkeys(names))


def _cleanup_partial(destination: Path) -> None:
    try:
        if destination.exists() and destination.stat().st_size == 0:
            destination.unlink()
    except OSError:
        return


def _download_blob(blob, destination: Path) -> bool:
    if destination.exists():
        return True

    destination.parent.mkdir(parents=True, exist_ok=True)
    try:
        blob.download_to_filename(str(destination))
    except Exception as exc:
        _cleanup_partial(destination)
        logger.warning(
            "Skipping missing model object gs://%s/%s (%s)",
            setting.BUCKET_NAME,
            blob.name,
            exc,
        )
        return False

    logger.info("Downloaded gs://%s/%s", setting.BUCKET_NAME, blob.name)
    return True


def download_models() -> None:
    """Copy model artifacts from GCS into MODEL_DIR.

    Objects that are not in the bucket (404) are skipped so Cloud Run can
    still start when only some prefixes exist, e.g. ``base/diabetes``.
    """
    try:
        setting.MODEL_DIR.mkdir(parents=True, exist_ok=True)
        client = storage.Client()
        bucket = client.bucket(setting.BUCKET_NAME)
    except Exception:
        logger.exception(
            "Cloud Storage client is not available; skipping model download"
        )
        return

    listed = False
    try:
        for prefix in BUCKET_PREFIXES:
            for blob in client.list_blobs(setting.BUCKET_NAME, prefix=prefix):
                if not blob.name or blob.name.endswith("/"):
                    continue
                if _download_blob(blob, setting.MODEL_DIR / blob.name):
                    listed = True
    except Exception as exc:
        logger.warning(
            "Could not list gs://%s; falling back to known object names (%s)",
            setting.BUCKET_NAME,
            exc,
        )

    if listed:
        return

    for model_path in _known_model_objects():
        _download_blob(bucket.blob(model_path), setting.MODEL_DIR / model_path)
