// ignore_for_file: public_member_api_docs

import 'dart:convert';
import 'package:crypto/crypto.dart';

class PasswordHelper {
  static String hashPassword(String password) {
    final bytes = utf8.encode(password);
    final hash = sha256.convert(bytes);
    return hash.toString();
  }

  static bool verifyPassword(String password, String hashedPassword) {
    return hashPassword(password) == hashedPassword;
  }
}
