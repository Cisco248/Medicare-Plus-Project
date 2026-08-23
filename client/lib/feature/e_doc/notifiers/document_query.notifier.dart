import 'package:client/feature/reports/models/document.model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum DocumentSort { newest, oldest }

class DocumentQuery {
  const DocumentQuery({
    this.search = '',
    this.docType,
    this.issuer,
    this.hospital,
    this.fromDate,
    this.toDate,
    this.sort = DocumentSort.newest,
  });

  final String search;
  final String? docType;
  final String? issuer;
  final String? hospital;
  final DateTime? fromDate;
  final DateTime? toDate;
  final DocumentSort sort;

  bool get hasFilters =>
      search.trim().isNotEmpty ||
      docType != null ||
      issuer != null ||
      hospital != null ||
      fromDate != null ||
      toDate != null;

  DocumentQuery copyWith({
    String? search,
    String? docType,
    String? issuer,
    String? hospital,
    DateTime? fromDate,
    DateTime? toDate,
    DocumentSort? sort,
    bool clearDocType = false,
    bool clearIssuer = false,
    bool clearHospital = false,
    bool clearFromDate = false,
    bool clearToDate = false,
  }) {
    return DocumentQuery(
      search: search ?? this.search,
      docType: clearDocType ? null : docType ?? this.docType,
      issuer: clearIssuer ? null : issuer ?? this.issuer,
      hospital: clearHospital ? null : hospital ?? this.hospital,
      fromDate: clearFromDate ? null : fromDate ?? this.fromDate,
      toDate: clearToDate ? null : toDate ?? this.toDate,
      sort: sort ?? this.sort,
    );
  }

  List<DocumentModel> apply(List<DocumentModel> documents) {
    final query = search.trim().toLowerCase();
    final filtered = documents.where((document) {
      final matchesSearch =
          query.isEmpty ||
          document.title.toLowerCase().contains(query) ||
          document.docType.toLowerCase().contains(query) ||
          (document.issuer?.toLowerCase().contains(query) ?? false) ||
          (document.hospital?.toLowerCase().contains(query) ?? false) ||
          (document.description?.toLowerCase().contains(query) ?? false);
      final matchesType = docType == null || document.docType == docType;
      final matchesIssuer = issuer == null || document.issuer == issuer;
      final matchesHospital = hospital == null || document.hospital == hospital;
      final date = document.reportDate ?? document.createdAt;
      final matchesFrom =
          fromDate == null ||
          (date != null && !date.isBefore(_dateOnly(fromDate!)));
      final matchesTo =
          toDate == null || (date != null && !date.isAfter(_endOfDay(toDate!)));
      return matchesSearch &&
          matchesType &&
          matchesIssuer &&
          matchesHospital &&
          matchesFrom &&
          matchesTo;
    }).toList();

    filtered.sort((a, b) {
      final aDate =
          a.createdAt ?? a.reportDate ?? DateTime.fromMillisecondsSinceEpoch(0);
      final bDate =
          b.createdAt ?? b.reportDate ?? DateTime.fromMillisecondsSinceEpoch(0);
      return sort == DocumentSort.newest
          ? bDate.compareTo(aDate)
          : aDate.compareTo(bDate);
    });
    return filtered;
  }

  DateTime _dateOnly(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  DateTime _endOfDay(DateTime date) =>
      DateTime(date.year, date.month, date.day, 23, 59, 59);
}

class DocumentQueryNotifier extends Notifier<DocumentQuery> {
  @override
  DocumentQuery build() => const DocumentQuery();

  void setSearch(String value) => state = state.copyWith(search: value);

  void setDocType(String? value) =>
      state = state.copyWith(docType: value, clearDocType: value == null);

  void setIssuer(String? value) =>
      state = state.copyWith(issuer: value, clearIssuer: value == null);

  void setHospital(String? value) =>
      state = state.copyWith(hospital: value, clearHospital: value == null);

  void setFromDate(DateTime? value) =>
      state = state.copyWith(fromDate: value, clearFromDate: value == null);

  void setToDate(DateTime? value) =>
      state = state.copyWith(toDate: value, clearToDate: value == null);

  void setSort(DocumentSort value) => state = state.copyWith(sort: value);

  void reset() => state = const DocumentQuery();
}

final documentQueryProvider =
    NotifierProvider<DocumentQueryNotifier, DocumentQuery>(
      DocumentQueryNotifier.new,
    );
