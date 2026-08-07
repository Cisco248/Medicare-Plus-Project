// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'e_doc.viewmodel.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(EDocViewModel)
final eDocViewModelProvider = EDocViewModelProvider._();

final class EDocViewModelProvider
    extends $NotifierProvider<EDocViewModel, ResponseModel> {
  EDocViewModelProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'eDocViewModelProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$eDocViewModelHash();

  @$internal
  @override
  EDocViewModel create() => EDocViewModel();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ResponseModel value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ResponseModel>(value),
    );
  }
}

String _$eDocViewModelHash() => r'7763c05e9bff618ba93a59deb186a705708ab82e';

abstract class _$EDocViewModel extends $Notifier<ResponseModel> {
  ResponseModel build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<ResponseModel, ResponseModel>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ResponseModel, ResponseModel>,
              ResponseModel,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
