import 'package:client/feature/pharmacy/models/prescription.model.dart';
import 'package:client/feature/pharmacy/models/product.model.dart';
import 'package:client/feature/pharmacy/notifiers/cart.notifier.dart';
import 'package:client/feature/pharmacy/notifiers/prescription.notifier.dart';
import 'package:client/feature/reports/notifiers/reports.notifier.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PrescriptionVerificationPage extends ConsumerWidget {
  const PrescriptionVerificationPage({super.key, required this.product});

  final PharmacyProduct product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prescriptionRecord = ref.watch(prescriptionProvider);
    final record =
        prescriptionRecord.whenData((cb) => cb).value![product.id] ??
        PrescriptionRecord(productId: product.id);

    final documents = ref.watch(reportsProvider).value ?? const [];
    final prescriptions = documents
        .where(
          (document) => document.docType.toLowerCase().contains('prescription'),
        )
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Prescription required',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          children: [
            Text(
              product.name,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'This item cannot be purchased freely. Upload or select a prescription, then complete demo verification. This is a university simulation, not a real pharmacy check.',
            ),
            const SizedBox(height: 16),
            Text(
              'Status: ${record.status!.label}',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            if (record.fileName != null) Text('Attached: ${record.fileName}'),
            const SizedBox(height: 16),
            if (prescriptions.isNotEmpty) ...[
              const Text('Select from your E-Doc prescriptions'),
              ...prescriptions.map(
                (document) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(document.title),
                  subtitle: Text(document.docType),
                  onTap: () => ref
                      .read(prescriptionProvider.notifier)
                      .submit(
                        productId: product.id,
                        documentId: document.id,
                        fileName: document.fileName,
                      ),
                ),
              ),
              const SizedBox(height: 8),
            ],
            OutlinedButton(
              onPressed: () async {
                final result = await FilePicker.pickFiles(
                  type: FileType.custom,
                  allowedExtensions: const ['pdf', 'jpg', 'jpeg', 'png'],
                );
                final file = result?.files.firstOrNull;
                if (file == null) return;
                await ref
                    .read(prescriptionProvider.notifier)
                    .submit(productId: product.id, fileName: file.name);
              },
              child: const Text('Upload a prescription file'),
            ),
            const SizedBox(height: 12),
            if (record.status == PrescriptionStatus.pendingVerification) ...[
              FilledButton.tonal(
                onPressed: () => ref
                    .read(prescriptionProvider.notifier)
                    .simulateDecision(product.id, approve: true),
                child: const Text('Demo: approve'),
              ),
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: () => ref
                    .read(prescriptionProvider.notifier)
                    .simulateDecision(product.id, approve: false),
                child: const Text('Demo: reject'),
              ),
            ],
            if (record.status == PrescriptionStatus.approved) ...[
              const SizedBox(height: 12),
              FilledButton(
                onPressed: () async {
                  final error = await ref
                      .read(cartProvider.notifier)
                      .add(product);
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(error ?? '${product.name} added to cart'),
                    ),
                  );
                  if (error == null) Navigator.of(context).pop();
                },
                child: const Text('Continue order'),
              ),
            ],
            if (record.status == PrescriptionStatus.rejected)
              const Padding(
                padding: EdgeInsets.only(top: 12),
                child: Text(
                  'This demo prescription was rejected. Upload a different file to try again.',
                ),
              ),
          ],
        ),
      ),
    );
  }
}
