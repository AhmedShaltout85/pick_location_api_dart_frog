// ignore_for_file: public_member_api_docs

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:dotenv/dotenv.dart';

class JWTConfig {
  static final DotEnv _env = DotEnv()..load();
  static String get secretKey => _env['JWT_SECRET'] ?? 'default_secret_key';
  static int get expiryHours => int.parse(_env['JWT_EXPIRY_HOURS'] ?? '24');

  static String generateToken(Map<String, dynamic> payload) {
    final jwt = JWT(
      {
        ...payload,
        'exp': DateTime.now()
                .add(Duration(hours: expiryHours))
                .millisecondsSinceEpoch ~/
            1000,
      },
    );

    return jwt.sign(SecretKey(secretKey));
  }

  static Map<String, dynamic>? verifyToken(String token) {
    try {
      final jwt = JWT.verify(token, SecretKey(secretKey));
      return jwt.payload as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }
}
