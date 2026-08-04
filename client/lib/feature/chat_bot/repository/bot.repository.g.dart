// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bot.repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(botRepositoryImpService)
final botRepositoryImpServiceProvider = BotRepositoryImpServiceProvider._();

final class BotRepositoryImpServiceProvider
    extends
        $FunctionalProvider<
          BotRepositoryImpService,
          BotRepositoryImpService,
          BotRepositoryImpService
        >
    with $Provider<BotRepositoryImpService> {
  BotRepositoryImpServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'botRepositoryImpServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$botRepositoryImpServiceHash();

  @$internal
  @override
  $ProviderElement<BotRepositoryImpService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  BotRepositoryImpService create(Ref ref) {
    return botRepositoryImpService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BotRepositoryImpService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BotRepositoryImpService>(value),
    );
  }
}

String _$botRepositoryImpServiceHash() =>
    r'b05ba95eb30a4c5271182b11b81906f39c041b73';
