from fastapi import FastAPI
from pydantic import BaseModel
from datetime import datetime
from pattern_analysis import analyze_pattern
from alert_system import check_alerts
from health_prediction import predict_health_risk

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
    return {"status": "success", "data": data}

@app.get("/pattern/{patient_id}")
def get_pattern(patient_id: str):
    return analyze_pattern(patient_id)

@app.get("/alerts/{patient_id}")
def get_alerts(patient_id: str):
    return check_alerts(patient_id)

@app.get("/predict/{patient_id}")
def get_prediction(patient_id: str):
    return predict_health_risk(patient_id)