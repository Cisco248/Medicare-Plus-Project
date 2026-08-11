// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ChatBotNotify)
final chatBotNotifyProvider = ChatBotNotifyProvider._();

final class ChatBotNotifyProvider
    extends $NotifierProvider<ChatBotNotify, ResponseModel> {
  ChatBotNotifyProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'chatBotNotifyProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$chatBotNotifyHash();

  @$internal
  @override
  ChatBotNotify create() => ChatBotNotify();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ResponseModel value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ResponseModel>(value),
    );
  }
}

String _$chatBotNotifyHash() => r'50e6c1002486eb7d9976d8d5202d9bce403b0597';

abstract class _$ChatBotNotify extends $Notifier<ResponseModel> {
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
