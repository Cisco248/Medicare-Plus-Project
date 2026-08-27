from google.cloud import storage
from core import ServerSettings

setting = ServerSettings()


def download_models():
    setting.MODEL_DIR.mkdir(parents=True, exist_ok=True)

    client = storage.Client()
    bucket = client.bucket(setting.BUCKET_NAME)

    models = [
        "diabetes/model.pkl",
        "diabetes/features.pkl",
        "diabetes/labels.pkl",
        "hypertension/model.pkl",
        "hypertension/features.pkl",
        "hypertension/labels.pkl",
        "heart_disease/model.pkl",
        "heart_disease/features.pkl",
        "heart_disease/labels.pkl",
    ]

    for model_path in models:
        destination = setting.MODEL_DIR / model_path

        if destination.exists():
            continue

        destination.parent.mkdir(parents=True, exist_ok=True)

        blob = bucket.blob(model_path)
        blob.download_to_filename(str(destination))
