import 'package:mysql1/mysql1.dart';

const String appName = "Medicare+ Solutions";
const String appVersion = 'V1.0.0';

final settings = ConnectionSettings(
  host: '127.0.0.1',
  port: 3306,
  user: 'root',
  password: 'root123',
  db: 'medicare_plus',
);
