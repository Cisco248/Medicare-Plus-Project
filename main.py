from fastapi import FastAPI
from pydantic import BaseModel
from datetime import datetime

app = FastAPI()

class ActivityData(BaseModel):
    patient_id: str
    steps: int
    heart_rate: int
    timestamp: str = str(datetime.now())

@app.get("/")
def home():
    return {"message": "Activity Tracker API is running!"}

@app.post("/activity")
def receive_activity(data: ActivityData):
    print(f"Data received: {data}")
    return {"status": "success", "data": data}