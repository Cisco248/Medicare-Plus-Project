# ================================================
# Flask API - OCR Lab Report System - FINAL
# ================================================

from flask import Flask, request, jsonify
import pytesseract
import cv2
import re
import os
import numpy as np
import mysql.connector

app = Flask(__name__)

pytesseract.pytesseract.tesseract_cmd = r'C:\Program Files\Tesseract-OCR\tesseract.exe'

DB_CONFIG = {
    "host":     "localhost",
    "user":     "root",
    "password": "root123",
    "database": "ocr_lab_reports"
}

API_KEY = "team13_ocr_2026"

def check_api_key():
    key = request.headers.get('X-API-Key')
    if key != API_KEY:
        return False
    return True

def preprocess_image(image_path):
    img = cv2.imread(image_path)
    if img is None:
        return None
    scale  = 2.0
    width  = int(img.shape[1] * scale)
    height = int(img.shape[0] * scale)
    img    = cv2.resize(img, (width, height), interpolation=cv2.INTER_CUBIC)
    gray   = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
    denoised = cv2.fastNlMeansDenoising(gray, h=10)
    return denoised

def extract_text(image_path):
    processed = preprocess_image(image_path)
    if processed is None:
        return ""
    configs   = ['--psm 6 --oem 3', '--psm 4 --oem 3', '--psm 3 --oem 3']
    best_text = ""
    for config in configs:
        text = pytesseract.image_to_string(processed, lang='eng', config=config)
        if len(text) > len(best_text):
            best_text = text
    return best_text

