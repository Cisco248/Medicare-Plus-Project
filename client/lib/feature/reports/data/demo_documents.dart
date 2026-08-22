import 'package:client/feature/reports/models/document.model.dart';

class DemoDocuments {
  const DemoDocuments._();

  static final List<DocumentModel> samples = [
    DocumentModel(
      id: 'demo-lab-1',
      userId: 'demo',
      title: '[Demo] Complete Blood Count',
      docType: 'Lab Report',
      fileName: 'demo_cbc.pdf',
      fileType: 'pdf',
      description: 'Sample laboratory report for the university demo.',
      issuer: 'Dr. A. Perera',
      hospital: 'City Clinic',
      reportDate: DateTime(2026, 6, 12),
      status: 'reviewed',
      createdAt: DateTime(2026, 6, 13),
    ),
    DocumentModel(
      id: 'demo-rx-1',
      userId: 'demo',
      title: '[Demo] Repeat Prescription',
      docType: 'Prescription',
      fileName: 'demo_prescription.pdf',
      fileType: 'pdf',
      description: 'Sample prescription used to demonstrate E-Doc filtering.',
      issuer: 'Dr. S. Fernando',
      hospital: 'General Hospital',
      reportDate: DateTime(2026, 7, 2),
      status: 'uploaded',
      createdAt: DateTime(2026, 7, 2),
    ),
    DocumentModel(
      id: 'demo-scan-1',
      userId: 'demo',
      title: '[Demo] Chest X-Ray Summary',
      docType: 'Scan / Imaging',
      fileName: 'demo_xray.png',
      fileType: 'png',
      description: 'Sample imaging summary. Not a real clinical report.',
      issuer: 'Dr. N. Jayawardena',
      hospital: 'City Clinic',
      reportDate: DateTime(2026, 5, 20),
      status: 'reviewed',
      createdAt: DateTime(2026, 5, 21),
    ),
    DocumentModel(
      id: 'demo-doctor-1',
      userId: 'demo',
      title: '[Demo] Clinic Follow-up Note',
      docType: 'Doctor Note',
      fileName: 'demo_note.pdf',
      fileType: 'pdf',
      description: 'Sample doctor-related document for the E-Doc demo.',
      issuer: 'Dr. A. Perera',
      hospital: 'Wellness Centre',
      reportDate: DateTime(2026, 8, 1),
      status: 'uploaded',
      createdAt: DateTime(2026, 8, 1),
    ),
  ];
}
