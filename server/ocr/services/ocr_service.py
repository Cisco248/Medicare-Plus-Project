# ================================================
# OCR Service — Improved v3 (stable + fast)
# Fix 1: Lighter preprocessing — no crash
# Fix 2: deskew + CLAHE contrast + sharpen
# Fix 3: Merged tess+easy text for better detection
# Fix 4: 10+ patient name patterns
# ================================================

import pytesseract
import cv2
import re
import os
import time
import numpy as np
import sys
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.dirname(__file__))))
try:
    from ocr.config.database import get_db_connection
except ModuleNotFoundError:
    from ocr.config.database import get_db_connection

pytesseract.pytesseract.tesseract_cmd = \
    r'C:\Program Files\Tesseract-OCR\tesseract.exe'

_easy_reader = None
def get_easy_reader():
    global _easy_reader
    if _easy_reader is None:
        import easyocr
        _easy_reader = easyocr.Reader(['en'], gpu=False)
    return _easy_reader

NORMAL_RANGES = {
    'FBS':           {'min': 65,    'max': 115,   'unit': 'mg/dl'},
    'HbA1c':         {'min': 0,     'max': 5.7,   'unit': '%'},
    'Cholesterol':   {'min': 0,     'max': 200,   'unit': 'mg/dl'},
    'HDL':           {'min': 40,    'max': 200,   'unit': 'mg/dl'},
    'LDL':           {'min': 0,     'max': 130,   'unit': 'mg/dl'},
    'Triglycerides': {'min': 0,     'max': 150,   'unit': 'mg/dl'},
    'Hemoglobin':    {'min': 12,    'max': 17,    'unit': 'g/dl'},
    'WBC':           {'min': 4000,  'max': 11000, 'unit': 'cells/mm3'},
    'Platelets':     {'min': 150000,'max': 400000,'unit': '/mm3'},
    'ALT':           {'min': 0,     'max': 56,    'unit': 'U/L'},
    'AST':           {'min': 0,     'max': 40,    'unit': 'U/L'},
    'Bilirubin':     {'min': 0,     'max': 1.2,   'unit': 'mg/dl'},
    'TSH':           {'min': 0.4,   'max': 4.0,   'unit': 'mU/L'},
    'Creatinine':    {'min': 0.6,   'max': 1.2,   'unit': 'mg/dl'},
}

# ------------------------------------------------
# FIX 1: Lighter, stable preprocessing
# Only ONE scale (2x) — no looping, no crash
# ------------------------------------------------
def preprocess_image(image_path: str):
    """Preprocess image for better OCR — stable single-pass version"""
    try:
        img = cv2.imread(image_path)
        if img is None:
            return None

        # Scale up 2x for better OCR
        w = int(img.shape[1] * 2.0)
        h = int(img.shape[0] * 2.0)
        resized = cv2.resize(img, (w, h), interpolation=cv2.INTER_CUBIC)

        # Grayscale
        gray = cv2.cvtColor(resized, cv2.COLOR_BGR2GRAY)

        # Denoise
        denoised = cv2.fastNlMeansDenoising(gray, h=10)

        # FIX 2: CLAHE contrast enhancement — fixes dark photos
        clahe = cv2.createCLAHE(clipLimit=2.0, tileGridSize=(8, 8))
        enhanced = clahe.apply(denoised)

        # FIX 2: Sharpen — fixes blurry images
        kernel = np.array([[0, -1, 0], [-1, 5, -1], [0, -1, 0]])
        sharpened = cv2.filter2D(enhanced, -1, kernel)

        return sharpened

    except Exception:
        # If anything fails, return plain grayscale — never crash
        try:
            img = cv2.imread(image_path)
            if img is None:
                return None
            gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
            return gray
        except Exception:
            return None