def extract_values(text):
    values     = {}
    text_clean = re.sub(r'[ \t]+', ' ', text)

    # Patient Name
    patient = re.search(
        r'(?:Patient|Name)\s*[:\-]?\s*([A-Za-z][A-Za-z\s\.]+?)(?:\n|Age|Date|Category|Sample|$)',
        text_clean, re.IGNORECASE)
    if patient:
        values['patient_name'] = patient.group(1).strip()

    # Age
    age = re.search(r'Age\s*[:\-]?\s*(\d+)', text_clean, re.IGNORECASE)
    if age:
        values['age'] = age.group(1)

    # Date
    for pattern in [
        r'Date\s*[:\-]?\s*(\d{1,2}[\/\-\.]\d{1,2}[\/\-\.]\d{2,4})',
        r'Date\s*[:\-]?\s*(\d{1,2}[\/\-][A-Za-z]{3}[\/\-]\d{2,4})',
        r'Collection\s*Date\s*[:\-]?\s*(\d{1,2}[\-][A-Za-z]{3}[\-]\d{2,4})',
        r'Receive\s*Date\s*[:\-]?\s*(\d{1,2}[\-][A-Za-z]{3}[\-]\d{2,4})',
    ]:
        m = re.search(pattern, text_clean, re.IGNORECASE)
        if m:
            values['date'] = m.group(1)
            break

    # FBS
    for pattern in [
        r'Fasting\s*Blood\s*Sugar\s*[:\-]?\s*(\d+\.?\d*)',
        r'Blood\s*Sugar\s*[-]\s*fasting\s*[^\d]*(\d+\.?\d*)',
        r'FBS\s*[:\-]?\s*(\d+\.?\d*)',
        r'Blood\s*Sugar[^\d]*(\d{2,3}\.?\d*)\s*mg',
        r'Blood\s*Glucose\s*Fasting\s*[:\-]?\s*(\d+\.?\d*)',
        r'Blood\s*Glucose\s*\(F\)\s*[:\-]?\s*(\d+\.?\d*)',
    ]:
        m = re.search(pattern, text_clean, re.IGNORECASE)
        if m:
            val = float(m.group(1))
            if 40 < val < 600:
                values['fasting_blood_sugar'] = val
                break

    # HbA1c
    for pattern in [
        r'HbA1c\s*[:\-]?\s*(\d+\.?\d*)\s*%',
        r'HbAlc\s*[:\-]?\s*(\d+\.?\d*)\s*%',
        r'Hb\s*A1c\s*[:\-]?\s*(\d+\.?\d*)',
        r'Glyco[^\d]*(\d+\.?\d*)\s*%',
    ]:
        m = re.search(pattern, text_clean, re.IGNORECASE)
        if m:
            val = float(m.group(1))
            if 3 < val < 20:
                values['hba1c'] = val
                break

    # Total Cholesterol
    for pattern in [
        r'Total\s*Cholesterol\s*[:\-]\s*(\d+\.?\d*)',
        r'Total\s*Cholesterol\s+(\d+\.?\d*)\s*mg',
        r'\d+\s+Cholesterol\s+(\d+\.?\d*)\s*mg',
        r'T\.?\s*Cho[^\d]*(\d+\.?\d*)',
    ]:
        m = re.search(pattern, text_clean, re.IGNORECASE | re.MULTILINE)
        if m:
            val = float(m.group(1))
            if 50 < val < 600:
                values['total_cholesterol'] = val
                break

    # HDL
    for pattern in [
        r'HDL\s*Direct\s*[^\d]*(\d+\.?\d*)',
        r'HDL\s*[:\-]\s*(\d+\.?\d*)',
        r'H\.D\.L\s*[:\-]\s*(\d+\.?\d*)',
        r'HDL\s+(\d+\.?\d*)\s*mg',
        r'HDL[^\d\n]{0,5}(\d+\.?\d*)\s*mg',
    ]:
        m = re.search(pattern, text_clean, re.IGNORECASE | re.MULTILINE)
        if m:
            val = float(m.group(1))
            if val > 200: val = val / 100
            if 10 < val < 200:
                values['hdl'] = val
                break

    if 'hdl' not in values:
        for line in text_clean.split('\n'):
            if re.search(r'\bHDL\b|H\.D\.L', line, re.IGNORECASE):
                for n in re.findall(r'\d+\.?\d*', line):
                    val = float(n)
                    if val > 200: val = val / 100
                    if 10 < val < 200:
                        values['hdl'] = val
                        break
            if 'hdl' in values:
                break

    # LDL
    ldl_found = False
    for line in text_clean.split('\n'):
        if re.search(r'\bLDL\b|\bLDL\s*CHOLESTEROL\b', line, re.IGNORECASE):
            for n in re.findall(r'\d+\.?\d*', line):
                val = float(n)
                if val > 400: val = val / 100
                if 10 < val < 400:
                    values['ldl'] = val
                    ldl_found = True
                    break
        if ldl_found: break

    if not ldl_found:
        for line in text_clean.split('\n'):
            if re.search(r'[iIlL][DdOo][Ll]', line):
                if re.search(r'Ratio|T\.Cho|CHO:HDL', line, re.IGNORECASE):
                    continue
                for n in re.findall(r'\d+\.?\d*', line):
                    val = float(n)
                    if val > 400: val = val / 100
                    if 10 < val < 400:
                        values['ldl'] = val
                        ldl_found = True
                        break
            if ldl_found: break

    if not ldl_found:
        lines = text_clean.split('\n')
        for i, line in enumerate(lines):
            if re.search(r'H\.?D\.?L', line, re.IGNORECASE):
                for j in range(i+1, min(i+3, len(lines))):
                    next_line = lines[j].strip()
                    if re.search(r'Ratio|T\.Cho|VLDL|CHO', next_line, re.IGNORECASE):
                        continue
                    for n in re.findall(r'\d+\.?\d*', next_line):
                        val = float(n)
                        if val > 400: val = val / 100
                        if 10 < val < 400:
                            values['ldl'] = val
                            ldl_found = True
                            break
                    if ldl_found: break
            if ldl_found: break

    # Triglycerides
    for pattern in [
        r'Serum\s*Triglycerides\s*[:\-]\s*(\d+\.?\d*)',
        r'Triglycerides\s*[:\-]?\s*(\d+\.?\d*)\s*mg',
        r'Triglyceride\s*Level\s+(\d+\.?\d*)',
        r'Triglyceride[^\d\n]{0,10}(\d{2,3}\.?\d*)',
        r'\d+\s+Triglycerides\s+(\d+\.?\d*)\s*mg',
        r'T[nr][^\s]*glyc[^\s]*\s+(\d+\.?\d*)\s*mg',
        r'\d+\s+T[nr][^\s]*\s+(\d+\.?\d*)\s*mg',
    ]:
        m = re.search(pattern, text_clean, re.IGNORECASE)
        if m:
            val = float(m.group(1))
            if 20 < val < 1000:
                values['triglycerides'] = val
                break

    return values

