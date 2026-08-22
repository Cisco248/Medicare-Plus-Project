// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'form_mode.notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(FormStateNotifier)
final formStateProvider = FormStateNotifierProvider._();

final class FormStateNotifierProvider
    extends $NotifierProvider<FormStateNotifier, FormStates> {
  FormStateNotifierProvider._()
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
  String debugGetCreateSourceHash() => _$formStateNotifierHash();

  @$internal
  @override
  FormStateNotifier create() => FormStateNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FormStates value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FormStates>(value),
    );
  }
}

String _$formStateNotifierHash() => r'7852cad2802a0c74f5f3df2ef285dbb62cbe9a5b';

abstract class _$FormStateNotifier extends $Notifier<FormStates> {
  FormStates build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<FormStates, FormStates>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<FormStates, FormStates>,
              FormStates,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
