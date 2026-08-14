import 'package:mysql1/mysql1.dart';

const String appName = "MediCare Plus";
const String appVersion = '1.0.0';

final settings = ConnectionSettings(
  host: '127.0.0.1',
  port: 3306,
  user: 'root',
  password: 'root123',
  db: 'medicare_plus',
);

final String isSetupKey = 'setup_key';
final String userTokenKey = 'user_token';
final String userEmailKey = 'user_email';
final String userPasswordKey = 'user_password';
