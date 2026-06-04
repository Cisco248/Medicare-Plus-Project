from typing import Dict, List
from matplotlib import pyplot as plt
import pandas as pd
from pandas import DataFrame
from PIL import Image as PILImage
from datasets import Dataset as HFDataset, Image


class Preprocessing:
    def __init__(self):
        pass

    def _normalize_label(self, s: str) -> str:
        return str(s).strip().lower()

    def _lower_case(self, df: DataFrame) -> Dict[str, str]:
        return {c.lower(): c for c in df.columns}

    def _image_column_reader(self, column: Dict) -> str | None:
        return next(
            (column[k] for k in column if "image" in k or "file" in k or "name" in k),
            None,
        )

    def _label_column_reader(self, column: Dict) -> str | None:
        return next(
            (
                column[k]
                for k in column
                if "medicine" in k or "label" in k or "word" in k or "text" in k
            ),
            None,
        )

    def load_files(
        self,
        csv_path: List,
        image_path: List,
    ) -> DataFrame:
        records: List = []
        for csv_file in csv_path:
            try:
                df = pd.read_csv(csv_file)
                cols_lower = self._lower_case(df)
                img_col = self._image_column_reader(cols_lower)
                label_col = self._label_column_reader(cols_lower)
                if img_col and label_col and img_col != label_col:
                    print(f"""
                        File Records:\n 
                        \tPath: {csv_path}\n  
                        \tImage Column Count: {img_col}\n  
                        \tLabel Column Count: {label_col}
                    """)
                    path_lookup = {p.name: p for p in image_path}

                    for _, row in df.iterrows():
                        img_name = str(row[img_col]).strip()
                        label = self._normalize_label(row[label_col])
                        p = (
                            path_lookup.get(img_name)
                            or path_lookup.get(img_name + ".png")
                            or path_lookup.get(img_name + ".jpg")
                        )
                        if p is not None and label:
                            records.append({"image_path": str(p), "label": label})
                    break
            except Exception as e:
                print(f"Error: {e}")
        return (
            DataFrame(records)
            .drop_duplicates(subset=["image_path"])
            .reset_index(drop=True)
        )

    def display_dataset_info(self, df: DataFrame):
        print(f"Total samples: {len(df)}")
        print(f'Unique labels: {df["label"].nunique()}')
        df.head()

    def display_dataset_explore(self, df: DataFrame):
        label_counts = df["label"].value_counts()
        print(f"Drug Names: {label_counts.__len__()}")
        sample = df.sample(min(12, len(df)), random_state=42).reset_index(drop=True)
        fig, axes = plt.subplots(3, 4, figsize=(14, 8))
        for ax, (_, row) in zip(axes.ravel(), sample.iterrows()):
            img = PILImage.open(row["image_path"]).convert("RGB")
            ax.imshow(img)
            ax.set_title(row["label"], fontsize=10)
            ax.axis("off")
        plt.tight_layout()
        plt.show()

    def to_hf(self, df) -> HFDataset:
        ds = HFDataset.from_pandas(
            df[["image_path", "label"]].rename(columns={"image_path": "image"})
        )
        return ds.cast_column("image", Image())
