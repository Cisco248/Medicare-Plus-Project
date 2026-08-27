from google.cloud import storage
from core.configs.server_configuration import ServerSettings

setting = ServerSettings()


def download_models():
    setting.MODEL_DIR.mkdir(parents=True, exist_ok=True)

    client = storage.Client()
    bucket = client.bucket(setting.BUCKET_NAME)

    models = [
        "base/diabetes/model.pkl",
        "base/diabetes/features.pkl",
        "base/diabetes/labels.pkl",
        "base/hypertension/model.pkl",
        "base/hypertension/features.pkl",
        "base/hypertension/labels.pkl",
        "base/heart_disease/model.pkl",
        "base/heart_disease/features.pkl",
        "base/heart_disease/labels.pkl",
        "har/model.pkl",
    ]

    for model_path in models:
        destination = setting.MODEL_DIR / model_path

        if destination.exists():
            continue

        destination.parent.mkdir(parents=True, exist_ok=True)

        blob = bucket.blob(model_path)
        blob.download_to_filename(str(destination))
