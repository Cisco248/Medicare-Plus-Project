# ================================================
# OCR Engine Comparison Study
# Tesseract vs EasyOCR
# Sri Lankan Lab Reports
# ================================================

import pytesseract
import easyocr
import cv2
import time
import re
import os

pytesseract.pytesseract.tesseract_cmd = r'C:\Program Files\Tesseract-OCR\tesseract.exe'

# EasyOCR reader initialize
print("Loading EasyOCR model... (first time = slow)")
easy_reader = easyocr.Reader(['en'], gpu=False)
print("EasyOCR Ready!")

# ------------------------------------------------
# Image Pre-process
# ------------------------------------------------
def preprocess(image_path):
    img = cv2.imread(image_path)
    scale  = 2.0
    width  = int(img.shape[1] * scale)
    height = int(img.shape[0] * scale)
    img    = cv2.resize(img, (width, height))
    gray   = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
    denoised = cv2.fastNlMeansDenoising(gray, h=10)
    return denoised

# ------------------------------------------------
# Tesseract OCR
# ------------------------------------------------
def tesseract_ocr(image_path):
    processed = preprocess(image_path)
    start = time.time()
    text  = pytesseract.image_to_string(
        processed, lang='eng', config='--psm 6'
    )
    end = time.time()
    return text, round(end - start, 2)

# ------------------------------------------------
# EasyOCR
# ------------------------------------------------
def easyocr_ocr(image_path):
    start   = time.time()
    results = easy_reader.readtext(image_path)
    end     = time.time()
    text    = ' '.join([r[1] for r in results])
    return text, round(end - start, 2)

# ------------------------------------------------
# Check Value Detected
# ------------------------------------------------
def check_value_detected(text, expected_value):
    # Expected value text ෙකදෙ තියෙනවාද?
    expected_str = str(expected_value).replace('.', '[\\.]?')
    pattern = expected_str
    if re.search(pattern, text):
        return True
    return False

# ------------------------------------------------
# Calculate Accuracy
# ------------------------------------------------
def calculate_accuracy(detected_values, total_values):
    return round((detected_values / total_values) * 100, 1)

