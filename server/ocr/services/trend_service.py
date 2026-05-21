# ================================================
# Trend Analysis Service
# Statistical: scipy.stats.linregress
# ================================================

import sys, os                                              # ✅ FIXED: moved to top
import numpy as np
from scipy import stats
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.dirname(__file__))))
try:                                                        # ✅ FIXED: added try:
    from ocr.config.database import get_db_connection
except ModuleNotFoundError:
    from ocr.config.database import get_db_connection

NORMAL_RANGES = {
    'FBS':           {'min': 65,   'max': 115,  'unit': 'mg/dl'},
    'HbA1c':         {'min': 0,    'max': 5.7,  'unit': '%'},
    'Cholesterol':   {'min': 0,    'max': 200,  'unit': 'mg/dl'},
    'HDL':           {'min': 40,   'max': 200,  'unit': 'mg/dl'},
    'LDL':           {'min': 0,    'max': 130,  'unit': 'mg/dl'},
    'Triglycerides': {'min': 0,    'max': 150,  'unit': 'mg/dl'},
    'Hemoglobin':    {'min': 12,   'max': 17,   'unit': 'g/dl'},
    'ALT':           {'min': 0,    'max': 56,   'unit': 'U/L'},
    'AST':           {'min': 0,    'max': 40,   'unit': 'U/L'},
    'TSH':           {'min': 0.4,  'max': 4.0,  'unit': 'mU/L'},
    'Creatinine':    {'min': 0.6,  'max': 1.2,  'unit': 'mg/dl'},
}

def statistical_analysis(values: list) -> dict:
    if len(values) < 2:
        return None
    x      = np.arange(len(values), dtype=float)
    y      = np.array(values, dtype=float)
    slope, intercept, r_value, p_value, std_err = stats.linregress(x, y)
    r_squared = r_value ** 2

    if p_value < 0.05:
        trend = "STRONGLY RISING"   if slope > 0 and r_squared > 0.85 else \
                "RISING"            if slope > 0 else \
                "STRONGLY FALLING"  if r_squared > 0.85 else "FALLING"
    else:
        trend = "STABLE"

    return {
        "slope":       round(slope, 3),
        "r_squared":   round(r_squared, 4),
        "p_value":     round(p_value, 4),
        "trend":       trend,
        "significant": p_value < 0.05,
    }

def predict_future(values: list, stats_result: dict, steps: int = 3) -> list:
    if not stats_result or len(values) < 2:
        return []
    n = len(values)
    return [
        round(stats_result['slope'] * (n - 1 + i) +
              (values[0] - stats_result['slope'] * 0), 2)
        for i in range(1, steps + 1)
    ]

def analyze_trends(patient_name: str) -> dict:
    conn = get_db_connection()
    if not conn:
        return {"error": "Database connection failed"}

    cur        = conn.cursor()
    parameters = ['FBS','HbA1c','Cholesterol','HDL','LDL',
                  'Triglycerides','Hemoglobin','ALT','AST','TSH','Creatinine']
    results    = {}
    alerts     = []

    for param in parameters:
        cur.execute("""
            SELECT value, test_date FROM lab_results
            WHERE patient_name LIKE %s AND parameter = %s
            ORDER BY created_at ASC
        """, (f"%{patient_name}%", param))
        rows = cur.fetchall()
        if not rows: continue

        values       = [float(r[0]) for r in rows]
        dates        = [r[1] for r in rows]
        stats_result = statistical_analysis(values)
        if not stats_result: continue

        predictions = predict_future(values, stats_result)

        if 'RISING' in stats_result['trend'] and stats_result['significant']:
            alerts.append({
                "parameter": param,
                "trend":     stats_result['trend'],
                "slope":     stats_result['slope'],
                "r_squared": stats_result['r_squared'],
                "p_value":   stats_result['p_value'],
                "predicted": predictions[-1] if predictions else None,
                "unit":      NORMAL_RANGES.get(param, {}).get('unit', ''),
            })

        results[param] = {
            "readings":    list(zip([str(d) for d in dates], values)),
            "stats":       stats_result,
            "predictions": predictions,
            "unit":        NORMAL_RANGES.get(param, {}).get('unit', ''),
        }

    cur.close(); conn.close()

    return {
        "patient":          patient_name,
        "parameters_found": len(results),
        "analysis":         results,
        "rising_alerts":    alerts,
        "method":           "scipy.stats.linregress",
        "significance":     "p < 0.05",
    }