// // ignore_for_file: public_member_api_docs

// import 'dart:convert';
// import 'package:crypto/crypto.dart';

// class PasswordHelper {
//   static String hashPassword(String password) {
//     final bytes = utf8.encode(password);
//     final hash = sha256.convert(bytes);
//     return hash.toString();
//   }

// ignore_for_file: public_member_api_docs

//   static bool verifyPassword(String password, String hashedPassword) {
//     return hashPassword(password) == hashedPassword;
//   }
// }
import 'dart:convert';
import 'dart:developer';
import 'package:crypto/crypto.dart';

class PasswordHelper {
  // Hash a password using SHA-256
  static String hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString(); // 64-character hex string
  }

  // Verify a password against a stored hash
  static bool verifyPassword(String password, String storedHash) {
    // Clean the stored hash first (remove null bytes)
    final cleanedStoredHash = storedHash.replaceAll('\x00', '').trim();

    // Hash the input password
    final hashedInput = hashPassword(password);

    log('DEBUG PasswordHelper:');
    log('  Input password hash: $hashedInput');
    log('  Cleaned stored hash: $cleanedStoredHash');
    log('  Hashed input length: ${hashedInput.length}');
    log('  Cleaned stored length: ${cleanedStoredHash.length}');
    log('  Hashes match: ${hashedInput == cleanedStoredHash}');

    // Compare
    return hashedInput == cleanedStoredHash;
  }
}
