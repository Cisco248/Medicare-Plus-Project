# ================================================
# Flask API - OCR Lab Report System
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

    # Patient Name - Ideal & C-Lab
    patient = re.search(
        r'(?:Patient|Name)\s*[:\-]?\s*([A-Za-z][A-Za-z\s\.]+?)(?:\n|Age|Date|$)',
        text_clean, re.IGNORECASE)
    if patient:
        values['patient_name'] = patient.group(1).strip()

    # Age
    age = re.search(r'Age\s*[:\-]?\s*(\d+)', text_clean, re.IGNORECASE)
    if age:
        values['age'] = age.group(1)

    # Date - Ideal & C-Lab
    for pattern in [
        r'Date\s*[:\-]?\s*(\d{1,2}[\/\-\.]\d{1,2}[\/\-\.]\d{2,4})',
        r'Date\s*[:\-]?\s*(\d{1,2}[\/\-][A-Za-z]{3}[\/\-]\d{2,4})',
        r'Receive\s*Date\s*[:\-]?\s*(\d{1,2}[\-][A-Za-z]{3}[\-]\d{2,4})',
    ]:
        m = re.search(pattern, text_clean, re.IGNORECASE)
        if m:
            values['date'] = m.group(1)
            break

    # FBS
    for pattern in [
        r'Fasting\s*Blood\s*Sugar\s*[:\-]?\s*(\d+\.?\d*)',
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
        r'T\.?\s*Cho[^\d]*(\d+\.?\d*)',
    ]:
        m = re.search(pattern, text_clean, re.IGNORECASE)
        if m:
            val = float(m.group(1))
            if 50 < val < 600:
                values['total_cholesterol'] = val
                break

    # HDL
    for pattern in [
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
        if re.search(r'\bLDL\b', line, re.IGNORECASE):
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
                if re.search(r'Ratio|T\.Cho', line, re.IGNORECASE):
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
                for j in range(i