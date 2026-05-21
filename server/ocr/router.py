# ================================================
# OCR Router
# Follows Medicare+ API pattern exactly
# ================================================

from fastapi import APIRouter, File, UploadFile, HTTPException
import shutil, os, tempfile

from res_models import get_response_json, StatusCode
from ocr.services.ocr_service  import analyze_report
from ocr.services.trend_service import analyze_trends
from ocr.config.database        import get_db_connection, test_connection

router = APIRouter(prefix="/ocr", tags=["OCR"])

# ------------------------------------------------
# GET /ocr/ - Health check
# ------------------------------------------------
@router.get("/")
def ocr_root():
    try:
        db_ok = test_connection()
        return get_response_json(
            status_code = StatusCode.OK,
            message     = f"OCR Service Ready! DB: {'Connected' if db_ok else 'Disconnected'}"
        )
    except Exception as e:
        return get_response_json(
            status_code = StatusCode.INTERNAL_SERVER_ERROR,
            message     = f"OCR Service Error: {str(e)}"
        )

# ------------------------------------------------
# POST /ocr/upload - Upload + Analyze Report
# ------------------------------------------------
@router.post("/upload")
async def upload_report(image: UploadFile = File(...)):
    """
    Upload lab report image → OCR → JSON response

    Supports:
    - FBS, HbA1c (Diabetes)
    - Lipid Profile (Heart Disease)
    - FBC (Blood disorders)
    - LFT (Liver)
    - TFT (Thyroid)
    - RFT (Kidney)
    """
    try:
        if not image.filename.lower().endswith(('.jpg', '.jpeg', '.png')):
            return get_response_json(
                status_code = StatusCode.INTERNAL_SERVER_ERROR,
                message     = "Only JPG/PNG images accepted"
            )

        with tempfile.NamedTemporaryFile(
            delete=False,
            suffix=os.path.splitext(image.filename)[1]
        ) as tmp:
            shutil.copyfileobj(image.file, tmp)
            tmp_path = tmp.name

        result = analyze_report(tmp_path)
        os.unlink(tmp_path)

        return {
            "Status Code":   StatusCode.OK,
            "Title":         "Medicare+ API",
            "Description":   "OCR Lab Report Analysis",
            "Version":       "V1.0.0",
            "Message":       "Report analyzed successfully!",
            "Data":          result
        }

    except Exception as e:
        return get_response_json(
            status_code = StatusCode.INTERNAL_SERVER_ERROR,
            message     = f"Analysis failed: {str(e)}"
        )

# ------------------------------------------------
# GET /ocr/results - All Results
# ------------------------------------------------
@router.get("/results")
def get_results():
    try:
        conn = get_db_connection()
        if not conn:
            return get_response_json(
                status_code = StatusCode.INTERNAL_SERVER_ERROR,
                message     = "Database connection failed"
            )
        cur = conn.cursor(dictionary=True)
        cur.execute("SELECT * FROM lab_results ORDER BY created_at DESC LIMIT 100")
        rows = cur.fetchall()
        cur.close(); conn.close()

        return {
            "Status Code": StatusCode.OK,
            "Title":       "Medicare+ API",
            "Description": "All Lab Results",
            "Version":     "V1.0.0",
            "Message":     f"Retrieved {len(rows)} records",
            "Data":        rows
        }
    except Exception as e:
        return get_response_json(
            status_code = StatusCode.INTERNAL_SERVER_ERROR,
            message     = f"Error: {str(e)}"
        )

# ------------------------------------------------
# GET /ocr/alerts - Abnormal Results Only
# ------------------------------------------------
@router.get("/alerts")
def get_alerts():
    try:
        conn = get_db_connection()
        if not conn:
            return get_response_json(
                status_code = StatusCode.INTERNAL_SERVER_ERROR,
                message     = "Database connection failed"
            )
        cur = conn.cursor(dictionary=True)
        cur.execute("""
            SELECT * FROM lab_results
            WHERE status NOT IN ('NORMAL','GOOD')
            ORDER BY created_at DESC
        """)
        rows = cur.fetchall()
        cur.close(); conn.close()

        return {
            "Status Code":  StatusCode.OK,
            "Title":        "Medicare+ API",
            "Description":  "Abnormal Lab Results",
            "Version":      "V1.0.0",
            "Message":      f"{len(rows)} alerts found",
            "Data":         rows
        }
    except Exception as e:
        return get_response_json(
            status_code = StatusCode.INTERNAL_SERVER_ERROR,
            message     = f"Error: {str(e)}"
        )

# ------------------------------------------------
# GET /ocr/trends/{patient} - Trend Analysis
# ------------------------------------------------
@router.get("/trends/{patient_name}")
def get_trends(patient_name: str):
    try:
        result = analyze_trends(patient_name)
        return {
            "Status Code": StatusCode.OK,
            "Title":       "Medicare+ API",
            "Description": "Longitudinal Trend Analysis",
            "Version":     "V1.0.0",
            "Message":     f"Trend analysis for {patient_name}",
            "Data":        result
        }
    except Exception as e:
        return get_response_json(
            status_code = StatusCode.INTERNAL_SERVER_ERROR,
            message     = f"Error: {str(e)}"
        )

# ------------------------------------------------
# GET /ocr/dashboard - Summary
# ------------------------------------------------
@router.get("/dashboard")
def get_dashboard():
    try:
        conn = get_db_connection()
        if not conn:
            return get_response_json(
                status_code = StatusCode.INTERNAL_SERVER_ERROR,
                message     = "Database connection failed"
            )
        cur = conn.cursor()
        cur.execute("SELECT COUNT(*) FROM lab_results")
        total = cur.fetchone()[0]
        cur.execute("SELECT COUNT(*) FROM lab_results WHERE status IN ('NORMAL','GOOD')")
        normal = cur.fetchone()[0]
        cur.execute("SELECT COUNT(*) FROM lab_results WHERE status NOT IN ('NORMAL','GOOD')")
        abnormal = cur.fetchone()[0]
        cur.execute("SELECT COUNT(DISTINCT patient_name) FROM lab_results")
        patients = cur.fetchone()[0]
        cur.close(); conn.close()

        return {
            "Status Code":  StatusCode.OK,
            "Title":        "Medicare+ API",
            "Description":  "OCR Dashboard Summary",
            "Version":      "V1.0.0",
            "Message":      "Dashboard data retrieved",
            "Data": {
                "total_records":  total,
                "normal_count":   normal,
                "abnormal_count": abnormal,
                "total_patients": patients,
            }
        }
    except Exception as e:
        return get_response_json(
            status_code = StatusCode.INTERNAL_SERVER_ERROR,
            message     = f"Error: {str(e)}"
        )