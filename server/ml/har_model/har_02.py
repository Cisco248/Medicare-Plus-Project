# type: ignore
from enum import Enum
import os
import seaborn as sns
from typing import Tuple
import zipfile
import joblib
from google.colab import drive
from matplotlib import pyplot as plt
import numpy as np
from numpy.typing import NDArray
import pandas as pd
from pandas import DataFrame
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import accuracy_score, classification_report, confusion_matrix
from sklearn.model_selection import RandomizedSearchCV, cross_val_score


class Required_Directories(Enum):
    TRAINING_DATA = "Training_Data"
    TESTING_DATA = "Testing_Data"


class Data_Pre_Processing:
    def __init__(self, File_Path: str, Extract_Path: str):
        self.File_Path = File_Path
        self.Extract_Path = Extract_Path
        self.required_dirs = [dir.value for dir in Required_Directories]

    def _import_data_and_verify(self) -> str:
        try:
            if not os.path.isfile(self.File_Path) or not self.File_Path.endswith(
                ".zip"
            ):
                return f"Error: File_Path must be a path to a zip file. Got: {self.File_Path}"
            with zipfile.ZipFile(self.File_Path, "r") as file:
                file.extractall(self.Extract_Path)
            for dir_name in self.required_dirs:
                path = os.path.join(self.Extract_Path, dir_name)
                if not os.path.isdir(path):
                    return f"Required directory not found after extraction: {path}"
            return "Dataset verified and extracted successfully."
        except zipfile.BadZipFile:
            return "Error: The file is not a valid zip file."
        except Exception as e:
            return f"An unexpected error occurred during extraction: {e}"

    def _load_data(self) -> Tuple[DataFrame, DataFrame]:
        train_file = pd.read_csv(
            os.path.join(self.Extract_Path, "Training_Data", "train.csv")
        )
        test_file = pd.read_csv(
            os.path.join(self.Extract_Path, "Testing_Data", "test.csv")
        )
        print(f"Train Shape: {train_file.shape}")
        print(f"Test Shape: {test_file.shape}")
        return train_file, test_file

    def _feature_engineering(
        self, train_file: DataFrame, test_file: DataFrame
    ) -> Tuple[NDArray, NDArray]:
        feature_train = train_file.drop(["Activity", "subject"], axis=1).values
        feature_test = test_file.drop(["Activity", "subject"], axis=1).values
        return feature_train, feature_test

    def _target_engineering(
        self, train_file: DataFrame, test_file: DataFrame
    ) -> Tuple[NDArray, NDArray]:
        target_train = train_file["Activity"].values
        target_test = test_file["Activity"].values
        return target_train, target_test

    def build(self) -> Tuple[NDArray, NDArray, NDArray, NDArray]:
        import_data = self._import_data_and_verify()
        print(import_data)
        if "Error" in import_data or "not found" in import_data:
            raise RuntimeError(import_data)

        train_file, test_file = self._load_data()
        feature_train, feature_test = self._feature_engineering(train_file, test_file)
        target_train, target_test = self._target_engineering(train_file, test_file)
        return feature_train, feature_test, target_train, target_test


class Training_RF_Model:
    def __init__(
        self,
        feature_train,
        feature_test,
        target_train,
        target_test,
    ) -> None:
        self.feature_train = feature_train
        self.feature_test = feature_test
        self.target_train = target_train
        self.target_test = target_test

    def setup_model(
        self, n_estimators: int, random_state: int, n_jobs: int
    ) -> Tuple[int, int, int]:
        return n_estimators, random_state, n_jobs

    def train_model(
        self, n_estimators: int, random_state: int, n_jobs: int
    ) -> RandomForestClassifier:
        model = RandomForestClassifier(
            n_estimators=n_estimators, random_state=random_state, n_jobs=n_jobs
        )
        return model.fit(self.feature_train, self.target_train)

    def predict_values(self, trained_model: RandomForestClassifier) -> Tuple:
        pred = trained_model.predict(self.feature_test)
        accuracy = accuracy_score(self.target_test, pred)
        return pred, accuracy


