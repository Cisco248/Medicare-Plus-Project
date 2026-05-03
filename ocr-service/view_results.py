# ================================================
# View Database Results - Lab Reports
# ================================================

import mysql.connector

DB_CONFIG = {
    "host":     "localhost",
    "user":     "root",
    "password": "root123",
    "database": "ocr_lab_reports"
}

def view_all_results():
    conn   = mysql.connector.connect(**DB_CONFIG)
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM lab_results ORDER BY created_at DESC")
    rows = cursor.fetchall()

    print("\n" + "="*80)
    print("ALL LAB RESULTS")
    print("="*80)
    print(f"{'ID':<4} {'Patient':<15} {'Age':<5} {'Date':<12} {'Parameter':<15} {'Value':<8} {'Unit':<8} {'Status'}")
    print("-"*80)

    for row in rows:
        id_, patient, age, date, test_type, param, value, unit, status, alert, image, created = row
        # Status color indicator
        if status in ('HIGH', 'VERY LOW', 'DIABETIC', 'HIGH RISK'):
            indicator = "🔴"
        elif status in ('PRE-DIABETIC', 'BORDERLINE', 'LOW'):
            indicator = "🟡"
        else:
            indicator = "✅"
        print(f"{id_:<4} {str(patient):<15} {str(age):<5} {str(date):<12} {str(param):<15} {str(value):<8} {str(unit):<8} {indicator} {status}")

    print("="*80)
    print(f"Total Records: {len(rows)}")
    print("="*80)
    cursor.close()
    conn.close()

def view_alerts_only():
    conn   = mysql.connector.connect(**DB_CONFIG)
    cursor = conn.cursor()
    cursor.execute("""
        SELECT * FROM lab_results 
        WHERE status NOT IN ('NORMAL','GOOD')
        ORDER BY created_at DESC
    """)
    rows = cursor.fetchall()

    print("\n" + "="*80)
    print("⚠️  ABNORMAL RESULTS ONLY")
    print("="*80)
    print(f"{'ID':<4} {'Patient':<15} {'Age':<5} {'Date':<12} {'Parameter':<15} {'Value':<8} {'Status'}")
    print("-"*80)

    for row in rows:
        id_, patient, age, date, test_type, param, value, unit, status, alert, image, created = row
        print(f"{id_:<4} {str(patient):<15} {str(age):<5} {str(date):<12} {str(param):<15} {str(value):<8} {status}")

    print("="*80)
    print(f"Total Abnormal: {len(rows)}")
    print("="*80)
    cursor.close()
    conn.close()

def view_by_patient(name):
    conn   = mysql.connector.connect(**DB_CONFIG)
    cursor = conn.cursor()
    cursor.execute("""
        SELECT * FROM lab_results 
        WHERE patient_name LIKE %s
        ORDER BY created_at DESC
    """, (f"%{name}%",))
    rows = cursor.fetchall()

    print(f"\n{'='*80}")
    print(f"RESULTS FOR: {name}")
    print("="*80)
    print(f"{'Parameter':<15} {'Value':<8} {'Unit':<8} {'Status':<15} {'Date'}")
    print("-"*80)

    for row in rows:
        id_, patient, age, date, test_type, param, value, unit, status, alert, image, created = row
        if status in ('HIGH','VERY LOW','DIABETIC'):
            indicator = "🔴"
        elif status in ('PRE-DIABETIC','BORDERLINE','LOW'):
            indicator = "🟡"
        else:
            indicator = "✅"
        print(f"{str(param):<15} {str(value):<8} {str(unit):<8} {indicator} {str(status):<15} {str(date)}")

    print("="*80)
    print(f"Total: {len(rows)} records")
    print("="*80)
    cursor.close()
    conn.close()

def view_summary():
    conn   = mysql.connector.connect(**DB_CONFIG)
    cursor = conn.cursor()

    # Total records
    cursor.execute("SELECT COUNT(*) FROM lab_results")
    total = cursor.fetchone()[0]

    # Normal count
    cursor.execute("SELECT COUNT(*) FROM lab_results WHERE status IN ('NORMAL','GOOD')")
    normal = cursor.fetchone()[0]

    # Abnormal count
    cursor.execute("SELECT COUNT(*) FROM lab_results WHERE status NOT IN ('NORMAL','GOOD')")
    abnormal = cursor.fetchone()[0]

    # Unique patients
    cursor.execute("SELECT COUNT(DISTINCT patient_name) FROM lab_results")
    patients = cursor.fetchone()[0]

    print("\n" + "="*40)
    print("DATABASE SUMMARY")
    print("="*40)
    print(f"Total Records    : {total}")
    print(f"Normal Results   : {normal} ✅")
    print(f"Abnormal Results : {abnormal} ⚠️")
    print(f"Total Patients   : {patients}")
    print("="*40)

    cursor.close()
    conn.close()

# ================================================
# MAIN MENU
# ================================================
if __name__ == "__main__":
    while True:
        print("\n" + "="*40)
        print("DATABASE VIEWER - LAB REPORTS")
        print("="*40)
        print("1. View All Results")
        print("2. View Abnormal/Alerts Only")
        print("3. Search by Patient Name")
        print("4. View Summary")
        print("5. Exit")
        print("="*40)

        choice = input("Select option (1-5): ")

        if choice == "1":
            view_all_results()
        elif choice == "2":
            view_alerts_only()
        elif choice == "3":
            name = input("Enter patient name: ")
            view_by_patient(name)
        elif choice == "4":
            view_summary()
        elif choice == "5":
            print("Goodbye!")
            break
        else:
            print("Invalid option! Please select 1-5")