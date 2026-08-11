import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_health_connect_example/main.dart';

void main() {
  testWidgets('example app loads', (tester) async {
    await tester.pumpWidget(const HealthConnectExampleApp());
    await tester.pump();
    expect(find.textContaining('Health Connect Example'), findsOneWidget);
  });
}
