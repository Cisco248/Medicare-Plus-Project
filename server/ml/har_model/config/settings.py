from dataclasses import dataclass
import os


@dataclass
class Settings:
    PROJECT_ROOT = "/content/drive/MyDrive/FYP/Project_Data/"
    DATA_ZIP_PATH = os.path.join(PROJECT_ROOT, "har_dataset.zip")
    EXACT_PATH = os.path.join(PROJECT_ROOT, "Raw")
