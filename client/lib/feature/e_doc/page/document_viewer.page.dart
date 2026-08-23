import 'package:client/core/exceptions/base.exception.dart';
import 'package:client/feature/reports/models/document.model.dart';
import 'package:client/feature/reports/notifiers/reports.notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

class DocumentViewerPage extends ConsumerWidget {
  const DocumentViewerPage({super.key, required this.document});

  final DocumentModel document;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          document.title,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => _share(context, ref),
            icon: const Icon(Icons.share, size: 20),
          ),
        ],
      ),
      body: SafeArea(
        child: document.isDemo
            ? _Unsupported(
                icon: Icons.help_outline,
                message:
                    'This is a demo document. No real file is stored on the device.',
                colorScheme: colorScheme,
              )
            : document.isImage
            ? ref
                  .watch(documentPreviewProvider(document.id))
                  .when(
                    data: (bytes) => InteractiveViewer(
                      child: Center(
                        child: Image.memory(bytes, fit: BoxFit.contain),
                      ),
                    ),
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (error, _) => _Unsupported(
                      icon: Icons.error_outline,
                      message: error is AppException
                          ? error.message
                          : 'Unable to open this file.',
                      colorScheme: colorScheme,
                    ),
                  )
            : _Unsupported(
                icon: Icons.picture_as_pdf_outlined,
                message:
                    'PDF preview is not available in-app. Download the file to open it with another app.',
                colorScheme: colorScheme,
                actionLabel: 'Download',
                onAction: () => _download(context, ref),
              ),
      ),
    );
  }

  Future<void> _download(BuildContext context, WidgetRef ref) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      final path = await ref
          .read(reportsProvider.notifier)
          .downloadDocument(document);
      messenger.showSnackBar(SnackBar(content: Text('Saved to $path')));
    } on AppException catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(e.message)));
    } catch (_) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Download failed. Please try again.')),
      );
    }
  }

  Future<void> _share(BuildContext context, WidgetRef ref) async {
    final messenger = ScaffoldMessenger.of(context);
    if (document.isDemo) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Demo documents cannot be shared.')),
      );
      return;
    }
    try {
      final path = await ref
          .read(reportsProvider.notifier)
          .downloadDocument(document);
      await SharePlus.instance.share(ShareParams(files: [XFile(path)]));
    } on AppException catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(e.message)));
    } catch (_) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Unable to share this document.')),
      );
    }
  }
}

class _Unsupported extends StatelessWidget {
  const _Unsupported({
    required this.icon,
    required this.message,
    required this.colorScheme,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String message;
  final ColorScheme colorScheme;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: colorScheme.primary),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 13,
                color: colorScheme.onSurface.withAlpha(180),
              ),
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 16),
              FilledButton.tonal(
                onPressed: onAction,
                child: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
