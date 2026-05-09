import random
from pattern_analysis import analyze_pattern

# Risk prediction based on activity data
def predict_health_risk(patient_id: str):
    result = analyze_pattern(patient_id)
    
    steps = result["avg_daily_steps"]
    heart_rate = result["avg_heart_rate"]
    
    # Risk scoring
    risk_score = 0
    risk_factors = []

    # Steps based risk
    if steps < 3000:
        risk_score += 40
        risk_factors.append("Very low physical activity")
    elif steps < 5000:
        risk_score += 25
        risk_factors.append("Low physical activity")
    elif steps < 7000:
        risk_score += 10
        risk_factors.append("Moderate physical activity")

    # Heart rate based risk
    if heart_rate > 95:
        risk_score += 40
        risk_factors.append("High resting heart rate")
    elif heart_rate > 85:
        risk_score += 20
        risk_factors.append("Elevated heart rate")

    # Risk level
    if risk_score >= 50:
        risk_level = "HIGH"
    elif risk_score >= 25:
        risk_level = "MEDIUM"
    else:
        risk_level = "LOW"

    return {
        "patient_id": patient_id,
        "risk_level": risk_level,
        "risk_score": risk_score,
        "risk_factors": risk_factors if risk_factors else ["No risk factors"],
        "avg_steps": steps,
        "avg_heart_rate": heart_rate
    }

# Test
if __name__ == "__main__":
    result = predict_health_risk("P001")
    print(result)