# ------------------------------------------------
# FIX 3: Merged OCR text (tess + easy)
# ------------------------------------------------
def ensemble_ocr(image_path: str) -> dict:
    processed = preprocess_image(image_path)
    if processed is None:
        return {"tess_text": "", "merged_text": "", "confidence": 0, "needs_review": True}

    # Tesseract — two configs, pick best
    t0 = time.time()
    tess_text = ""
    try:
        for cfg in ['--psm 6 --oem 3', '--psm 4 --oem 3']:
            t = pytesseract.image_to_string(processed, lang='eng', config=cfg)
            if len(t) > len(tess_text):
                tess_text = t
    except Exception:
        tess_text = ""
    tess_time = round(time.time() - t0, 2)

    # EasyOCR — on original image
    t0 = time.time()
    easy_text = ""
    try:
        results = get_easy_reader().readtext(image_path, detail=1)
        results.sort(key=lambda r: r[0][0][1])
        easy_lines = [r[1] for r in results if r[2] > 0.3]
        easy_text  = '\n'.join(easy_lines)
    except Exception:
        easy_text = ""
    easy_time = round(time.time() - t0, 2)

    # Merge both
    merged_text = tess_text + "\n" + easy_text

    # Confidence
    tess_nums  = set(re.findall(r'\d+\.?\d*', tess_text))
    easy_nums  = set(re.findall(r'\d+\.?\d*', easy_text))
    agreed     = tess_nums & easy_nums
    total      = tess_nums | easy_nums
    confidence = round(len(agreed) / len(total) * 100, 1) if total else 0

    return {
        "tess_text":    tess_text,
        "easy_text":    easy_text,
        "merged_text":  merged_text,
        "confidence":   confidence,
        "needs_review": confidence < 70,
        "tess_time":    tess_time,
        "easy_time":    easy_time,
    }

# ------------------------------------------------
# FIX 4: Report type uses merged text + more keywords
# ------------------------------------------------
def detect_report_type(text: str) -> str:
    t = text.upper()
    if any(x in t for x in [
        'FASTING BLOOD SUGAR', 'FBS', 'BLOOD SUGAR - FAST',
        'BLOOD SUGAR (FAST', 'BLOOD SUGAR', 'GLUCOSE OXIDASE',
        'RANDOM BLOOD SUGAR', 'PLASMA GLUCOSE',
    ]):
        return 'FBS'
    if any(x in t for x in [
        'HBA1C', 'HBALC', 'GLYCOHAEMOGLOBIN', 'GLYCATED',
        'HAEMOGLOBIN A1C', 'HEMOGLOBIN A1C',
    ]):
        return 'HbA1c'
    if any(x in t for x in [
        'LIPID', 'SERUM LIPID', 'LIPID PROFILE',
        'CHOLESTEROL', 'TRIGLYCERIDE', 'HDL', 'LDL',
    ]):
        return 'Lipid Profile'
    if any(x in t for x in [
        'FULL BLOOD', 'HAEMATOLOGY', 'FBC', 'CBC',
        'COMPLETE BLOOD', 'BLOOD COUNT',
    ]):
        return 'FBC'
    if any(x in t for x in [
        'LIVER FUNCTION', 'LFT', 'SGPT', 'BILIRUBIN',
        'ALKALINE PHOSPHATASE', 'ALT', 'AST', 'SGOT',
    ]):
        return 'LFT'
    if any(x in t for x in [
        'THYROID', 'TSH', 'TFT', 'T3', 'T4',
        'THYROXINE', 'TRIIODOTHYRONINE',
    ]):
        return 'TFT'
    if any(x in t for x in ['URINE', 'UFR', 'MICROSCOPY', 'URINALYSIS']):
        return 'UFR'
    if any(x in t for x in ['RENAL', 'CREATININE', 'UREA', 'KIDNEY']):
        return 'RFT'
    return 'Unknown'

