// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'form.notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(FormState)
final formStateProvider = FormStateProvider._();

final class FormStateProvider extends $NotifierProvider<FormState, String> {
  FormStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'formStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$formStateHash();

  @$internal
  @override
  FormState create() => FormState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$formStateHash() => r'ef08d62c1f4206777a52826c36df2c932d8405ca';

abstract class _$FormState extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
