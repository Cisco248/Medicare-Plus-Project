import pandas as pd
import numpy as np
from datetime import datetime, timedelta
import random

# Simulate 30 days of patient activity data
def generate_patient_data(patient_id: str, days: int = 30):
    data = []
    base_date = datetime.now() - timedelta(days=days)
    
    for i in range(days):
        date = base_date + timedelta(days=i)
        data.append({
            "patient_id": patient_id,
            "date": date.strftime("%Y-%m-%d"),
            "steps": random.randint(3000, 12000),
            "heart_rate": random.randint(60, 100),
        })
    return pd.DataFrame(data)

# Analyze activity pattern
def analyze_pattern(patient_id: str):
    df = generate_patient_data(patient_id)
    
    avg_steps = df["steps"].mean()
    avg_hr = df["heart_rate"].mean()
    
    return {
        "patient_id": patient_id,
        "avg_daily_steps": round(avg_steps, 2),
        "avg_heart_rate": round(avg_hr, 2),
        "status": "Active" if avg_steps > 7000 else "Low Activity"
    }

# Test
if __name__ == "__main__":
    result = analyze_pattern("P001")
    print(result)