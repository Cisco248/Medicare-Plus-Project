// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reports.notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Manages the patient's document list and all document actions.
///
/// Errors from actions ([uploadDocument], [deleteDocument], ...) are rethrown
/// as [AppException]s so the calling page can show a user-friendly message
/// without corrupting the list state.

@ProviderFor(ReportsNotifier)
final reportsProvider = ReportsNotifierProvider._();

/// Manages the patient's document list and all document actions.
///
/// Errors from actions ([uploadDocument], [deleteDocument], ...) are rethrown
/// as [AppException]s so the calling page can show a user-friendly message
/// without corrupting the list state.
final class ReportsNotifierProvider
    extends $AsyncNotifierProvider<ReportsNotifier, List<DocumentModel>> {
  /// Manages the patient's document list and all document actions.
  ///
  /// Errors from actions ([uploadDocument], [deleteDocument], ...) are rethrown
  /// as [AppException]s so the calling page can show a user-friendly message
  /// without corrupting the list state.
  ReportsNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'reportsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$reportsNotifierHash();

  @$internal
  @override
  ReportsNotifier create() => ReportsNotifier();
}

String _$reportsNotifierHash() => r'5fd69c47d203683a6fff3a6e575a8cce7f47a6f3';

/// Manages the patient's document list and all document actions.
///
/// Errors from actions ([uploadDocument], [deleteDocument], ...) are rethrown
/// as [AppException]s so the calling page can show a user-friendly message
/// without corrupting the list state.

abstract class _$ReportsNotifier extends $AsyncNotifier<List<DocumentModel>> {
  FutureOr<List<DocumentModel>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<DocumentModel>>, List<DocumentModel>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<DocumentModel>>, List<DocumentModel>>,
              AsyncValue<List<DocumentModel>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Raw file bytes of a document, used to preview image documents in-app.

@ProviderFor(documentPreview)
final documentPreviewProvider = DocumentPreviewFamily._();

/// Raw file bytes of a document, used to preview image documents in-app.

final class DocumentPreviewProvider
    extends
        $FunctionalProvider<
          AsyncValue<Uint8List>,
          Uint8List,
          FutureOr<Uint8List>
        >
    with $FutureModifier<Uint8List>, $FutureProvider<Uint8List> {
  /// Raw file bytes of a document, used to preview image documents in-app.
  DocumentPreviewProvider._({
    required DocumentPreviewFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'documentPreviewProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$documentPreviewHash();

  @override
  String toString() {
    return r'documentPreviewProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Uint8List> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Uint8List> create(Ref ref) {
    final argument = this.argument as String;
    return documentPreview(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is DocumentPreviewProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$documentPreviewHash() => r'5ff7e553410d60aa76a489cd2d79cd8959df8c35';

/// Raw file bytes of a document, used to preview image documents in-app.

final class DocumentPreviewFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Uint8List>, String> {
  DocumentPreviewFamily._()
    : super(
        retry: null,
        name: r'documentPreviewProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Raw file bytes of a document, used to preview image documents in-app.

  DocumentPreviewProvider call(String documentId) =>
      DocumentPreviewProvider._(argument: documentId, from: this);

  @override
  String toString() => r'documentPreviewProvider';
}
