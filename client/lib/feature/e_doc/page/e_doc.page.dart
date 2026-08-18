import 'package:client/core/exceptions/base.exception.dart';
import 'package:client/feature/e_doc/notifiers/document_query.notifier.dart';
import 'package:client/feature/e_doc/widgets/document_filters.widget.dart';
import 'package:client/feature/e_doc/widgets/form.widget.dart';
import 'package:client/feature/e_doc/widgets/generate.widget.dart';
import 'package:client/feature/reports/notifiers/reports.notifier.dart';
import 'package:client/feature/reports/page/upload_report.page.dart';
import 'package:client/feature/reports/widgets/report_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class EDocPage extends ConsumerStatefulWidget {
  const EDocPage({super.key});

  @override
  ConsumerState<EDocPage> createState() => _EDocPageState();
}

class _EDocPageState extends ConsumerState<EDocPage> {
  int _section = 0;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'E-Doc',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'View uploaded documents or generate a personalized assessment.',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              color: colorScheme.onSurface.withAlpha(150),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _SectionChip(
                label: 'Documents',
                selected: _section == 0,
                onTap: () => setState(() => _section = 0),
              ),
              const SizedBox(width: 8),
              _SectionChip(
                label: 'Assessment',
                selected: _section == 1,
                onTap: () => setState(() => _section = 1),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(child: _section == 0 ? const _DocumentsSection() : const _AssessmentSection()),
        ],
      ),
    );
  }
}

class _SectionChip extends StatelessWidget {
  const _SectionChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
    );
  }
}

class _DocumentsSection extends ConsumerWidget {
  const _DocumentsSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reports = ref.watch(reportsProvider);
    final query = ref.watch(documentQueryProvider);

    return reports.when(
      data: (documents) {
        final visible = query.apply(documents);
        return Column(
          children: [
            Row(
              children: [
                const Spacer(),
                FilledButton.tonalIcon(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const UploadReportPage()),
                  ),
                  icon: const FaIcon(FontAwesomeIcons.plus, size: 12),
                  label: const Text('Upload'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            DocumentFilters(documents: documents),
            if (documents.any((document) => document.isDemo)) ...[
              const SizedBox(height: 8),
              Text(
                'Showing demo documents because the document service is unavailable.',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 11,
                  color: Theme.of(context).colorScheme.onSurface.withAlpha(150),
                ),
              ),
            ],
            const SizedBox(height: 8),
            Expanded(
              child: visible.isEmpty
                  ? _EmptyDocuments(
                      hasSource: documents.isNotEmpty,
                      onUpload: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const UploadReportPage(),
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
      error: (error, _) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              error is AppException
                  ? error.message
                  : 'Unable to load your documents.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            FilledButton.tonal(
              onPressed: () => ref.read(reportsProvider.notifier).refresh(),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyDocuments extends StatelessWidget {
  const _EmptyDocuments({required this.hasSource, required this.onUpload});

  final bool hasSource;
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
            size: 36,
            color: colorScheme.onSurface.withAlpha(80),
          ),
          const SizedBox(height: 12),
          Text(
            hasSource ? 'No documents match these filters' : 'No documents yet',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            hasSource
                ? 'Try a different search or clear the filters.'
                : 'Upload reports, prescriptions and lab results to keep them in one place.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              color: colorScheme.onSurface.withAlpha(150),
            ),
          ),
          if (!hasSource) ...[
            const SizedBox(height: 16),
            FilledButton.tonal(
              onPressed: onUpload,
              child: const Text('Upload a document'),
            ),
          ],
        ],
      ),
    );
  }
}

class _AssessmentSection extends StatelessWidget {
  const _AssessmentSection();

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Column(
        children: [
          EDocAssessmentForm(),
          SizedBox(height: 24),
          GenerateWidget(),
          SizedBox(height: 24),
        ],
      ),
    );
  }
}
