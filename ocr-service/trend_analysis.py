# ================================================
# Longitudinal Health Trend Analysis
# Statistical Analysis + Future Prediction
# scipy.stats.linregress
# ================================================

import mysql.connector
import numpy as np
from scipy import stats

DB_CONFIG = {
    "host":     "localhost",
    "user":     "root",
    "password": "root123",
    "database": "ocr_lab_reports"
}

# ------------------------------------------------
# Normal Ranges
# ------------------------------------------------
NORMAL_RANGES = {
    'FBS':          {'min': 65,  'max': 115,  'unit': 'mg/dl', 'critical': 200},
    'HbA1c':        {'min': 0,   'max': 5.7,  'unit': '%',     'critical': 8.0},
    'Cholesterol':  {'min': 0,   'max': 200,  'unit': 'mg/dl', 'critical': 300},
    'HDL':          {'min': 40,  'max': 200,  'unit': 'mg/dl', 'critical': 25},
    'LDL':          {'min': 0,   'max': 130,  'unit': 'mg/dl', 'critical': 200},
    'Triglycerides':{'min': 0,   'max': 150,  'unit': 'mg/dl', 'critical': 300},
}

# ------------------------------------------------
# Statistical Trend Analysis
# scipy.stats.linregress
# ------------------------------------------------
def statistical_trend_analysis(values_list):
    if len(values_list) < 2:
        return None

    values = np.array([v[0] for v in values_list], dtype=float)
    x      = np.arange(len(values), dtype=float)

    # Linear Regression
    slope, intercept, r_value, p_value, std_err = stats.linregress(x, values)

    r_squared = r_value ** 2

    # Trend Classification
    if p_value < 0.05:  # Statistically significant
        if slope > 0:
            if r_squared > 0.85:
                trend = "STRONGLY RISING"
            else:
                trend = "RISING"
        else:
            if r_squared > 0.85:
                trend = "STRONGLY FALLING"
            else:
                trend = "FALLING"
    else:
        trend = "STABLE (No significant trend)"

    return {
        "slope":      round(slope, 3),
        "intercept":  round(intercept, 3),
        "r_squared":  round(r_squared, 4),
        "p_value":    round(p_value, 4),
        "std_err":    round(std_err, 3),
        "trend":      trend,
        "n_readings": len(values)
    }

# ------------------------------------------------
# Future Value Prediction
# Linear Regression Extrapolation
# ------------------------------------------------
def predict_future_values(values_list, stats_result, steps_ahead=3):
    if stats_result is None or len(values_list) < 2:
        return []

    values    = [v[0] for v in values_list]
    n         = len(values)
    slope     = stats_result['slope']
    intercept = stats_result['intercept']

    predictions = []
    for i in range(1, steps_ahead + 1):
        future_x   = n - 1 + i
        pred_value = slope * future_x + intercept
        predictions.append(round(pred_value, 2))

    return predictions

# ------------------------------------------------
# Risk Level Assess
# ------------------------------------------------
def assess_risk(parameter, value):
    if parameter not in NORMAL_RANGES:
        return "UNKNOWN"

    ranges = NORMAL_RANGES[parameter]

    if parameter == 'HDL':
        if value < ranges['critical']:
            return "CRITICAL"
        elif value < ranges['min']:
            return "HIGH RISK"
        else:
            return "NORMAL"
    else:
        if value >= ranges['critical']:
            return "CRITICAL"
        elif value > ranges['max']:
            return "HIGH RISK"
        elif value > ranges['max'] * 0.9:
            return "BORDERLINE"
        else:
            return "NORMAL"

