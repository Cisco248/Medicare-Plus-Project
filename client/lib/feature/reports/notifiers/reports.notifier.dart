import 'dart:typed_data';

import 'package:client/feature/auth/notifiers/authentication.notifier.dart';
import 'package:client/feature/reports/models/document.model.dart';
import 'package:client/feature/reports/repositories/report.repository.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'reports.notifier.g.dart';

/// Manages the patient's document list and all document actions.
///
/// Errors from actions ([uploadDocument], [deleteDocument], ...) are rethrown
/// as [AppException]s so the calling page can show a user-friendly message
/// without corrupting the list state.
@riverpod
class ReportsNotifier extends _$ReportsNotifier {
  ReportRepository get _repository => ref.read(reportRepositoryProvider);

  String? get _token => ref.read(authenticationProvider).value?.token;

  @override
  Future<List<DocumentModel>> build() =>
      _repository.fetchDocuments(token: _token);

  /// Re-fetches the document list from the backend.
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => _repository.fetchDocuments(token: _token),
    );
  }

  /// Uploads a new document and refreshes the list on success.
  Future<void> uploadDocument({
    required String title,
    required String docType,
    String? description,
    DateTime? reportDate,
    required String fileName,
    required Uint8List fileBytes,
  }) async {
    await _repository.uploadDocument(
      title: title,
      docType: docType,
      description: description,
      reportDate: reportDate,
      fileName: fileName,
      fileBytes: fileBytes,
      token: _token,
    );
    await refresh();
  }

  /// Deletes a document and removes it from the list on success.
  Future<void> deleteDocument(String id) async {
    await _repository.deleteDocument(id, token: _token);
    final current = state.value;
    if (current != null) {
      state = AsyncValue.data(
        current.where((document) => document.id != id).toList(growable: false),
      );
    }
  }

  /// Downloads the document file to the app's documents folder and returns
  /// the saved location.
  Future<String> downloadDocument(DocumentModel document) async {
    final directory = await getApplicationDocumentsDirectory();
    final savePath = '${directory.path}/${document.fileName}';
    await _repository.downloadDocument(document.id, savePath, token: _token);
    return savePath;
  }
}

/// Raw file bytes of a document, used to preview image documents in-app.
@riverpod
Future<Uint8List> documentPreview(Ref ref, String documentId) {
  final token = ref.watch(authenticationProvider).value?.token;
  return ref
      .watch(reportRepositoryProvider)
      .fetchDocumentBytes(documentId, token: token);
}
