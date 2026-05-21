# ================================================
# Database Configuration
# Reads from .env - No hardcoded passwords!
# ================================================

import mysql.connector
import os
from dotenv import load_dotenv

load_dotenv()

def get_db_connection():
    try:
        return mysql.connector.connect(
            host     = os.getenv('DB_HOST',     'localhost'),
            user     = os.getenv('DB_USER',     'root'),
            password = os.getenv('DB_PASSWORD', ''),
            database = os.getenv('DB_NAME',     'ocr_lab_reports'),
            port     = int(os.getenv('DB_PORT',  3306))
        )
    except mysql.connector.Error as e:
        print(f"DB Error: {e}")
        return None

def test_connection():
    conn = get_db_connection()
    if conn:
        conn.close()
        return True
    return False