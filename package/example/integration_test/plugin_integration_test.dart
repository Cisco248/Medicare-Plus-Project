import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_health_connect/app.dart';

/// Requires an Android device/emulator with Health Connect available.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('initialize and check availability', (tester) async {
    final healthConnect = FlutterHealthConnect();
    await healthConnect.initialize();
    final availability = await healthConnect.getAvailability();
    expect(
      availability,
      anyOf(
        Availability.available,
        Availability.notInstalled,
        Availability.notSupported,
        Availability.unknown,
      ),
    );
  });
}
