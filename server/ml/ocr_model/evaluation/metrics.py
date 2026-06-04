import random
import evaluate
from matplotlib import pyplot as plt
from pandas import DataFrame


class OCRMatrix:
    def __init__(self) -> None:
        self.cer_metric = evaluate.load("cer")
        self.wer_metric = evaluate.load("wer")

    def compute_matrices(self, preds, refs) -> str:
        cer = self.cer_metric.compute(predictions=preds, references=refs)
        wer = self.wer_metric.compute(predictions=preds, references=refs)
        return f"Test CER: {cer:.4f} | Test WER: {wer:.4f}"
        # return {"cer": cer, "wer": wer}

    def generate_accuracy(self, results_df: DataFrame) -> str:
        exact = (results_df["reference"] == results_df["prediction"]).mean()
        return f"Accuracy: {exact:.5f} -> ({int(exact * len(results_df))} / {len(results_df)})"

    def get_common_errors(self, results_df: DataFrame):
        errors_df = results_df[
            results_df["reference"] != results_df["prediction"]
        ].copy()
        errors_df["pair"] = errors_df["reference"] + "  →  " + errors_df["prediction"]
        return f"""
            Total errors: {len(errors_df)} / {len(results_df)}
            Top 20 Most Frequent Confusion Pairs:\n
            {errors_df['pair'].value_counts().head(20).to_string()}
        """

    def matrix_visualization(self, dataset, preds, n_show=12):
        sample_idx = random.sample(range(len(dataset)), n_show)
        fig, axes = plt.subplots(3, 4, figsize=(14, 9))
        for ax, idx in zip(axes.ravel(), sample_idx):
            row = dataset[idx]
            img = row["image"].convert("RGB")
            label = str(row["label"]).strip().lower()
            pred = preds[idx]
            color = "green" if pred == label else "red"
            ax.imshow(img)
            ax.set_title(f"true: {label}\npred: {pred}", fontsize=9, color=color)
            ax.axis("off")
        plt.tight_layout()
        plt.show()
