// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bot.service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(botService)
final botServiceProvider = BotServiceProvider._();

final class BotServiceProvider
    extends $FunctionalProvider<BotService, BotService, BotService>
    with $Provider<BotService> {
  BotServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'botServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$botServiceHash();

  @$internal
  @override
  $ProviderElement<BotService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  BotService create(Ref ref) {
    return botService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BotService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BotService>(value),
    );
  }
}

String _$botServiceHash() => r'901c4165c5a21711b400ddf25205e3c925360e90';
