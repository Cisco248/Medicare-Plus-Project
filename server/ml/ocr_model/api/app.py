from fastapi import FastAPI, UploadFile
from PIL import Image

from server.ml.ocr_model.inference.predictor import OCRPredictor

app = FastAPI()


@app.post("/ocr")
async def ocr(file: UploadFile):
    image = Image.open(file.file).convert("RGB")
    text = OCRPredictor.predict(image)
    return {"text": text}