# ------------------------------------------------
# FIX 5: 10+ patient name patterns
# ------------------------------------------------
def extract_patient_name(text: str) -> str:
    patterns = [
        r'Patient\s*Name\s*[:\-]?\s*([A-Za-z][A-Za-z\s\.]{2,40}?)(?:\n|Age|Date|D\.?O\.?B|Ref|$)',
        r'Name\s*of\s*Patient\s*[:\-]?\s*([A-Za-z][A-Za-z\s\.]{2,40}?)(?:\n|Age|Date|$)',
        r'(?:^|\n)\s*Name\s*[:\-]\s*([A-Za-z][A-Za-z\s\.]{2,40}?)(?:\n|Age|Date|$)',
        r'\b((?:Mr\.?|Mrs\.?|Ms\.?|Miss\.?|Dr\.?|Prof\.?)\s+[A-Z][a-zA-Z\s\.]{2,35}?)(?:\n|Age|\d|Date|$)',
        r'Patient\s*[:\-]\s*([A-Z][A-Za-z\s\.]{2,35}?)(?:\n|Age|\d)',
        r'(?:^|\n)NAME\s*[:\-]\s*([A-Za-z][A-Za-z\s\.]{2,40}?)(?:\n|AGE|DATE|$)',
        r'(?:^|\n)([A-Z]{2,}(?:\s+[A-Z]{2,}){1,3})\s*\n',
        r'([A-Z]{3,}(?:\s+[A-Z]{3,})?)\s+(?:Sample|Age|DOB)',
    ]
    skip = {'unknown', 'report', 'result', 'test', 'value', 'unit',
            'reference', 'range', 'normal', 'sample', 'date', 'time',
            'lab', 'bio', 'chem', 'age', 'serum', 'blood', 'urine'}
    for pat in patterns:
        try:
            m = re.search(pat, text, re.IGNORECASE | re.MULTILINE)
            if m:
                name = re.sub(r'\s+', ' ', m.group(1).strip())
                name = re.sub(r'[^A-Za-z\s\.]', '', name).strip()
                if name.lower() in skip or len(name) < 3:
                    continue
                return name[:50]
        except Exception:
            continue
    return 'Unknown'

