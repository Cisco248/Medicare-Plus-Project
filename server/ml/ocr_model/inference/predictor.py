import torch
from config.settings import OCRConfig


class OCRPredictor:
    def __init__(self, model, processor, config: OCRConfig):
        self.device = "cuda" if torch.cuda.is_available() else "cpu"
        self.config = config
        self.processor = processor
        self.model = model.to(self.device)

    def predict(self, image):
        pixel_values = self.processor(
            image,
            return_tensors="pt",
        ).pixel_values.to(self.device)
        with torch.no_grad():
            ids = self.model.generate(
                pixel_values,
                max_length=self.config.MAX_LENGTH,
                num_beams=self.config.NUM_BEAMS,
                num_return_sequences=1,
                early_stopping=True,
            )
        return self.processor.batch_decode(
            ids,
            skip_special_tokens=True,
        )[0]
