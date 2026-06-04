import evaluate
import numpy as np
from typing import Dict
from config.settings import OCRConfig
from transformers import Seq2SeqTrainer, default_data_collator


class OCRTrainer:
    def __init__(self, model_obj, config: OCRConfig, training_data, validation_data):
        self.model_obj = model_obj
        self.config = config
        self.cer_metric = evaluate.load("cer")

        self.seq_model = Seq2SeqTrainer(
            model=self.model_obj,
            args=config.TRAINING_ARGS,
            train_dataset=training_data,
            eval_dataset=validation_data,
            processing_class=self.model_obj.processor.feature_extractor,
            compute_metrics=self._compute_metrics,
            data_collator=default_data_collator,
        )

    def _compute_metrics(self, eval_pred) -> Dict:
        pred_ids, label_ids = eval_pred
        label_ids = np.where(
            label_ids != -100,
            label_ids,
            self.processor.tokenizer.pad_token_id,  # type: ignore
        )
        self.label_str = self.model_obj.processor.batch_decode(
            label_ids,
            skip_special_tokens=True,
        )
        self.pred_str = self.model_obj.processor.batch_decode(
            pred_ids,
            skip_special_tokens=True,
            predict_with_generate=True,
        )
        cer = self.cer_metric.compute(
            predictions=self.pred_str,
            references=self.label_str,
        )
        return {"cer": cer}

    def get_preds(self):
        return self.pred_str

    def get_refs(self):
        return self.label_str

    def train(self) -> Seq2SeqTrainer:
        return self.seq_model.train()

    def save_model(self):
        self.seq_model.save_model(self.config.MODEL_DIR)
        self.model_obj.processor.save_pretrained(self.config.MODEL_DIR)
        print(f"Model saved to: {self.config.MODEL_DIR}")
