import torch
from dataclasses import dataclass
from transformers import Seq2SeqTrainingArguments


@dataclass
class OCRConfig:
    BASE_MODEL: str = "microsoft/trocr-large-handwritten"
    PROJECT_ROOT: str = "/content/drive/MyDrive/medicare_plus_ocr"
    DATA_ROOT: str = f"{PROJECT_ROOT}/data"

    MAX_LENGTH: int = 128
    NUM_BEAMS: int = 5

    BATCH_SIZE: int = 16
    LEARNING_RATE = 2e-5
    EPOCHS: int = 30

    FP16: bool = True

    TRAINING_DIR: str = f"{DATA_ROOT}/raw/Training"
    TESTING_DIR: str = f"{DATA_ROOT}/raw/Testing"
    VALIDATION_DIR: str = f"{DATA_ROOT}/raw/Validation"

    MODEL_DIR: str = f"{PROJECT_ROOT}/models"
    LOG_DIR: str = f"{PROJECT_ROOT}/logs"

    TRAINING_ARGS = Seq2SeqTrainingArguments(
        output_dir=f"{LOG_DIR}/checkpoints",
        overwrite_output_dir=True,
        predict_with_generate=True,
        eval_strategy="epoch",
        save_strategy="epoch",
        logging_strategy="steps",
        logging_steps=50,
        # GPU Power E.g. 4GB
        per_device_train_batch_size=12,
        per_device_eval_batch_size=8,
        fp16=torch.cuda.is_available(),
        learning_rate=LEARNING_RATE,
        num_train_epochs=EPOCHS,
        warmup_steps=200,
        weight_decay=0.01,
        save_total_limit=2,
        load_best_model_at_end=True,
        metric_for_best_model="cer",
        greater_is_better=False,
        report_to="all",
    )