class Evaluate_RF_Model:
    def __init__(self) -> None:
        pass

    def accuracy(self, target_test, accuracy, pred):
        print(f" Random Forest Accuracy: {accuracy * 100:.2f}%")
        print(classification_report(target_test, pred))

    def confusion_matrix(self, target_test, pred):
        cm = confusion_matrix(target_test, pred)
        plt.figure(figsize=(10, 8))
        sns.heatmap(cm, annot=True, fmt="d", cmap="Blues")
        plt.title("HAR Model - Confusion Matrix", fontsize=16)
        plt.ylabel("Actual Activity")
        plt.xlabel("Predicted Activity")
        plt.xticks(rotation=45)
        plt.tight_layout()
        plt.savefig("confusion_matrix.png")
        plt.show()

    def cross_validation(
        self,
        model,
        feature_train,
        target_train,
        feature_test,
        target_test,
        cv=5,
        n_job=-1,
    ):
        cv_scores = cross_val_score(
            model,
            np.vstack([feature_train, feature_test]),
            np.concatenate([target_train, target_test]),
            cv=cv,
            n_jobs=n_job,
        )

        print(f"CV Scores: {cv_scores}")
        print(f"Mean Accuracy: {cv_scores.mean()*100:.2f}%")
        print(f"Std: {cv_scores.std()*100:.2f}%")
        print(
            f"Reliable Accuracy: "
            f"{(cv_scores.mean()-cv_scores.std())*100:.2f}% "
            f"- {(cv_scores.mean()+cv_scores.std())*100:.2f}%"
        )

    # def save_model(self, model, encoder):
    #     joblib.dump(model, "HAR_RF_MODEL.pkl")
    #     files.download("HAR_RF_MODEL.pkl")
    #     joblib.dump(encoder, "HAR_LAEN.pkl")
    #     files.download("HAR_LAEN.pkl")

    def fine_tuned_model(
        self,
        params: dict,
        feature_train,
        target_train,
        feature_test,
        target_test,
    ):
        model = RandomizedSearchCV(
            RandomForestClassifier(random_state=42, n_jobs=-1),
            param_distributions=params,
            n_iter=15,
            cv=3,
            scoring="accuracy",
            random_state=42,
            n_jobs=-1,
            verbose=1,
        )
        model.fit(feature_train, target_train)

        rf_est = model.best_estimator_
        acc = accuracy_score(target_test, rf_est.predict(feature_test))

        print(f"Best Parameters: {model.best_params_}")
        print(f"Tuned Accuracy: {acc*100:.2f}%")


if __name__ == "__main__":
    drive.mount("/content/drive")
    PROJECT_ROOT = "/content/drive/MyDrive/FYP/Project_Data/"
    DATA_ZIP_PATH = os.path.join(PROJECT_ROOT, "har_dataset.zip")
    EXACT_PATH = os.path.join(PROJECT_ROOT, "Raw")

    dpp = Data_Pre_Processing(File_Path=DATA_ZIP_PATH, Extract_Path=EXACT_PATH)
    feature_train, feature_test, target_train, target_test = dpp.build()

    trainer = Training_RF_Model(feature_train, feature_test, target_train, target_test)
    n_estimators, random_state, n_jobs = trainer.setup_model(5, 42, -1)
    model = trainer.train_model(n_estimators, random_state, n_jobs)
    pred, acc = trainer.predict_values(model)

    evalute = Evaluate_RF_Model()
    evalute.accuracy(target_test, acc, pred)
    evalute.confusion_matrix(target_test, pred)
    evalute.cross_validation(
        model, feature_train, target_train, feature_test, target_test
    )

    params = {
        "n_estimators": [200, 300, 500],
        "max_depth": [None, 20, 30],
        "min_samples_split": [2, 5],
        "min_samples_leaf": [1, 2],
        "max_features": ["sqrt", "log2"],
    }
    evalute.fine_tuned_model(
        params, feature_train, target_train, feature_test, target_test
    )
