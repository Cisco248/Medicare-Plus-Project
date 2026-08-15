import 'package:client/core/exceptions/base.exception.dart';
import 'package:client/feature/e_doc/notifiers/document_query.notifier.dart';
import 'package:client/feature/e_doc/widgets/document_filters.widget.dart';
import 'package:client/feature/reports/notifiers/reports.notifier.dart';
import 'package:client/feature/reports/page/upload_report.page.dart';
import 'package:client/feature/reports/widgets/report_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// Reports tab: the patient's uploaded medical documents.
class ReportsPage extends ConsumerWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final reports = ref.watch(reportsProvider);
    final query = ref.watch(documentQueryProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'My Reports',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
              const Spacer(),
              FilledButton.tonalIcon(
                onPressed: () => _openUploadPage(context),
                icon: const FaIcon(FontAwesomeIcons.plus, size: 12),
                label: const Text('Upload'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: reports.when(
              data: (documents) {
                final visible = query.apply(documents);
                if (documents.isEmpty) {
                  return _EmptyState(onUpload: () => _openUploadPage(context));
                }
                return Column(
                  children: [
                    DocumentFilters(documents: documents),
                    if (documents.any((document) => document.isDemo))
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          'Showing demo documents because the document service is unavailable.',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 11,
                            color: colorScheme.onSurface.withAlpha(150),
                          ),
                        ),
                      ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: visible.isEmpty
                          ? Center(
                              child: Text(
                                'No documents match these filters.',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 12,
                                  color: colorScheme.onSurface.withAlpha(150),
                                ),
                              ),
                            )
                          : RefreshIndicator(
                              onRefresh: () =>
                                  ref.read(reportsProvider.notifier).refresh(),
                              child: ListView.builder(
                                physics: const AlwaysScrollableScrollPhysics(),
                                itemCount: visible.length,
                                itemBuilder: (context, index) =>
                                    ReportCard(document: visible[index]),
                              ),
                            ),
                    ),
                  ],
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => _ErrorState(
                message: error is AppException
                    ? error.message
                    : 'Unable to load your documents. Please try again.',
                onRetry: () => ref.read(reportsProvider.notifier).refresh(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openUploadPage(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => const UploadReportPage()));
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onUpload});

  final VoidCallback onUpload;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FaIcon(
            FontAwesomeIcons.folderOpen,
            size: 40,
            color: colorScheme.onSurface.withAlpha(80),
          ),
          const SizedBox(height: 16),
          Text(
            'No documents yet',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Upload your medical reports to keep them in one place.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              color: colorScheme.onSurface.withAlpha(150),
            ),
          ),
          const SizedBox(height: 16),
          FilledButton.tonal(
            onPressed: onUpload,
            child: const Text('Upload a document'),
          ),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FaIcon(
            FontAwesomeIcons.circleExclamation,
            size: 32,
            color: colorScheme.error,
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                color: colorScheme.onSurface,
              ),
            ),
          ),
          const SizedBox(height: 16),
          FilledButton.tonal(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }
}