# ------------------------------------------------
# MAIN COMPARISON
# ------------------------------------------------
def compare_engines():

    # Test reports + expected values
    test_cases = [
        {
            "file":     "fbs1.jpeg",
            "hospital": "Ideal Hospital",
            "report":   "FBS Report",
            "expected": {
                "FBS":      "84.70",
                "Patient":  "Gamage",
                "Date":     "08/12/2025"
            }
        },
        {
            "file":     "lipid_profile1.jpeg",
            "hospital": "Ideal Hospital",
            "report":   "Lipid Profile",
            "expected": {
                "Cholesterol": "147.50",
                "HDL":         "54.60",
                "LDL":         "79.30",
                "Trig":        "68.00"
            }
        },
        {
            "file":     "hba1c1.jpeg",
            "hospital": "Ideal Hospital",
            "report":   "HbA1c",
            "expected": {
                "HbA1c":   "6.4",
                "Patient": "Gamage"
            }
        },
        {
            "file":     "clab_report.jpeg",
            "hospital": "C-Lab",
            "report":   "Lipid Profile",
            "expected": {
                "Cholesterol": "202",
                "Trig":        "231.90",
                "HDL":         "29.70",
                "LDL":         "126.42"
            }
        },
        {
            "file":     "govt_fbs.jpeg",
            "hospital": "Govt Hospital",
            "report":   "FBS Report",
            "expected": {
                "FBS":  "90.4",
                "Name": "AJITH"
            }
        },
        {
            "file":     "govt_lipid.jpeg",
            "hospital": "Govt Hospital",
            "report":   "Lipid Profile",
            "expected": {
                "Cholesterol": "197.4",
                "HDL":         "73.8",
                "LDL":         "109.9",
                "Trig":        "68.6"
            }
        },
    ]

    print("\n" + "="*70)
    print("OCR ENGINE COMPARISON STUDY")
    print("Tesseract v5.5.0  vs  EasyOCR v1.7.2")
    print("Sri Lankan Medical Laboratory Reports")
    print("="*70)

    tess_total    = 0
    tess_correct  = 0
    easy_total    = 0
    easy_correct  = 0
    tess_times    = []
    easy_times    = []

    results_table = []

    for tc in test_cases:
        if not os.path.exists(tc['file']):
            print(f"\n⚠️  File not found: {tc['file']}")
            continue

        print(f"\n📂 {tc['hospital']} - {tc['report']}")
        print(f"   File: {tc['file']}")

        # Tesseract
        tess_text, tess_time = tesseract_ocr(tc['file'])
        tess_times.append(tess_time)

        # EasyOCR
        easy_text, easy_time = easyocr_ocr(tc['file'])
        easy_times.append(easy_time)

        # Check each expected value
        print(f"\n   {'Value':<15} {'Expected':<12} {'Tesseract':<12} {'EasyOCR':<12}")
        print(f"   {'-'*50}")

        for value_name, expected in tc['expected'].items():
            tess_found = check_value_detected(tess_text, expected)
            easy_found = check_value_detected(easy_text, expected)

            tess_total += 1
            easy_total += 1
            if tess_found: tess_correct += 1
            if easy_found: easy_correct += 1

            tess_mark = "✅" if tess_found else "❌"
            easy_mark = "✅" if easy_found else "❌"

            print(f"   {value_name:<15} {expected:<12} {tess_mark:<12} {easy_mark:<12}")

        print(f"\n   ⏱️  Time: Tesseract={tess_time}s  |  EasyOCR={easy_time}s")

        results_table.append({
            "hospital": tc['hospital'],
            "report":   tc['report'],
            "tess_time": tess_time,
            "easy_time": easy_time
        })

    # Final Summary
    tess_accuracy = calculate_accuracy(tess_correct, tess_total)
    easy_accuracy = calculate_accuracy(easy_correct, easy_total)
    tess_avg_time = round(sum(tess_times) / len(tess_times), 2)
    easy_avg_time = round(sum(easy_times) / len(easy_times), 2)

    print("\n" + "="*70)
    print("FINAL COMPARISON RESULTS")
    print("="*70)
    print(f"{'Metric':<25} {'Tesseract':<15} {'EasyOCR'}")
    print("-"*55)
    print(f"{'Accuracy':<25} {tess_accuracy}%{'':<11} {easy_accuracy}%")
    print(f"{'Correct Detections':<25} {tess_correct}/{tess_total}{'':<9} {easy_correct}/{easy_total}")
    print(f"{'Avg Processing Time':<25} {tess_avg_time}s{'':<11} {easy_avg_time}s")
    print(f"{'Privacy':<25} {'Local ✅':<15} {'Local ✅'}")
    print(f"{'Cost':<25} {'Free ✅':<15} {'Free ✅'}")
    print("="*70)

    # Recommendation
    print("\n📊 RECOMMENDATION:")
    if easy_accuracy > tess_accuracy:
        diff = easy_accuracy - tess_accuracy
        print(f"EasyOCR achieves {diff}% higher accuracy for Sri Lankan")
        print(f"medical reports ({easy_accuracy}% vs {tess_accuracy}%)")
        if tess_avg_time < easy_avg_time:
            print(f"Note: Tesseract is {easy_avg_time - tess_avg_time}s faster")
            print("Trade-off: Accuracy vs Speed")
    else:
        diff = tess_accuracy - easy_accuracy
        print(f"Tesseract achieves {diff}% higher accuracy")
        print(f"({tess_accuracy}% vs {easy_accuracy}%)")
    print("="*70)

if __name__ == "__main__":
    # OCR_Project folder ට navigate
    os.chdir(r'C:\Users\sonal\OneDrive\Desktop\OCR_Project')
    compare_engines()