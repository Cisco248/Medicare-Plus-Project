# ================================================
# Sri Lanka Lab Report OCR - ALL HOSPITALS
# ================================================

import pytesseract
import cv2
import re
import os
import numpy as np

pytesseract.pytesseract.tesseract_cmd = r'C:\Program Files\Tesseract-OCR\tesseract.exe'

def preprocess_image(image_path):
    print(f"\nLoading image: {image_path}")
    img = cv2.imread(image_path)
    if img is None:
        print("ERROR: Image not found!")
        return None
    scale  = 2.0
    width  = int(img.shape[1] * scale)
    height = int(img.shape[0] * scale)
    img    = cv2.resize(img, (width, height), interpolation=cv2.INTER_CUBIC)
    gray   = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
    denoised = cv2.fastNlMeansDenoising(gray, h=10)
    cv2.imwrite("processed_image.jpg", denoised)
    print("Image processing complete!")
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
    print("\nOCR Extracted Text:")
    print("="*40)
    print(best_text)
    print("="*40)
    return best_text

def extract_values(text):
    values     = {}
    text_clean = re.sub(r'[ \t]+', ' ', text)

    # Patient Name - All formats
    patient = re.search(
        r'(?:Patient|Name)\s*[:\-]?\s*([A-Za-z][A-Za-z\s\.]+?)(?:\n|Age|Date|Category|Sample|$)',
        text_clean, re.IGNORECASE)
    if patient:
        values['patient_name'] = patient.group(1).strip()

    # Age
    age = re.search(r'Age\s*[:\-]?\s*(\d+)', text_clean, re.IGNORECASE)
    if age:
        values['age'] = age.group(1)

    # Date - All formats
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

    # FBS - All formats
    for pattern in [
        r'Fasting\s*Blood\s*Sugar\s*[:\-]?\s*(\d+\.?\d*)',
        r'Blood\s*Sugar\s*[-–]\s*fasting\s*[^\d]*(\d+\.?\d*)',
        r'Blood\s*Sugar.*?fasting.*?(\d+\.?\d*)\s*mg',
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

    # Total Cholesterol - All formats
    for pattern in [
        r'Total\s*Cholesterol\s*[:\-]\s*(\d+\.?\d*)',
        r'Total\s*Cholesterol\s+(\d+\.?\d*)\s*mg',
        r'(?:^|\n)\s*Cholesterol\s+(\d+\.?\d*)\s*mg',
        r'T\.?\s*Cho[^\d]*(\d+\.?\d*)',
        # Government Hospital - "1 Cholesterol 197.4"
        r'\d+\s+Cholesterol\s+(\d+\.?\d*)\s*mg',
    ]:
        m = re.search(pattern, text_clean, re.IGNORECASE | re.MULTILINE)
        if m:
            val = float(m.group(1))
            if 50 < val < 600:
                values['total_cholesterol'] = val
                break

    # HDL - All formats
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

    # LDL - All formats
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
# Triglycerides - All formats
    for pattern in [
        r'Serum\s*Triglycerides\s*[:\-]\s*(\d+\.?\d*)',
        r'Triglycerides\s*[:\-]?\s*(\d+\.?\d*)\s*mg',
        r'Triglyceride\s*Level\s+(\d+\.?\d*)',
        r'Triglyceride[^\d\n]{0,10}(\d{2,3}\.?\d*)',
        r'\d+\s+Triglycerides\s+(\d+\.?\d*)\s*mg',
        # OCR misread fix - "Tnglycendes", "Tniglycerides"
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

def check_alerts(values):
    print("\n" + "="*40)
    print("HEALTH ALERT REPORT")
    print("="*40)

    if 'patient_name' in values:
        print(f"Patient  : {values['patient_name']}")
    if 'age' in values:
        print(f"Age      : {values['age']} Yrs")
    if 'date' in values:
        print(f"Date     : {values['date']}")

    print("\n--- Test Results ---")
    alerts = []

    if 'fasting_blood_sugar' in values:
        fbs = values['fasting_blood_sugar']
        if fbs < 65:
            status = "VERY LOW - Emergency!"
            alerts.append(f"FBS critically low: {fbs} mg/dl")
        elif fbs <= 115:
            status = "NORMAL"
        elif fbs <= 125:
            status = "PRE-DIABETIC - Monitor!"
            alerts.append(f"FBS pre-diabetic: {fbs} mg/dl")
        else:
            status = "HIGH - Diabetic Range!"
            alerts.append(f"FBS high: {fbs} mg/dl")
        print(f"Fasting Blood Sugar : {fbs} mg/dl  ->  {status}")

    if 'hba1c' in values:
        hba1c = values['hba1c']
        if hba1c < 5.7:
            status = "NORMAL"
        elif hba1c < 6.5:
            status = "PRE-DIABETIC"
            alerts.append(f"HbA1c pre-diabetic: {hba1c}%")
        else:
            status = "DIABETIC!"
            alerts.append(f"HbA1c diabetic: {hba1c}%")
        print(f"HbA1c               : {hba1c}%       ->  {status}")

    if 'total_cholesterol' in values:
        chol = values['total_cholesterol']
        if chol < 200:
            status = "NORMAL"
        elif chol < 250:
            status = "BORDERLINE HIGH"
            alerts.append(f"Cholesterol borderline: {chol}")
        else:
            status = "HIGH RISK!"
            alerts.append(f"Cholesterol high: {chol}")
        print(f"Total Cholesterol   : {chol} mg/dl  ->  {status}")

    if 'hdl' in values:
        hdl = values['hdl']
        if hdl < 40:
            status = "LOW - Risk!"
            alerts.append(f"HDL is LOW: {hdl} mg/dl")
        else:
            status = "GOOD"
        print(f"HDL (Good Chol)     : {hdl} mg/dl  ->  {status}")

    if 'ldl' in values:
        ldl = values['ldl']
        if ldl >= 130:
            status = "HIGH!"
            alerts.append(f"LDL is HIGH: {ldl} mg/dl")
        else:
            status = "NORMAL"
        print(f"LDL (Bad Chol)      : {ldl} mg/dl  ->  {status}")

    if 'triglycerides' in values:
        trig = values['triglycerides']
        if trig >= 150:
            status = "HIGH!"
            alerts.append(f"Triglycerides HIGH: {trig} mg/dl")
        else:
            status = "NORMAL"
        print(f"Triglycerides       : {trig} mg/dl  ->  {status}")

    print("\n--- ALERT SUMMARY ---")
    if alerts:
        print("WARNING - ALERTS DETECTED:")
        for a in alerts:
            print(f"   >> {a}")
        print("\nPlease contact your doctor immediately!")
    else:
        if values:
            print("All values are within Normal Range!")
        else:
            print("No values detected - Please check image quality.")
    print("="*40)

def analyze_report(image_path):
    text   = extract_text(image_path)
    values = extract_values(text)
    print(f"\nDetected Values: {values}")
    check_alerts(values)

if __name__ == "__main__":
    reports = [
        ("fbs1.jpeg",           "FBS Report - Ideal"),
        ("lipid_profile1.jpeg", "Lipid Profile - Ideal"),
        ("hba1c1.jpeg",         "HbA1c Report - Ideal"),
        ("clab_report.jpeg",    "Lipid Profile - C-Lab"),
        ("govt_fbs.jpeg",       "FBS - Government Hospital"),
        ("govt_lipid.jpeg",     "Lipid - Government Hospital"),
    ]

    for filename, label in reports:
        if os.path.exists(filename):
            print(f"\n{'='*50}")
            print(f"Analyzing: {label} - {filename}")
            print('='*50)
            analyze_report(filename)
        else:
            print(f"WARNING: File not found - {filename}")