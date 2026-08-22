import 'package:client/feature/reports/models/document.model.dart';
import 'package:client/feature/reports/page/report_details.page.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// Formats a date as `dd/mm/yyyy` for display (the project does not use intl).
String formatDocumentDate(DateTime date) =>
    '${date.day.toString().padLeft(2, '0')}/'
    '${date.month.toString().padLeft(2, '0')}/'
    '${date.year}';

Color documentStatusColor(DocumentStatus status) {
  switch (status) {
    case DocumentStatus.uploaded:
      return Colors.blue;
    case DocumentStatus.processing:
      return Colors.orange;
    case DocumentStatus.reviewed:
      return Colors.green;
    case DocumentStatus.rejected:
      return Colors.red;
  }
}

/// Small colored chip showing the tracking status of a document.
class DocumentStatusChip extends StatelessWidget {
  const DocumentStatusChip({super.key, required this.status});

  final DocumentStatus status;

  @override
  Widget build(BuildContext context) {
    final color = documentStatusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withAlpha(30),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status.label,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}

/// A single document entry in the reports list.
class ReportCard extends StatelessWidget {
  const ReportCard({super.key, required this.document});

  final DocumentModel document;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final uploaded = document.createdAt;

    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ReportDetailsPage(document: document),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainer.withAlpha(180),
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: colorScheme.primary.withAlpha(25),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: FaIcon(
                  document.isImage
                      ? FontAwesomeIcons.fileImage
                      : FontAwesomeIcons.filePdf,
                  size: 18,
                  color: colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    document.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    uploaded == null
                        ? document.docType
                        : '${document.docType} \u2022 '
                              '${formatDocumentDate(uploaded.toLocal())}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 11,
                      color: colorScheme.onSurface.withAlpha(150),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            DocumentStatusChip(status: document.documentStatus),
          ],
        ),
      ),
    );
  }
}