def extract_values(text: str) -> dict:
    values = {}
    tc = re.sub(r'[ \t]+', ' ', text)

    values['patient_name'] = extract_patient_name(tc)

    age = re.search(r'Age\s*[:\-]?\s*(\d+)', tc, re.IGNORECASE)
    if age:
        values['age'] = age.group(1)

    for pat in [
        r'Date\s*[:\-]?\s*(\d{1,2}[\/\-\.]\d{1,2}[\/\-\.]\d{2,4})',
        r'Collection\s*Date\s*[:\-]?\s*(\d{1,2}[\-][A-Za-z]{3}[\-]\d{2,4})',
        r'Date\s*[:\-]?\s*(\d{1,2}[\-][A-Za-z]{3}[\-]\d{2,4})',
    ]:
        m = re.search(pat, tc, re.IGNORECASE)
        if m:
            values['date'] = m.group(1)
            break

    for pat in [
        r'Fasting\s*Blood\s*Sugar\s*[:\-]?\s*(\d+\.?\d*)',
        r'Blood\s*Sugar\s*[-]\s*fasting[^\d]*(\d+\.?\d*)',
        r'FBS\s*[:\-]?\s*(\d+\.?\d*)',
        r'Blood\s*Sugar[^\d]*(\d{2,3}\.?\d*)\s*mg',
    ]:
        m = re.search(pat, tc, re.IGNORECASE)
        if m:
            v = float(m.group(1))
            if 40 < v < 600:
                values['FBS'] = v
                break

    for pat in [
        r'HbA1c\s*[:\-]?\s*(\d+\.?\d*)\s*%',
        r'HbAlc\s*[:\-]?\s*(\d+\.?\d*)\s*%',
        r'Glyco[^\d]*(\d+\.?\d*)\s*%',
    ]:
        m = re.search(pat, tc, re.IGNORECASE)
        if m:
            v = float(m.group(1))
            if 3 < v < 20:
                values['HbA1c'] = v
                break

    for pat in [
        r'Total\s*Cholesterol\s*[:\-]\s*(\d+\.?\d*)',
        r'Total\s*Cholesterol\s+(\d+\.?\d*)\s*mg',
        r'\d+\s+Cholesterol\s+(\d+\.?\d*)\s*mg',
        r'Cholesterol\s*[:\-]?\s*(\d+\.?\d*)',
    ]:
        m = re.search(pat, tc, re.IGNORECASE | re.MULTILINE)
        if m:
            v = float(m.group(1))
            if 50 < v < 600:
                values['Cholesterol'] = v
                break

    for pat in [
        r'HDL\s*Direct\s*[^\d]*(\d+\.?\d*)',
        r'H\.D\.L\s*[:\-]\s*(\d+\.?\d*)',
        r'HDL\s*[:\-]\s*(\d+\.?\d*)',
        r'HDL\s+(\d+\.?\d*)\s*mg',
    ]:
        m = re.search(pat, tc, re.IGNORECASE | re.MULTILINE)
        if m:
            v = float(m.group(1))
            if v > 200: v = v / 100
            if 10 < v < 200:
                values['HDL'] = v
                break

    ldl_done = False
    for line in tc.split('\n'):
        if re.search(r'\bLDL\b|\bLDL\s*CHOLESTEROL\b', line, re.IGNORECASE):
            for n in re.findall(r'\d+\.?\d*', line):
                v = float(n)
                if v > 400: v = v / 100
                if 10 < v < 400:
                    values['LDL'] = v
                    ldl_done = True
                    break
        if ldl_done:
            break

    for pat in [
        r'Serum\s*Triglycerides\s*[:\-]\s*(\d+\.?\d*)',
        r'Triglycerides\s*[:\-]?\s*(\d+\.?\d*)\s*mg',
        r'Triglyceride\s*Level\s+(\d+\.?\d*)',
    ]:
        m = re.search(pat, tc, re.IGNORECASE)
        if m:
            v = float(m.group(1))
            if 20 < v < 1000:
                values['Triglycerides'] = v
                break

    for pat in [r'Hb\s*[:\-]\s*(\d+\.?\d*)\s*g', r'H[ae]moglobin\s*[:\-]\s*(\d+\.?\d*)']:
        m = re.search(pat, tc, re.IGNORECASE)
        if m:
            v = float(m.group(1))
            if 5 < v < 25:
                values['Hemoglobin'] = v
                break

    for pat in [r'WBC\s*[:\-]\s*(\d+\.?\d*)', r'White\s*Blood\s*Cell[s]?\s*[:\-]\s*(\d+\.?\d*)']:
        m = re.search(pat, tc, re.IGNORECASE)
        if m:
            v = float(m.group(1))
            if 100 < v < 100000:
                values['WBC'] = v
                break

    for pat in [r'Platelet[s]?\s*[:\-]\s*(\d+\.?\d*)', r'PLT\s*[:\-]\s*(\d+\.?\d*)']:
        m = re.search(pat, tc, re.IGNORECASE)
        if m:
            v = float(m.group(1))
            if 10000 < v < 1000000:
                values['Platelets'] = v
                break

    for pat in [r'ALT\s*[:\-\(]?\s*(\d+\.?\d*)', r'SGPT\s*[:\-]?\s*(\d+\.?\d*)']:
        m = re.search(pat, tc, re.IGNORECASE)
        if m:
            v = float(m.group(1))
            if 0 < v < 2000:
                values['ALT'] = v
                break

    for pat in [r'AST\s*[:\-]?\s*(\d+\.?\d*)', r'SGOT\s*[:\-]?\s*(\d+\.?\d*)']:
        m = re.search(pat, tc, re.IGNORECASE)
        if m:
            v = float(m.group(1))
            if 0 < v < 2000:
                values['AST'] = v
                break

    for pat in [r'Total\s*Bilirubin\s*[:\-]?\s*(\d+\.?\d*)', r'Bilirubin\s*[:\-]?\s*(\d+\.?\d*)']:
        m = re.search(pat, tc, re.IGNORECASE)
        if m:
            v = float(m.group(1))
            if 0 < v < 100:
                values['Bilirubin'] = v
                break

    for pat in [r'TSH\s*[:\-]?\s*(\d+\.?\d*)', r'Thyroid\s*Stimulating\s*Hormone\s*[:\-]?\s*(\d+\.?\d*)']:
        m = re.search(pat, tc, re.IGNORECASE)
        if m:
            v = float(m.group(1))
            if 0 < v < 100:
                values['TSH'] = v
                break

    for pat in [r'Creatinine\s*[:\-]?\s*(\d+\.?\d*)', r'S\.?\s*Creatinine\s*[:\-]?\s*(\d+\.?\d*)']:
        m = re.search(pat, tc, re.IGNORECASE)
        if m:
            v = float(m.group(1))
            if 0 < v < 20:
                values['Creatinine'] = v
                break

    return values

