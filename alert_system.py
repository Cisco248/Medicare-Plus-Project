from pattern_analysis import analyze_pattern
from datetime import datetime

# Alert thresholds
LOW_STEPS = 5000
HIGH_HEART_RATE = 90

def check_alerts(patient_id: str):
    result = analyze_pattern(patient_id)
    alerts = []

    # Check low activity
    if result["avg_daily_steps"] < LOW_STEPS:
        alerts.append({
            "type": "LOW_ACTIVITY",
            "message": f"Patient {patient_id} has low activity! "
                      f"Average steps: {result['avg_daily_steps']}",
            "severity": "HIGH"
        })

    # Check high heart rate
    if result["avg_heart_rate"] > HIGH_HEART_RATE:
        alerts.append({
            "type": "HIGH_HEART_RATE",
            "message": f"Patient {patient_id} has high heart rate! "
                      f"Average HR: {result['avg_heart_rate']}",
            "severity": "HIGH"
        })

    return {
        "patient_id": patient_id,
        "timestamp": str(datetime.now()),
        "alerts": alerts if alerts else ["No alerts - Patient is healthy!"]
    }

# Test
if __name__ == "__main__":
    result = check_alerts("P001")
    print(result)