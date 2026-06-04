# type: ignore
import os
import zipfile
import pandas as pd
from enum import Enum
from google.colab import drive
from typing import Tuple
from pandas import DataFrame
from numpy.typing import NDArray
from sklearn.preprocessing import LabelEncoder, StandardScaler
import tensorflow as tf
from keras import Sequential, Input
from keras.layers import Conv1D, Dropout, LSTM, Dense
from keras.optimizers import Adam
from keras.callbacks import EarlyStopping


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


class Training_Tensor_Model:
    def __init__(
        self,
        feature_train: NDArray,
        feature_test: NDArray,
        target_train: NDArray,
        target_test: NDArray,
        encoder: LabelEncoder,
        scaler: StandardScaler,
    ) -> None:
        self.model = None
        self.feature_train = feature_train
        self.feature_test = feature_test
        self.encoder = encoder
        self.scaler = scaler
        self.target_train = target_train
        self.target_test = target_test

    def _encode_data(self) -> None:
        self.target_train = self.encoder.fit_transform(self.target_train)
        self.target_test = self.encoder.transform(self.target_test)

    def _scale_data(self) -> None:
        self.feature_train = self.scaler.fit_transform(self.feature_train)
        self.feature_test = self.scaler.transform(self.feature_test)

    def _preprocess_data(self) -> Tuple[NDArray, NDArray]:
        X_train_shape = self.feature_train.reshape(
            self.feature_train.shape[0], self.feature_train.shape[1], 1
        )
        X_test_shape = self.feature_test.reshape(
            self.feature_test.shape[0], self.feature_test.shape[1], 1
        )
        return X_train_shape, X_test_shape

    def setup_model(self) -> None:
        self.model = Sequential(
            [
                Input(shape=(self.feature_train.shape[1], 1)),
                Conv1D(filters=64, kernel_size=3, activation="relu"),
                Dropout(0.3),
                LSTM(64, return_sequences=False),
                Dropout(0.3),
                Dense(64, activation="relu"),
                Dense(6, activation="softmax"),
            ]
        )
        self.model.compile(
            optimizer=Adam(learning_rate=0.001),
            loss="sparse_categorical_crossentropy",
            metrics=["accuracy"],
        )
        print(self.model.summary())

    def train_model(self, X_train_reshaped: NDArray) -> None:
        early_stop = EarlyStopping(
            monitor="val_accuracy",
            patience=5,
            restore_best_weights=True,
        )
        self.model.fit(
            X_train_reshaped,
            self.target_train,
            epochs=20,
            batch_size=64,
            validation_split=0.2,
            callbacks=[early_stop],
            verbose=1,
        )

    def build(self) -> Tuple[Sequential, NDArray, NDArray]:
        self._encode_data()
        self._scale_data()
        X_train_reshaped, X_test_reshaped = self._preprocess_data()
        self.setup_model()
        self.train_model(X_train_reshaped)
        return self.model, X_test_reshaped, self.target_test


class Evaluate_Tensor_Model:
    def __init__(
        self, model: Sequential, feature_test: NDArray, target_test: NDArray
    ) -> None:
        self.model = model
        self.feature_test = feature_test
        self.target_test = target_test
        self.loss = None
        self.accuracy = None

    def build(self) -> str:
        try:
            self.loss, self.accuracy = self.model.evaluate(
                self.feature_test, self.target_test, verbose=0
            )
            return f"CNN-LSTM HAR Accuracy: {self.accuracy * 100:.2f}%\nCNN-LSTM HAR Loss: {self.loss:.4f}"
        except Exception as e:
            return f"Error: Evaluation Failed - {e}"


if __name__ == "__main__":
    encoder = LabelEncoder()
    scaler = StandardScaler()

    drive.mount("/content/drive")
    PROJECT_ROOT = "/content/drive/MyDrive/FYP/Project_Data/"
    DATA_ZIP_PATH = os.path.join(PROJECT_ROOT, "har_dataset.zip")
    EXACT_PATH = os.path.join(PROJECT_ROOT, "Raw")

    phase_01 = Data_Pre_Processing(File_Path=DATA_ZIP_PATH, Extract_Path=EXACT_PATH)
    feature_train, feature_test, target_train, target_test = phase_01.build()

    phase_02 = Training_Tensor_Model(
        encoder=encoder,
        scaler=scaler,
        feature_train=feature_train,
        feature_test=feature_test,
        target_train=target_train,
        target_test=target_test,
    )
    trained_model, X_test_ready, y_test_ready = phase_02.build()

    phase_03 = Evaluate_Tensor_Model(
        model=trained_model, feature_test=X_test_ready, target_test=y_test_ready
    )
    print("\n--- Evaluation Results ---")
    print(phase_03.build())
