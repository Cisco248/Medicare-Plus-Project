import 'package:client/core/exceptions/base.exception.dart';
import 'package:client/feature/reports/models/document.model.dart';
import 'package:client/feature/reports/notifiers/reports.notifier.dart';
import 'package:client/feature/reports/widgets/report_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// Detail view of a single uploaded document with download/delete actions.
class ReportDetailsPage extends ConsumerStatefulWidget {
  const ReportDetailsPage({super.key, required this.document});

  final DocumentModel document;

  @override
  ConsumerState<ReportDetailsPage> createState() => _ReportDetailsPageState();
}

class _ReportDetailsPageState extends ConsumerState<ReportDetailsPage> {
  bool _isBusy = false;

  DocumentModel get document => widget.document;

  Future<void> _download() async {
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _isBusy = true);
    try {
      final savedPath = await ref
          .read(reportsProvider.notifier)
          .downloadDocument(document);
      messenger.showSnackBar(SnackBar(content: Text('Saved to $savedPath')));
    } on AppException catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(e.message)));
    } catch (_) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Download failed. Please try again.')),
      );
    } finally {
      if (mounted) setState(() => _isBusy = false);
    }
  }

  Future<void> _delete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete document?'),
        content: Text('"${document.title}" will be permanently deleted.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    setState(() => _isBusy = true);
    try {
      await ref.read(reportsProvider.notifier).deleteDocument(document.id);
      messenger.showSnackBar(const SnackBar(content: Text('Document deleted.')));
      navigator.pop();
    } on AppException catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(e.message)));
      if (mounted) setState(() => _isBusy = false);
    } catch (_) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Delete failed. Please try again.')),
      );
      if (mounted) setState(() => _isBusy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Document Details',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Preview(document: document),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      document.title,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  DocumentStatusChip(status: document.documentStatus),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainer.withAlpha(180),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    _InfoRow(label: 'Type', value: document.docType),
                    _InfoRow(
                      label: 'Uploaded',
                      value: document.createdAt == null
                          ? '-'
                          : formatDocumentDate(document.createdAt!.toLocal()),
                    ),
                    _InfoRow(
                      label: 'Report date',
                      value: document.reportDate == null
                          ? '-'
                          : formatDocumentDate(document.reportDate!),
                    ),
                    _InfoRow(label: 'File name', value: document.fileName),
                    _InfoRow(
                      label: 'File type',
                      value: document.fileType.toUpperCase(),
                    ),
                    _InfoRow(
                      label: 'Status',
                      value: document.documentStatus.label,
                    ),
                  ],
                ),
              ),
              if (document.description != null &&
                  document.description!.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(
                  'Description',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  document.description!,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    color: colorScheme.onSurface.withAlpha(200),
                  ),
                ),
              ],
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: FilledButton.tonalIcon(
                      onPressed: _isBusy ? null : _download,
                      icon: const FaIcon(FontAwesomeIcons.download, size: 14),
                      label: const Text('Download'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _isBusy ? null : _delete,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: colorScheme.error,
                      ),
                      icon: const FaIcon(FontAwesomeIcons.trashCan, size: 14),
                      label: const Text('Delete'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Inline preview: the actual image for image documents, an icon for PDFs.
class _Preview extends ConsumerWidget {
  const _Preview({required this.document});

  final DocumentModel document;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    Widget placeholder(Widget child) => Container(
      width: double.infinity,
      height: 180,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer.withAlpha(180),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(child: child),
    );

    if (!document.isImage) {
      return placeholder(
        FaIcon(FontAwesomeIcons.filePdf, size: 48, color: colorScheme.primary),
      );
    }

    return ref
        .watch(documentPreviewProvider(document.id))
        .when(
          data: (bytes) => ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.memory(
              bytes,
              width: double.infinity,
              height: 220,
              fit: BoxFit.cover,
            ),
          ),
          loading: () => placeholder(const CircularProgressIndicator()),
          error: (_, _) => placeholder(
            FaIcon(
              FontAwesomeIcons.fileImage,
              size: 48,
              color: colorScheme.primary,
            ),
          ),
        );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                color: colorScheme.onSurface.withAlpha(150),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
