from pathlib import Path

import joblib
from sklearn.ensemble import RandomForestClassifier


class ArtifactLoader:
    @staticmethod
    def resolve(*candidates: str) -> str:
        for path in candidates:
            if path and Path(path).exists():
                return path
        return candidates[0] if candidates else ""

    def model_loader(self, model_path: str) -> RandomForestClassifier:
        if not model_path:
            raise Exception("Models not Found")
        return joblib.load(model_path)

    def feature_loader(self, feature_path: str):
        if not feature_path:
            raise Exception("Feature set not Found")
        return joblib.load(feature_path)

    def label_loader(self, label_path: str):
        if not label_path:
            raise Exception("Label set not Found")
        return joblib.load(label_path)

    def scaler_loader(self, scaler_path: str):
        if not scaler_path:
            raise Exception("Scaler not Found")
        return joblib.load(scaler_path)
