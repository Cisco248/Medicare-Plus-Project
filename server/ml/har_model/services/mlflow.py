from typing import Dict
import mlflow


class MLflowTracker:
    def __init__(self, experiment_name):
        mlflow.set_experiment(experiment_name)

    def log_metrics(self, metrics: Dict):
        for key, value in metrics.items():
            mlflow.log_metric(key, value)

    def model_register(self, run):
        mv = mlflow.register_model(
            "runs:/{}/sklearn-model".format(run.info.run_id), "CNN-LSTM"
        )
        print("Name: {}".format(mv.name))
        print("Version: {}".format(mv.version))
        print("Run ID: {}".format(mv._run_id))
