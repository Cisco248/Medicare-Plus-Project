// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(OrderNotifier)
final orderProvider = OrderNotifierProvider._();

final class OrderNotifierProvider
    extends $AsyncNotifierProvider<OrderNotifier, List<PharmacyOrder>> {
  OrderNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'orderProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$orderNotifierHash();

  @$internal
  @override
  OrderNotifier create() => OrderNotifier();
}

String _$orderNotifierHash() => r'4b498ae533de8013a6ad14002f18e75d07204b62';

abstract class _$OrderNotifier extends $AsyncNotifier<List<PharmacyOrder>> {
  FutureOr<List<PharmacyOrder>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<PharmacyOrder>>, List<PharmacyOrder>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<PharmacyOrder>>, List<PharmacyOrder>>,
              AsyncValue<List<PharmacyOrder>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(LastAddress)
final lastAddressProvider = LastAddressProvider._();

final class LastAddressProvider
    extends $AsyncNotifierProvider<LastAddress, DeliveryAddress?> {
  LastAddressProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'lastAddressProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$lastAddressHash();

  @$internal
  @override
  LastAddress create() => LastAddress();
}

String _$lastAddressHash() => r'ef4488529f3d63c23563742f5a52dc0130bddf8f';

abstract class _$LastAddress extends $AsyncNotifier<DeliveryAddress?> {
  FutureOr<DeliveryAddress?> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<DeliveryAddress?>, DeliveryAddress?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<DeliveryAddress?>, DeliveryAddress?>,
              AsyncValue<DeliveryAddress?>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
