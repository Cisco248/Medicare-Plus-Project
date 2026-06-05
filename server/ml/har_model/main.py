import mlflow
from sklearn.preprocessing import LabelEncoder, StandardScaler
from data.loader import DataLoaderFactory
from preprocess.pre_processor import PreprocessingPipeline
from model.configure import ModelConfigure
from model.trainer import ModelTrainer
from server.ml.har_model.evaluation.evaluate import ModelEvaluation
from server.ml.har_model.services.mlflow import MLflowTracker

if __name__ == "__main__":

    with mlflow.start_run() as run:

        mf = MLflowTracker("HAR_CNN_LSTM")

        data_train = DataLoaderFactory.create(
            "local",
            path="dataset/har_dataset/Training_Data/train.csv",
        )
        train_ds = data_train.loader()

        data_test = DataLoaderFactory.create(
            "local",
            path="dataset/har_dataset/Testing_Data/test.csv",
        )
        test_ds = data_test.loader()

        encoder = LabelEncoder()
        scaler = StandardScaler()

        X_train = train_ds.drop("Activity", axis=1)
        y_train = train_ds["Activity"]

        X_test = test_ds.drop("Activity", axis=1)
        y_test = test_ds["Activity"]

        pipeline = PreprocessingPipeline(LabelEncoder(), StandardScaler())

        X_train, X_test, y_train, y_test = pipeline.process(
            X_train, X_test, y_train, y_test
        )

        encoder.fit(y_train)
        classes = encoder.classes_

        model_config = ModelConfigure()
        reshaped_x_train, reshaped_y_train = model_config.preprocess_data(
            X_train, X_test
        )
        model = model_config.setup_model(reshaped_x_train, classes)

        trainer = ModelTrainer(model)
        trained_model = trainer.train(reshaped_x_train, y_train)
        mf.model_register(run)

        evaluate_model = ModelEvaluation(trained_model, X_test, y_test)
        mlflow.log_param("accuracy", evaluate_model.accuracy)
        acc = evaluate_model.build()
        print(acc)
