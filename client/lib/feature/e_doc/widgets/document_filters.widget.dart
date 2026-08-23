import 'package:client/feature/e_doc/notifiers/document_query.notifier.dart';
import 'package:client/feature/reports/models/document.model.dart';
import 'package:client/feature/reports/widgets/report_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DocumentFilters extends ConsumerWidget {
  const DocumentFilters({super.key, required this.documents});

  final List<DocumentModel> documents;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final query = ref.watch(documentQueryProvider);
    final notifier = ref.read(documentQueryProvider.notifier);
    final colorScheme = Theme.of(context).colorScheme;
    final types = _unique(documents.map((d) => d.docType));
    final issuers = _unique(documents.map((d) => d.issuer));
    final hospitals = _unique(documents.map((d) => d.hospital));

    return Column(
      children: [
        TextField(
          onChanged: notifier.setSearch,
          decoration: InputDecoration(
            hintText: 'Search documents',
            prefixIcon: const Icon(Icons.search, size: 18),
            suffixIcon: query.search.isEmpty
                ? null
                : IconButton(
                    onPressed: () => notifier.setSearch(''),
                    icon: const Icon(Icons.close, size: 16),
                  ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            isDense: true,
          ),
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _FilterChip(
                label: query.docType ?? 'Type',
                selected: query.docType != null,
                onTap: () => _pick(
                  context,
                  title: 'Document type',
                  values: types,
                  selected: query.docType,
                  onSelected: notifier.setDocType,
                ),
              ),
              _FilterChip(
                label: query.issuer ?? 'Doctor',
                selected: query.issuer != null,
                onTap: () => _pick(
                  context,
                  title: 'Doctor / issuer',
                  values: issuers,
                  selected: query.issuer,
                  onSelected: notifier.setIssuer,
                ),
              ),
              _FilterChip(
                label: query.hospital ?? 'Hospital',
                selected: query.hospital != null,
                onTap: () => _pick(
                  context,
                  title: 'Hospital / clinic',
                  values: hospitals,
                  selected: query.hospital,
                  onSelected: notifier.setHospital,
                ),
              ),
              _FilterChip(
                label: query.fromDate == null
                    ? 'From date'
                    : 'From ${formatDocumentDate(query.fromDate!)}',
                selected: query.fromDate != null,
                onTap: () => _pickDate(
                  context,
                  current: query.fromDate,
                  onSelected: notifier.setFromDate,
                ),
              ),
              _FilterChip(
                label: query.toDate == null
                    ? 'To date'
                    : 'To ${formatDocumentDate(query.toDate!)}',
                selected: query.toDate != null,
                onTap: () => _pickDate(
                  context,
                  current: query.toDate,
                  onSelected: notifier.setToDate,
                ),
              ),
              _FilterChip(
                label: query.sort == DocumentSort.newest ? 'Newest' : 'Oldest',
                selected: true,
                onTap: () => notifier.setSort(
                  query.sort == DocumentSort.newest
                      ? DocumentSort.oldest
                      : DocumentSort.newest,
                ),
              ),
              if (query.hasFilters)
                TextButton(
                  onPressed: notifier.reset,
                  child: Text(
                    'Clear',
                    style: TextStyle(color: colorScheme.primary, fontSize: 12),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  List<String> _unique(Iterable<String?> values) =>
      values
          .whereType<String>()
          .where((v) => v.trim().isNotEmpty)
          .toSet()
          .toList()
        ..sort();

  Future<void> _pick(
    BuildContext context, {
    required String title,
    required List<String> values,
    required String? selected,
    required void Function(String?) onSelected,
  }) async {
    if (values.isEmpty) return;
    final result = await showModalBottomSheet<String>(
      context: context,
      builder: (context) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            ListTile(title: Text(title)),
            ListTile(
              title: const Text('All'),
              selected: selected == null,
              onTap: () => Navigator.pop(context, ''),
            ),
            ...values.map(
              (value) => ListTile(
                title: Text(value),
                selected: value == selected,
                onTap: () => Navigator.pop(context, value),
              ),
            ),
          ],
        ),
      ),
    );
    if (result == null) return;
    onSelected(result.isEmpty ? null : result);
  }

  Future<void> _pickDate(
    BuildContext context, {
    required DateTime? current,
    required void Function(DateTime?) onSelected,
  }) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: current ?? now,
      firstDate: DateTime(now.year - 10),
      lastDate: now,
    );
    onSelected(picked);
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label, style: const TextStyle(fontSize: 11)),
        selected: selected,
        onSelected: (_) => onTap(),
        selectedColor: colorScheme.primary.withAlpha(30),
        visualDensity: VisualDensity.compact,
      ),
    );
  }
}
