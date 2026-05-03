# OCR Lab Report Analysis Service
## Team 13 - Medicare Plus Project

### Developer: W.G. Sonali Dinelka (22UG2-0256)

### Setup Instructions

#### 1. Install Requirements
pip install -r requirements.txt

#### 2. Install Tesseract OCR
Download: https://github.com/UB-Mannheim/tesseract/wiki

#### 3. Setup Database
python setup_database.py

#### 4. Run API
python app.py

### API Endpoints
- GET  /           → API Status
- POST /upload-report → Upload & Analyze
- GET  /get-results   → All Results  
- GET  /get-alerts    → Abnormal Results
- GET  /dashboard-summary → Summary