def get_status(key, val):
    if key == 'fasting_blood_sugar':
        if val < 65:   return 'VERY LOW'
        if val <= 115: return 'NORMAL'
        if val <= 125: return 'PRE-DIABETIC'
        return 'HIGH'
    if key == 'hba1c':
        if val < 5.7:  return 'NORMAL'
        if val < 6.5:  return 'PRE-DIABETIC'
        return 'DIABETIC'
    if key == 'total_cholesterol':
        if val < 200:  return 'NORMAL'
        if val < 250:  return 'BORDERLINE'
        return 'HIGH'
    if key == 'hdl':
        return 'GOOD' if val >= 40 else 'LOW'
    if key == 'ldl':
        return 'NORMAL' if val < 130 else 'HIGH'
    if key == 'triglycerides':
        return 'NORMAL' if val < 150 else 'HIGH'
    return 'UNKNOWN'

def save_to_database(values, image_file):
    try:
        conn   = mysql.connector.connect(**DB_CONFIG)
        cursor = conn.cursor()
        param_map = {
            'fasting_blood_sugar': ('FBS',          'mg/dl'),
            'hba1c':               ('HbA1c',         '%'),
            'total_cholesterol':   ('Cholesterol',   'mg/dl'),
            'hdl':                 ('HDL',           'mg/dl'),
            'ldl':                 ('LDL',           'mg/dl'),
            'triglycerides':       ('Triglycerides', 'mg/dl'),
        }
        for key, (param, unit) in param_map.items():
            if key in values:
                val    = values[key]
                status = get_status(key, val)
                alert  = f"{param} is {status}" if status not in ('NORMAL', 'GOOD') else ""
                cursor.execute("""
                    INSERT INTO lab_results
                    (patient_name, age, test_date, test_type,
                     parameter, value, unit, status, alert_message, image_file)
                    VALUES (%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)
                """, (
                    values.get('patient_name', 'Unknown'),
                    values.get('age', '0'),
                    values.get('date', 'Unknown'),
                    'Bio Chemistry',
                    param, val, unit, status, alert, image_file
                ))
        conn.commit()
        cursor.close()
        conn.close()
        return True
    except Exception as e:
        print(f"Database Error: {e}")
        return False

# ================================================
# API ENDPOINTS
# ================================================

@app.route('/', methods=['GET'])
def home():
    return jsonify({
        "message": "OCR Lab Report API is Running!",
        "version": "1.0",
        "team":    "Group 13 - Medicare Plus Project",
        "endpoints": {
            "upload":           "/upload-report",
            "results":          "/get-results",
            "alerts":           "/get-alerts",
            "patient_results":  "/get-patient-results/<name>",
            "dashboard":        "/dashboard-summary",
            "add_patient":      "/add-patient"
        }
    })

@app.route('/upload-report', methods=['POST'])
def upload_report():
    try:
        if 'image' not in request.files:
            return jsonify({"error": "No image file found!"}), 400

        file       = request.files['image']
        image_path = f"uploads/{file.filename}"
        os.makedirs("uploads", exist_ok=True)
        file.save(image_path)

        text   = extract_text(image_path)
        values = extract_values(text)

        if not values:
            return jsonify({"error": "Could not extract values!"}), 400

        results   = {}
        alerts    = []
        param_map = {
            'fasting_blood_sugar': 'FBS',
            'hba1c':               'HbA1c',
            'total_cholesterol':   'Cholesterol',
            'hdl':                 'HDL',
            'ldl':                 'LDL',
            'triglycerides':       'Triglycerides',
        }

        for key, param in param_map.items():
            if key in values:
                val    = values[key]
                status = get_status(key, val)
                results[param] = {"value": val, "status": status}
                if status not in ('NORMAL', 'GOOD'):
                    alerts.append(f"{param} is {status}: {val}")

        save_to_database(values, file.filename)

        return jsonify({
            "success": True,
            "patient": values.get('patient_name', 'Unknown'),
            "age":     values.get('age', 'Unknown'),
            "date":    values.get('date', 'Unknown'),
            "results": results,
            "alerts":  alerts,
            "message": "Report analyzed and saved successfully!"
        })

    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/get-results', methods=['GET'])
def get_results():
    try:
        conn   = mysql.connector.connect(**DB_CONFIG)
        cursor = conn.cursor()
        cursor.execute("SELECT * FROM lab_results ORDER BY created_at DESC")
        rows = cursor.fetchall()

        results = []
        for row in rows:
            id_, patient, age, date, test_type, param, value, unit, status, alert, image, created = row
            results.append({
                "id":           id_,
                "patient_name": patient,
                "age":          age,
                "test_date":    date,
                "parameter":    param,
                "value":        value,
                "unit":         unit,
                "status":       status,
                "alert":        alert,
                "image_file":   image,
                "created_at":   str(created)
            })

        cursor.close()
        conn.close()
        return jsonify({"success": True, "total": len(results), "data": results})

    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/get-alerts', methods=['GET'])
