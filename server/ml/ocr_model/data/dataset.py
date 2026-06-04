import torch
from torch.utils.data import Dataset


class OCRDataset(Dataset):
    def __init__(self, hf_split, processor, max_target_length=64):
        self.split = hf_split
        self.processor = processor
        self.max_target_length = max_target_length

    def __len__(self):
        return len(self.split)

    def __getitem__(self, idx):
        row = self.split[idx]
        image = row["image"].convert("RGB")
        text = row["label"]
        pixel_values = self.processor(image, return_tensors="pt").pixel_values[0]
        labels = self.processor.tokenizer(
            text,
            padding="max_length",
            max_length=self.max_target_length,
            truncation=True,
        ).input_ids
        labels = [
            t if t != self.processor.tokenizer.pad_token_id else -100 for t in labels
        ]
        return {"pixel_values": pixel_values, "labels": torch.tensor(labels)}
