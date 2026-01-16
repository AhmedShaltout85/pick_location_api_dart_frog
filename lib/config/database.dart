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

    // Path to ODBC driver library
    // Linux: /usr/lib/x86_64-linux-gnu/odbc/libtdsodbc.so or libmsodbcsql-17.so
    // Windows: C:\Windows\System32\sqlncli11.dll or msodbcsql17.dll
    // macOS: /usr/local/lib/libmsodbcsql.17.dylib
    final pathToDriver = _env['PATH_TO_DRIVER'] ??
        '/opt/microsoft/msodbcsql17/lib64/libmsodbcsql-17.3.so';
    final dsn = _env['DB_DSN'] ?? 'PickLocationDB';
    final username = _env['DB_USERNAME'] ?? '';
    final password = _env['DB_PASSWORD'] ?? '';

    _connection = DartOdbc(pathToDriver);
    _connection!.connect(
      dsn: dsn,
      username: username,
      password: password,
    );

    return _connection!;
  }

  static void closeConnection() {
    if (_connection != null) {
      _connection!.disconnect();
      _connection = null;
    }
  }
}
