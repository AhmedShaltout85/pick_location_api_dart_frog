import 'dart:convert';
import 'dart:developer';
import 'package:crypto/crypto.dart';

void main() {
  const password = 'admin123';
  final bytes = utf8.encode(password);
  final hash = sha256.convert(bytes);
  log('Password: $password');
  log('Hash: $hash');
  log('Hash length: ${hash.toString().length}');
}
