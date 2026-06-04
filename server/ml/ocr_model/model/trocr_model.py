import os
import torch
import evaluate
from transformers import TrOCRProcessor, VisionEncoderDecoderModel, PreTrainedModel
from config.settings import OCRConfig


class TrOCRModel:

    def __init__(
        self,
        processor: TrOCRProcessor,
        model: VisionEncoderDecoderModel | PreTrainedModel,
        config: OCRConfig,
    ):
        self.processor = processor
        self.model = model
        self.cer_metric = evaluate.load("cer")

        self._check_resources()

        if os.makedirs(
            config.MODEL_DIR,
            exist_ok=True,
        ) and os.makedirs(
            config.LOG_DIR,
            exist_ok=True,
        ):
            return None

    def _check_resources(self) -> None:
        print(f"PyTorch: {torch.__version__}")
        print(f"CUDA available: {torch.cuda.is_available()}")
        if torch.cuda.is_available():
            print(f"Device: {torch.cuda.get_device_name(0)}")

    def setup_model(self, config: OCRConfig):
        tok = self.processor.tokenizer  # type: ignore
        self.model.config.decoder_start_token_id = tok.bos_token_id or tok.cls_token_id
        self.model.config.pad_token_id = tok.pad_token_id
        self.model.config.eos_token_id = tok.eos_token_id or tok.sep_token_id

        self.model.config.max_length = config.MAX_LENGTH
        self.model.config.num_beams = config.NUM_BEAMS
