import 'dart:convert';
import 'package:crypto/crypto.dart';

void main() {
  final password = 'admin123';
  final bytes = utf8.encode(password);
  final hash = sha256.convert(bytes);
  print('Password: $password');
  print('Hash: $hash');
  print('Hash length: ${hash.toString().length}');
}
