from datasets import load_from_disk, tqdm
from pandas import DataFrame
from datasets import DatasetDict
from config.settings import OCRConfig
from inference.predictor import OCRPredictor


class ModelEvaluator:
    def __init__(self, config: OCRConfig, predictor: OCRPredictor) -> None:
        self.config = config
        self.predictor = predictor

    def verify_dataset(self):
        splits = load_from_disk(self.config.TESTING_DIR)
        print(f"Testign Samples: {len(splits)}")
        return splits

    def load_dataset(self, dataset, preds, refs, batch_size=16):
        for i in tqdm(range(0, len(dataset), batch_size)):
            rows = dataset[i : i + batch_size]
            images = [img.convert("RGB") for img in rows["image"]]
            labels = [str(l).strip().lower() for l in rows["label"]]
            out = self.predictor.predict(images)
            preds.extend([t.strip().lower() for t in out])
            refs.extend(labels)
        results_df = DataFrame({"reference": refs, "prediction": preds})
        return results_df
