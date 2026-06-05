from keras import Sequential


class ModelEvaluation:
    def __init__(self, model: Sequential, feature_test, target_test) -> None:
        self.model = model
        self.feature_test = feature_test
        self.target_test = target_test
        self.loss = None
        self.accuracy = None

    def build(self) -> str:
        try:
            self.loss, self.accuracy = self.model.evaluate(
                self.feature_test, self.target_test, verbose="auto"
            )
            return f"Accuracy: {self.accuracy * 100:.2f}%\nCNN-LSTM HAR Loss: {self.loss:.4f}"
        except Exception as e:
            return f"Error: Evaluation Failed - {e}"
