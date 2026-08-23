// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity.notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ActivityNotifier)
final activityProvider = ActivityNotifierProvider._();

final class ActivityNotifierProvider
    extends $NotifierProvider<ActivityNotifier, KnowledgeState> {
  ActivityNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activityProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activityNotifierHash();

  @$internal
  @override
  ActivityNotifier create() => ActivityNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(KnowledgeState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<KnowledgeState>(value),
    );
  }
}

String _$activityNotifierHash() => r'7262f2b5472229a614006b6ec58646abfe2b18a4';

abstract class _$ActivityNotifier extends $Notifier<KnowledgeState> {
  KnowledgeState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<KnowledgeState, KnowledgeState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<KnowledgeState, KnowledgeState>,
              KnowledgeState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
