from keras.callbacks import EarlyStopping
import mlflow


class ModelTrainer:
    def __init__(self, model) -> None:
        self.model = model

    def train(self, X_train_reshaped, target_train):
        mlflow.search_runs()

        early_stop_params = {
            "monitor": "val_loss",
            "patience": 5,
            "restore_best_weights": True,
        }
        mlflow.log_params(params=early_stop_params)

        early_stop = EarlyStopping(
            monitor=early_stop_params["monitor"],
            patience=early_stop_params["patience"],
            restore_best_weights=early_stop_params["restore_best_weights"],
        )

        model_params = {
            "epochs": 5,
            "batch_size": 64,
            "validation_split": 0.2,
            "verbose": 1,
        }
        mlflow.log_params(model_params)

        self.model.fit(
            X_train_reshaped,
            target_train,
            epochs=model_params["epochs"],
            batch_size=model_params["batch_size"],
            validation_split=model_params["validation_split"],
            callbacks=[early_stop],
            verbose=model_params["verbose"],
        )
        return self.model
