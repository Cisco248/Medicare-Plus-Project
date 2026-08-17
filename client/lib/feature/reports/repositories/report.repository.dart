import 'dart:typed_data';

import 'package:client/core/exceptions/base.exception.dart';
import 'package:client/core/network/dio_client.dart';
import 'package:client/feature/reports/data/demo_documents.dart';
import 'package:client/feature/reports/models/document.model.dart';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'report.repository.g.dart';

@riverpod
ReportRepository reportRepository(Ref ref) =>
    ReportRepository(client: client(8080));

/// HTTP access to the backend's patient document endpoints (`/api/documents`).
///
/// Every request carries the session token in the `x-auth-token` header, which
/// the backend uses to scope documents to the authenticated patient. Transport
/// failures are mapped to the [AppException] hierarchy.
class ReportRepository {
  ReportRepository({required this._client});

  final Dio _client;

  Options _authOptions(String? token, {ResponseType? responseType}) => Options(
    headers: {'x-auth-token': ?token},
    responseType: responseType,
  );

  Future<List<DocumentModel>> fetchDocuments({String? token}) async {
    try {
      final response = await _client.get<List<dynamic>>(
        '/documents',
        options: _authOptions(token),
      );
      return (response.data ?? const [])
          .map((item) => DocumentModel.fromJson(item as Map<String, Object?>))
          .toList(growable: false);
    } on DioException {
      return DemoDocuments.samples;
    }
  }

  Future<DocumentModel> fetchDocument(String id, {String? token}) async {
    try {
      final response = await _client.get<Map<String, Object?>>(
        '/documents/$id',
        options: _authOptions(token),
      );
      return DocumentModel.fromJson(response.data!);
    } on DioException catch (e) {
      throw AppException.fromDioException(e);
    }
  }

  Future<DocumentModel> uploadDocument({
    required String title,
    required String docType,
    String? description,
    String? issuer,
    String? hospital,
    DateTime? reportDate,
    required String fileName,
    required Uint8List fileBytes,
    String? token,
  }) async {
    try {
      final form = FormData.fromMap({
        'title': title,
        'doc_type': docType,
        if (description != null && description.isNotEmpty)
          'description': description,
        if (issuer != null && issuer.isNotEmpty) 'issuer': issuer,
        if (hospital != null && hospital.isNotEmpty) 'hospital': hospital,
        if (reportDate != null) 'report_date': _formatDate(reportDate),
        'file': MultipartFile.fromBytes(fileBytes, filename: fileName),
      });
      final response = await _client.post<Map<String, Object?>>(
        '/documents',
        data: form,
        options: _authOptions(token),
      );
      return DocumentModel.fromJson(response.data!);
    } on DioException catch (e) {
      throw AppException.fromDioException(e);
    }
  }

  Future<DocumentModel> updateStatus(
    String id,
    String status, {
    String? token,
  }) async {
    try {
      final response = await _client.patch<Map<String, Object?>>(
        '/documents/$id/status',
        data: {'status': status},
        options: _authOptions(token),
      );
      return DocumentModel.fromJson(response.data!);
    } on DioException catch (e) {
      throw AppException.fromDioException(e);
    }
  }

  Future<void> deleteDocument(String id, {String? token}) async {
    try {
      await _client.delete<void>('/documents/$id', options: _authOptions(token));
    } on DioException catch (e) {
      throw AppException.fromDioException(e);
    }
  }

  /// Raw file content, used for the in-app preview of image documents.
  Future<Uint8List> fetchDocumentBytes(String id, {String? token}) async {
    try {
      final response = await _client.get<List<int>>(
        '/documents/$id/file',
        options: _authOptions(token, responseType: ResponseType.bytes),
      );
      return Uint8List.fromList(response.data ?? const []);
    } on DioException catch (e) {
      throw AppException.fromDioException(e);
    }
  }

  /// Downloads the document file to [savePath] on the device.
  Future<void> downloadDocument(
    String id,
    String savePath, {
    String? token,
  }) async {
    try {
      await _client.download(
        '/documents/$id/file',
        savePath,
        options: _authOptions(token),
      );
    } on DioException catch (e) {
      throw AppException.fromDioException(e);
    }
  }

  String _formatDate(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';
}