def get_status(parameter: str, value) -> str:
    if isinstance(value, str):
        return 'ABNORMAL' if value in ('POSITIVE', '+', '++', '+++') else 'NORMAL'
    ranges = NORMAL_RANGES.get(parameter)
    if not ranges:
        return 'UNKNOWN'
    if parameter == 'HDL':
        return 'NORMAL' if value >= ranges['min'] else 'LOW'
    if value > ranges['max']:
        return 'HIGH'
    if value < ranges['min']:
        return 'LOW'
    return 'NORMAL'

def save_results(values: dict, image_file: str, confidence: float, report_type: str):
    conn = get_db_connection()
    if not conn:
        return 0
    skip  = {'patient_name', 'age', 'date'}
    cur   = conn.cursor()
    saved = 0
    for param, val in values.items():
        if param in skip:
            continue
        status = get_status(param, val)
        alert  = f"{param} is {status}" if status not in ('NORMAL', 'GOOD') else ""
        cur.execute("""
            INSERT INTO lab_results
            (patient_name, age, test_date, test_type,
             parameter, value, unit, status, alert_message, image_file)
            VALUES (%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)
        """, (
            values.get('patient_name', 'Unknown'),
            values.get('age', '0'),
            values.get('date', 'Unknown'),
            report_type,
            param,
            float(val) if isinstance(val, (int, float)) else 0,
            NORMAL_RANGES.get(param, {}).get('unit', ''),
            status, alert, image_file
        ))
        saved += 1
    conn.commit()
    cur.close()
    conn.close()
    return saved

def analyze_report(image_path: str) -> dict:
    try:
        ocr_result  = ensemble_ocr(image_path)
        merged_text = ocr_result.get('merged_text', ocr_result.get('tess_text', ''))
        values      = extract_values(merged_text)
        report_type = detect_report_type(merged_text)

        skip   = {'patient_name', 'age', 'date'}
        alerts = []
        for param, val in values.items():
            if param in skip or isinstance(val, str):
                continue
            status = get_status(param, val)
            if status not in ('NORMAL', 'GOOD', 'UNKNOWN'):
                alerts.append({
                    "parameter": param,
                    "value":     val,
                    "status":    status,
                    "unit":      NORMAL_RANGES.get(param, {}).get('unit', ''),
                })

        saved = save_results(
            values, os.path.basename(image_path),
            ocr_result['confidence'], report_type
        )

        return {
            "report_type":  report_type,
            "patient":      values.get('patient_name', 'Unknown'),
            "age":          values.get('age', 'Unknown'),
            "date":         values.get('date', 'Unknown'),
            "values":       {k: v for k, v in values.items() if k not in skip},
            "alerts":       alerts,
            "confidence":   ocr_result['confidence'],
            "needs_review": ocr_result['needs_review'],
            "ocr_metrics":  {
                "tesseract_time": ocr_result.get('tess_time', 0),
                "easyocr_time":   ocr_result.get('easy_time', 0),
            },
            "db_saved": saved,
        }
    except Exception as e:
        # Never crash the server — return safe error result
        return {
            "report_type":  "Error",
            "patient":      "Unknown",
            "age":          "Unknown",
            "date":         "Unknown",
            "values":       {},
            "alerts":       [],
            "confidence":   0,
            "needs_review": True,
            "error":        str(e),
            "db_saved":     0,
        }