# ------------------------------------------------
# Analyze Patient Trends
# ------------------------------------------------
def analyze_patient_trends(patient_name):
    conn   = mysql.connector.connect(**DB_CONFIG)
    cursor = conn.cursor()

    parameters = ['FBS', 'HbA1c', 'Cholesterol', 'HDL', 'LDL', 'Triglycerides']

    print(f"\n{'='*65}")
    print(f"LONGITUDINAL HEALTH TREND ANALYSIS")
    print(f"Patient : {patient_name}")
    print(f"Method  : Linear Regression (scipy.stats.linregress)")
    print(f"{'='*65}")

    patient_trends = []
    rising_params  = []

    for param in parameters:
        cursor.execute("""
            SELECT value, test_date
            FROM lab_results
            WHERE patient_name LIKE %s
            AND parameter = %s
            ORDER BY created_at ASC
        """, (f"%{patient_name}%", param))

        rows = cursor.fetchall()

        if not rows:
            continue

        values_list  = [(float(r[0]), r[1]) for r in rows]
        stats_result = statistical_trend_analysis(values_list)

        if stats_result is None:
            continue

        # Predictions (next 3 readings)
        predictions = predict_future_values(values_list, stats_result, steps_ahead=3)

        # Latest value risk
        latest_value = values_list[-1][0]
        current_risk = assess_risk(param, latest_value)

        # Predicted risk
        future_risk = assess_risk(param, predictions[-1]) if predictions else "N/A"

        print(f"\n📊 {param}:")
        print(f"   Readings  : ", end="")
        for val, date in values_list:
            print(f"{val}({date})", end=" → ")
        print()

        print(f"\n   ── Statistical Analysis ──")
        print(f"   Slope     : {stats_result['slope']:+.3f} per reading "
              f"({'↑ increasing' if stats_result['slope'] > 0 else '↓ decreasing'})")
        print(f"   R²        : {stats_result['r_squared']:.4f} "
              f"({'Strong' if stats_result['r_squared'] > 0.85 else 'Moderate' if stats_result['r_squared'] > 0.5 else 'Weak'} correlation)")
        print(f"   p-value   : {stats_result['p_value']:.4f} "
              f"({'✅ Significant' if stats_result['p_value'] < 0.05 else '⚠️ Not significant'})")
        print(f"   Trend     : {stats_result['trend']}")

        print(f"\n   ── Predictions ──")
        if predictions:
            unit = NORMAL_RANGES.get(param, {}).get('unit', '')
            for i, pred in enumerate(predictions, 1):
                pred_risk = assess_risk(param, pred)
                risk_icon = "🔴" if "CRITICAL" in pred_risk or "HIGH" in pred_risk else "🟡" if "BORDERLINE" in pred_risk else "✅"
                print(f"   Reading +{i}  : {pred} {unit} → {risk_icon} {pred_risk}")
        else:
            print("   Insufficient data for prediction")

        print(f"\n   ── Current Status ──")
        risk_icon = "🔴" if "CRITICAL" in current_risk or "HIGH" in current_risk else "🟡" if "BORDERLINE" in current_risk else "✅"
        print(f"   Now       : {latest_value} → {risk_icon} {current_risk}")
        print(f"   Future    : {predictions[-1] if predictions else 'N/A'} → {future_risk}")

        # Alerts
        alert_msg = ""
        if 'RISING' in stats_result['trend'] and stats_result['p_value'] < 0.05:
            alert_msg = (f"Statistically significant rising trend detected "
                        f"(slope={stats_result['slope']:+.3f}, "
                        f"R²={stats_result['r_squared']:.2f}, "
                        f"p={stats_result['p_value']:.3f}). "
                        f"Predicted value: {predictions[-1] if predictions else 'N/A'}")
            print(f"\n   ⚠️  ALERT: {alert_msg}")
            rising_params.append(param)

        # Save to database
        cursor.execute("""
            INSERT INTO patient_trends
            (patient_name, parameter, value, test_date, trend, alert_message)
            VALUES (%s, %s, %s, %s, %s, %s)
        """, (
            patient_name, param, latest_value,
            values_list[-1][1],
            stats_result['trend'],
            alert_msg if alert_msg else "No significant trend"
        ))

        patient_trends.append({
            "parameter":   param,
            "values":      values_list,
            "stats":       stats_result,
            "predictions": predictions,
            "risk":        current_risk,
            "future_risk": future_risk
        })

    conn.commit()

    # Risk Summary
    print(f"\n{'='*65}")
    print("CLINICAL RISK SUMMARY")
    print(f"{'='*65}")

    critical = [t for t in patient_trends
                if 'CRITICAL' in t['future_risk'] or 'HIGH RISK' in t['future_risk']]
    rising   = [t for t in patient_trends if 'RISING' in t['stats']['trend']]
    stable   = [t for t in patient_trends if 'STABLE' in t['stats']['trend']]

    if critical:
        print("🔴 CRITICAL PREDICTIONS:")
        for c in critical:
            pred = c['predictions'][-1] if c['predictions'] else 'N/A'
            unit = NORMAL_RANGES.get(c['parameter'], {}).get('unit', '')
            print(f"   → {c['parameter']}: Predicted {pred} {unit} ({c['future_risk']})")

    if rising:
        print("\n⚠️  STATISTICALLY SIGNIFICANT RISING TRENDS:")
        for r in rising:
            slope = r['stats']['slope']
            r2    = r['stats']['r_squared']
            p     = r['stats']['p_value']
            print(f"   → {r['parameter']}: slope={slope:+.3f}, R²={r2:.2f}, p={p:.3f}")

    if stable:
        print("\n✅ STABLE PARAMETERS:")
        for s in stable:
            print(f"   → {s['parameter']}")

    print(f"\n📋 Statistical Method: Linear Regression (scipy.stats.linregress)")
    print(f"📋 Significance Level: p < 0.05")
    print(f"📋 Readings Analyzed: {len(values_list)} per parameter")

    if rising:
        print(f"\n📱 RECOMMENDATION: Schedule immediate doctor consultation!")
        print(f"   Early intervention recommended based on trend analysis.")
    else:
        print(f"\n✅ No significant trends - Continue regular monitoring")

    print(f"{'='*65}")

    cursor.close()
    conn.close()

    return patient_trends

