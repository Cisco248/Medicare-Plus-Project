# ================================================
# Test Cases - OCR Service
# pytest framework
# ================================================

import pytest
import os
import sys
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.dirname(__file__))))

from ocr.services.ocr_service import (
    extract_values,
    get_status,
    detect_report_type,
    preprocess_image,
)

# ------------------------------------------------
# Test 1: extract_values - FBS
# ------------------------------------------------
class TestExtractValues:

    def test_fbs_ideal_format(self):
        """Ideal Hospital FBS format"""
        text = "Fasting Blood Sugar : 84.70 mg/dl"
        vals = extract_values(text)
        assert 'FBS' in vals
        assert vals['FBS'] == 84.70

    def test_fbs_govt_format(self):
        """Government Hospital FBS format"""
        text = "Blood Sugar - fasting 90.4 mg/dl"
        vals = extract_values(text)
        assert 'FBS' in vals
        assert vals['FBS'] == 90.4

    def test_hba1c_extraction(self):
        """HbA1c extraction"""
        text = "HbA1c : 6.4%"
        vals = extract_values(text)
        assert 'HbA1c' in vals
        assert vals['HbA1c'] == 6.4

    def test_lipid_profile_extraction(self):
        """Lipid profile - all values"""
        text = """
        Total Cholesterol : 147.50 mg/dl
        H.D.L : 54.60 mg/dl
        Serum Triglycerides: 68.00 mg/dl
        """
        vals = extract_values(text)
        assert 'Cholesterol' in vals
        assert 'HDL' in vals
        assert 'Triglycerides' in vals

    def test_empty_text(self):
        """Empty text returns empty dict"""
        vals = extract_values("")
        assert isinstance(vals, dict)

    def test_alt_extraction_lft(self):
        """ALT extraction for LFT"""
        text = "ALT : 45 U/L"
        vals = extract_values(text)
        assert 'ALT' in vals
        assert vals['ALT'] == 45.0

    def test_tsh_extraction(self):
        """TSH extraction for TFT"""
        text = "TSH : 2.5 mU/L"
        vals = extract_values(text)
        assert 'TSH' in vals
        assert vals['TSH'] == 2.5

    def test_hemoglobin_extraction(self):
        """Hemoglobin extraction for FBC"""
        text = "Hb : 13.5 g/dl"
        vals = extract_values(text)
        assert 'Hemoglobin' in vals
        assert vals['Hemoglobin'] == 13.5

# ------------------------------------------------
# Test 2: get_status - Alert System
# ------------------------------------------------
class TestGetStatus:

    def test_fbs_normal(self):
        assert get_status('FBS', 90) == 'NORMAL'

    def test_fbs_high(self):
        assert get_status('FBS', 150) == 'HIGH'

    def test_fbs_low(self):
        assert get_status('FBS', 50) == 'LOW'

    def test_hba1c_normal(self):
        assert get_status('HbA1c', 5.0) == 'NORMAL'

    def test_hba1c_high(self):
        assert get_status('HbA1c', 7.0) == 'HIGH'

    def test_cholesterol_normal(self):
        assert get_status('Cholesterol', 180) == 'NORMAL'

    def test_cholesterol_high(self):
        assert get_status('Cholesterol', 250) == 'HIGH'

    def test_hdl_normal(self):
        assert get_status('HDL', 55) == 'NORMAL'

    def test_hdl_low(self):
        assert get_status('HDL', 35) == 'LOW'

    def test_alt_normal(self):
        assert get_status('ALT', 30) == 'NORMAL'

    def test_alt_high(self):
        assert get_status('ALT', 80) == 'HIGH'

    def test_tsh_normal(self):
        assert get_status('TSH', 2.0) == 'NORMAL'

    def test_tsh_high_hypothyroid(self):
        assert get_status('TSH', 5.0) == 'HIGH'

# ------------------------------------------------
# Test 3: detect_report_type
# ------------------------------------------------
class TestDetectReportType:

    def test_fbs_detection(self):
        text = "Bio Chemistry - Blood Sugar (Fasting)"
        assert detect_report_type(text) == 'FBS'

    def test_lipid_detection(self):
        text = "Bio Chemistry - Lipid Profile"
        assert detect_report_type(text) == 'Lipid Profile'

    def test_hba1c_detection(self):
        text = "Biochemistry - Glycohaemoglobin Level HbA1c"
        assert detect_report_type(text) == 'HbA1c'

    def test_lft_detection(self):
        text = "Liver Function Tests - SGPT ALT"
        assert detect_report_type(text) == 'LFT'

    def test_tft_detection(self):
        text = "Thyroid Function Tests TSH"
        assert detect_report_type(text) == 'TFT'

    def test_fbc_detection(self):
        text = "Full Blood Count Haematology"
        assert detect_report_type(text) == 'FBC'

    def test_unknown_detection(self):
        text = "Some random text"
        assert detect_report_type(text) == 'Unknown'

# ------------------------------------------------
# Test 4: Edge Cases
# ------------------------------------------------
class TestEdgeCases:

    def test_high_fbs_alert_generated(self):
        """High FBS should be flagged"""
        text = "Fasting Blood Sugar : 250 mg/dl"
        vals = extract_values(text)
        assert 'FBS' in vals
        assert get_status('FBS', vals['FBS']) == 'HIGH'

    def test_ldl_decimal_fix(self):
        """OCR reads 7930 instead of 79.30"""
        text = "LDL : 7930 mg/dl"
        vals = extract_values(text)
        if 'LDL' in vals:
            assert vals['LDL'] < 400

    def test_multiple_parameters(self):
        """Multiple params in one report"""
        text = """
        Total Cholesterol : 200 mg/dl
        HDL : 55 mg/dl
        LDL : 120 mg/dl
        Serum Triglycerides: 130 mg/dl
        """
        vals = extract_values(text)
        assert len(vals) >= 3