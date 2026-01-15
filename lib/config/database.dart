// ignore_for_file: public_member_api_docs

import 'package:dart_odbc/dart_odbc.dart';
import 'package:dotenv/dotenv.dart';

class DatabaseConfig {
  static final DotEnv _env = DotEnv()..load();
  static DartOdbc? _connection;

  static DartOdbc getConnection() {
    if (_connection != null) {
      return _connection!;
    }

    final dsn = _env['DB_DSN'] ?? '';
    _connection = DartOdbc(dsn);
    _connection!.connect(dsn: dsn,username: 'awco', password: 'awco');

    return _connection!;
  }

  static void closeConnection() {
    if (_connection != null) {
      _connection!.disconnect();
      _connection = null;
    }
  }
}