# ------------------------------------------------
# Add Sample Data
# ------------------------------------------------
def add_sample_trend_data():
    conn   = mysql.connector.connect(**DB_CONFIG)
    cursor = conn.cursor()

    cursor.execute("""
        DELETE FROM lab_results
        WHERE image_file = 'simulated_data.jpg'
    """)

    sample_data = [
        ('Mr Gamage','61','Jan/2025','Bio Chemistry','FBS',         95.0, 'mg/dl','NORMAL',      ''),
        ('Mr Gamage','61','Mar/2025','Bio Chemistry','FBS',        108.0, 'mg/dl','NORMAL',      ''),
        ('Mr Gamage','61','Jun/2025','Bio Chemistry','FBS',        118.0, 'mg/dl','PRE-DIABETIC','FBS is PRE-DIABETIC'),
        ('Mr Gamage','61','Aug/2025','Bio Chemistry','FBS',        135.0, 'mg/dl','HIGH',        'FBS is HIGH'),
        ('Mr Gamage','61','Jan/2025','Bio Chemistry','HbA1c',        5.8, '%',    'PRE-DIABETIC','HbA1c is PRE-DIABETIC'),
        ('Mr Gamage','61','Mar/2025','Bio Chemistry','HbA1c',        6.1, '%',    'PRE-DIABETIC','HbA1c is PRE-DIABETIC'),
        ('Mr Gamage','61','Jun/2025','Bio Chemistry','HbA1c',        6.4, '%',    'PRE-DIABETIC','HbA1c is PRE-DIABETIC'),
        ('Mr Gamage','61','Aug/2025','Bio Chemistry','HbA1c',        6.8, '%',    'DIABETIC',    'HbA1c is DIABETIC'),
        ('Mr Gamage','61','Jan/2025','Bio Chemistry','Cholesterol', 165.0,'mg/dl','NORMAL',      ''),
        ('Mr Gamage','61','Mar/2025','Bio Chemistry','Cholesterol', 172.0,'mg/dl','NORMAL',      ''),
        ('Mr Gamage','61','Jun/2025','Bio Chemistry','Cholesterol', 185.0,'mg/dl','NORMAL',      ''),
        ('Mr Gamage','61','Aug/2025','Bio Chemistry','Cholesterol', 210.0,'mg/dl','BORDERLINE',  'Cholesterol is BORDERLINE'),
        ('Mr Gamage','61','Jan/2025','Bio Chemistry','HDL',          58.0,'mg/dl','GOOD',        ''),
        ('Mr Gamage','61','Mar/2025','Bio Chemistry','HDL',          55.0,'mg/dl','GOOD',        ''),
        ('Mr Gamage','61','Jun/2025','Bio Chemistry','HDL',          50.0,'mg/dl','GOOD',        ''),
        ('Mr Gamage','61','Aug/2025','Bio Chemistry','HDL',          54.6,'mg/dl','GOOD',        ''),
        ('Mr Gamage','61','Jan/2025','Bio Chemistry','LDL',          75.0,'mg/dl','NORMAL',      ''),
        ('Mr Gamage','61','Mar/2025','Bio Chemistry','LDL',          78.0,'mg/dl','NORMAL',      ''),
        ('Mr Gamage','61','Jun/2025','Bio Chemistry','LDL',          79.3,'mg/dl','NORMAL',      ''),
        ('Mr Gamage','61','Aug/2025','Bio Chemistry','LDL',          82.0,'mg/dl','NORMAL',      ''),
        ('Mr Gamage','61','Jan/2025','Bio Chemistry','Triglycerides',65.0,'mg/dl','NORMAL',      ''),
        ('Mr Gamage','61','Mar/2025','Bio Chemistry','Triglycerides',68.0,'mg/dl','NORMAL',      ''),
        ('Mr Gamage','61','Jun/2025','Bio Chemistry','Triglycerides',72.0,'mg/dl','NORMAL',      ''),
        ('Mr Gamage','61','Aug/2025','Bio Chemistry','Triglycerides',68.0,'mg/dl','NORMAL',      ''),
    ]

    for row in sample_data:
        cursor.execute("""
            INSERT INTO lab_results
            (patient_name, age, test_date, test_type,
             parameter, value, unit, status, alert_message, image_file)
            VALUES (%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)
        """, (*row, 'simulated_data.jpg'))

    conn.commit()
    print("✅ Sample data added!")
    print("   Mr. Gamage - 4 months (Jan-Aug 2025)")
    cursor.close()
    conn.close()

