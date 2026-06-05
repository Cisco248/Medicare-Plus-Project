from pandas import DataFrame


class DataCleaner:
    @staticmethod
    def drop_duplicates(df: DataFrame):
        return df.drop_duplicates()

    @staticmethod
    def fill_null(df):
        for col in df.select_dtypes(include="number"):
            df[col] = df[col].fillna(df[col].median())
        for col in df.select_dtypes(include=["object", "category"]):
            df[col] = df[col].fillna(df[col].mode()[0])
        return df


class TargetEncoder:
    def __init__(self, encoder):
        self.encoder = encoder

    def fit(self, y):
        self.encoder.fit(y)

    def transform(self, y):
        return self.encoder.transform(y)

    def fit_transform(self, y):
        return self.encoder.fit_transform(y)


class FeatureScaler:
    def __init__(self, scaler):
        self.scaler = scaler

    def fit(self, X):
        self.scaler.fit(X)

    def transform(self, X):
        return self.scaler.transform(X)

    def fit_transform(self, X):
        return self.scaler.fit_transform(X)


class PreprocessingPipeline:
    def __init__(self, encoder, scaler):
        self.cleaner = DataCleaner()
        self.encoder = TargetEncoder(encoder)
        self.scaler = FeatureScaler(scaler)

    def process(self, X_train, X_test, y_train, y_test):
        X_train = self.cleaner.fill_null(X_train)
        X_test = self.cleaner.fill_null(X_test)

        y_train = self.encoder.fit_transform(y_train)
        y_test = self.encoder.transform(y_test)

        X_train = self.scaler.fit_transform(X_train)
        X_test = self.scaler.transform(X_test)

        return (X_train, X_test, y_train, y_test)