def get_alerts():
    try:
        conn   = mysql.connector.connect(**DB_CONFIG)
        cursor = conn.cursor()
        cursor.execute("""
            SELECT * FROM lab_results
            WHERE status NOT IN ('NORMAL', 'GOOD')
            ORDER BY created_at DESC
        """)
        rows = cursor.fetchall()

        alerts = []
        for row in rows:
            id_, patient, age, date, test_type, param, value, unit, status, alert, image, created = row
            alerts.append({
                "patient":   patient,
                "date":      date,
                "parameter": param,
                "value":     value,
                "unit":      unit,
                "status":    status,
                "alert":     alert
            })

        cursor.close()
        conn.close()
        return jsonify({
            "success":      True,
            "total_alerts": len(alerts),
            "alerts":       alerts
        })

    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/get-patient-results/<patient_name>', methods=['GET'])
def get_patient_results(patient_name):
    try:
        conn   = mysql.connector.connect(**DB_CONFIG)
        cursor = conn.cursor()
        cursor.execute("""
            SELECT * FROM lab_results
            WHERE patient_name LIKE %s
            ORDER BY created_at DESC
        """, (f"%{patient_name}%",))
        rows = cursor.fetchall()

        results = []
        for row in rows:
            id_, patient, age, date, test_type, param, value, unit, status, alert, image, created = row
            results.append({
                "id":           id_,
                "patient_name": patient,
                "age":          age,
                "test_date":    date,
                "parameter":    param,
                "value":        value,
                "unit":         unit,
                "status":       status,
                "alert":        alert,
                "created_at":   str(created)
            })

        cursor.close()
        conn.close()
        return jsonify({
            "success": True,
            "patient": patient_name,
            "total":   len(results),
            "data":    results
        })

    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/dashboard-summary', methods=['GET'])
def dashboard_summary():
    try:
        conn   = mysql.connector.connect(**DB_CONFIG)
        cursor = conn.cursor()

        cursor.execute("SELECT COUNT(*) FROM lab_results")
        total = cursor.fetchone()[0]

        cursor.execute("SELECT COUNT(*) FROM lab_results WHERE status IN ('NORMAL','GOOD')")
        normal = cursor.fetchone()[0]

        cursor.execute("SELECT COUNT(*) FROM lab_results WHERE status NOT IN ('NORMAL','GOOD')")
        abnormal = cursor.fetchone()[0]

        cursor.execute("SELECT COUNT(DISTINCT patient_name) FROM lab_results")
        patients = cursor.fetchone()[0]

        cursor.execute("""
            SELECT patient_name, parameter, value, unit, status, test_date
            FROM lab_results
            WHERE status NOT IN ('NORMAL','GOOD')
            ORDER BY created_at DESC LIMIT 5
        """)
        alert_rows    = cursor.fetchall()
        recent_alerts = []
        for row in alert_rows:
            recent_alerts.append({
                "patient":   row[0],
                "parameter": row[1],
                "value":     row[2],
                "unit":      row[3],
                "status":    row[4],
                "date":      row[5]
            })

        cursor.close()
        conn.close()

        return jsonify({
            "success":        True,
            "total_records":  total,
            "normal_count":   normal,
            "abnormal_count": abnormal,
            "total_patients": patients,
            "recent_alerts":  recent_alerts
        })

    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/add-patient', methods=['POST'])
def add_patient():
    try:
        data         = request.get_json()
        patient_name = data.get('patient_name')
        age          = data.get('age')
        sex          = data.get('sex')

        conn   = mysql.connector.connect(**DB_CONFIG)
        cursor = conn.cursor()
        cursor.execute("""
            INSERT INTO patients (patient_name, age, sex)
            VALUES (%s, %s, %s)
        """, (patient_name, age, sex))
        conn.commit()

        patient_id = cursor.lastrowid
        cursor.close()
        conn.close()

        return jsonify({
            "success":    True,
            "patient_id": patient_id,
            "message":    f"Patient {patient_name} added successfully!"
        })

    except Exception as e:
        return jsonify({"error": str(e)}), 500

if __name__ == '__main__':
    print("="*50)
    print("OCR Lab Report API Starting...")
    print("URL: http://localhost:5000")
    print("Team: Group 13 - Medicare Plus Project")
    print("="*50)
    app.run(debug=True, host='0.0.0.0', port=5000)