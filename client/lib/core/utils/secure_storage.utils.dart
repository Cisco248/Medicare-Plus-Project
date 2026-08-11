import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureLocalStoreUtils {
  SecureLocalStoreUtils();

  FlutterSecureStorage init() {
    final storage = FlutterSecureStorage(
      aOptions: AndroidOptions(
        migrateWithBackup: true,
        storageCipherAlgorithm: StorageCipherAlgorithm.AES_GCM_NoPadding,
        storageNamespace: 'user_credentials',
        biometricType: AndroidBiometricType.biometricOrDeviceCredential,
      ),
      iOptions: IOSOptions(
        accountName: AppleOptions.defaultAccountName,
        accessibility: KeychainAccessibility.unlocked_this_device,
        synchronizable: true,
        creationDate: DateTime.now(),
        lastModifiedDate: DateTime.now(),
      ),
    );
    return storage;
  }
}
