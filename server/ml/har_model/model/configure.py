from keras import Sequential, Input
from keras.layers import BatchNormalization, Conv1D, Dropout, LSTM, Dense, MaxPooling1D
from keras.optimizers import Adam


class ModelConfigure:
    def __init__(self) -> None:

        self.model = None

    def preprocess_data(self, scaled_x_train, scaled_x_test):
        x_train_reshaped = scaled_x_train.reshape(
            scaled_x_train.shape[0],
            scaled_x_train.shape[1],
            1,
        )
        x_test_reshaped = scaled_x_test.reshape(
            scaled_x_test.shape[0],
            scaled_x_test.shape[1],
            1,
        )
        return x_train_reshaped, x_test_reshaped

    def setup_model(self, reshaped_x_train, classes) -> Sequential:
        name_classes = len(classes)

        self.model = Sequential(
            [
                Input(shape=(reshaped_x_train.shape[1:])),
                Conv1D(64, 3, activation="relu"),
                BatchNormalization(),
                Conv1D(128, 3, activation="relu"),
                BatchNormalization(),
                MaxPooling1D(pool_size=2),
                Dropout(0.3),
                LSTM(32),
                Dense(32, activation="relu"),
                Dropout(0.3),
                Dense(name_classes, activation="softmax"),
            ]
        )
        self.model.compile(
            optimizer=Adam(learning_rate=0.001),
            loss="sparse_categorical_crossentropy",
            metrics=["accuracy"],
        )
        self.model.summary()
        
        return self.model