# ------------------------------------------------
# View Saved Trends
# ------------------------------------------------
def view_saved_trends():
    conn   = mysql.connector.connect(**DB_CONFIG)
    cursor = conn.cursor()

    cursor.execute("""
        DELETE FROM patient_trends
        WHERE id NOT IN (
            SELECT id FROM (
                SELECT MAX(id) as id
                FROM patient_trends
                GROUP BY patient_name, parameter
            ) t
        )
    """)
    conn.commit()

    cursor.execute("""
        SELECT patient_name, parameter, value,
               test_date, trend, alert_message
        FROM patient_trends
        ORDER BY created_at DESC
        LIMIT 20
    """)
    rows = cursor.fetchall()

    print(f"\n{'='*70}")
    print("SAVED TREND RECORDS")
    print(f"{'='*70}")
    print(f"{'Patient':<15} {'Parameter':<15} {'Value':<8} {'Trend':<25} {'Alert'}")
    print("-"*70)

    for row in rows:
        patient, param, value, date, trend, alert = row
        alert_icon = "⚠️ YES" if alert and "slope" in alert else "✅ No"
        print(f"{str(patient):<15} {str(param):<15} "
              f"{str(value):<8} {str(trend):<25} {alert_icon}")

    print(f"{'='*70}")
    print(f"Total: {len(rows)} records")
    cursor.close()
    conn.close()

# ------------------------------------------------
# MAIN
# ------------------------------------------------
if __name__ == "__main__":

    # Clear old trend records
    conn   = mysql.connector.connect(**DB_CONFIG)
    cursor = conn.cursor()
    cursor.execute("DELETE FROM patient_trends")
    conn.commit()
    cursor.close()
    conn.close()

    print("="*50)
    print("LONGITUDINAL TREND ANALYSIS SYSTEM")
    print("Group 13 - Medicare Plus Project")
    print("Statistical Method: scipy.stats.linregress")
    print("="*50)
    print("1. Add sample data + Analyze Mr. Gamage")
    print("2. Analyze existing patient")
    print("3. View saved trends")
    print("="*50)

    choice = input("Select (1/2/3): ")

    if choice == "1":
        add_sample_trend_data()
        analyze_patient_trends("Mr Gamage")
    elif choice == "2":
        name = input("Patient name: ")
        analyze_patient_trends(name)
    elif choice == "3":
        view_saved_trends()
    else:
        print("Invalid option!")
