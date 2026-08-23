import 'package:client/feature/auth/models/auth.model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'register payload uses backend field names and a date-only birthday',
    () {
      final payload = AuthRequestModel(
        name: 'Ada',
        email: 'ada@example.com',
        birthDay: DateTime(1990, 5, 12),
        weight: 62,
        height: 168,
        mobnum: '0712345678',
        password: 'secret123',
      ).toRegisterJson();

      expect(payload['date_of_birth'], '1990-05-12');
      expect(payload['height_cm'], 168);
      expect(payload['weight_kg'], 62);
      expect(payload.containsKey('birthDay'), isFalse);
      expect(payload.containsKey('password'), isTrue);
    },
  );

  test('age accounts for birthday not yet reached this year', () {
    final today = DateTime.now();
    final nextMonth = DateTime(
      today.year - 30,
      today.month,
      today.day,
    ).add(const Duration(days: 10));
    expect(AuthRequestModel.ageFrom(nextMonth), 29);
  });
}
