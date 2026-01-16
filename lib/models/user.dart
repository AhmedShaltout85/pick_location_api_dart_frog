import 'dart:developer';

class User {
  User({
    this.id,
    this.userName,
    this.userPassword,
    this.role,
    this.controlUnit,
    this.technicalId,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    // Get the password value from any key that contains 'password'
    dynamic password;

    // Try exact key first
    if (json.containsKey('user_password')) {
      password = json['user_password'];
    } else {
      // Find any key containing 'password'
      final passwordKey = json.keys.firstWhere(
        (key) => key.toLowerCase().contains('password'),
        orElse: () => '',
      );
      if (passwordKey.isNotEmpty) {
        password = json[passwordKey];
      }
    }

    // CRITICAL: Trim the password and handle NVARCHAR padding
    String? trimmedPassword;
    if (password != null) {
      final passwordStr = password is String ? password : password.toString();

      // Check what's after position 64
      if (passwordStr.length > 64) {
        log('DEBUG: Character at position 64: ${passwordStr.codeUnitAt(64)}');
        log('DEBUG: Character at position 65: ${passwordStr.codeUnitAt(65)}');
        log('DEBUG: Substring 60-70: "${passwordStr.substring(60, 70)}"');
      }

      // SHA-256 hash is always 64 characters, so take only the first 64
      if (passwordStr.length >= 64) {
        trimmedPassword = passwordStr.substring(0, 64);
      } else {
        trimmedPassword = passwordStr.trim();
      }

      log('DEBUG fromJson: Final password length: ${trimmedPassword.length}');
    }

    return User(
      id: _parseIntSafe(json['id']),
      userName: json['user_name'] as String?,
      userPassword: trimmedPassword,
      role: _parseIntSafe(json['role']),
      controlUnit: json['control_unit'] as String?,
      technicalId: _parseIntSafe(json['technical_id']),
    );
  }
  final int? id;
  final String? userName;
  final String? userPassword;
  final int? role;
  final String? controlUnit;
  final int? technicalId;

  static int? _parseIntSafe(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return int.tryParse(value.toString());
  }

  Map<String, dynamic> toJson({bool includePassword = false}) {
    final map = <String, dynamic>{
      'id': id,
      'user_name': userName,
      'role': role,
      'control_unit': controlUnit,
      'technical_id': technicalId,
    };

    if (includePassword) {
      map['user_password'] = userPassword;
    }

    return map;
  }

  User copyWith({
    int? id,
    String? userName,
    String? userPassword,
    int? role,
    String? controlUnit,
    int? technicalId,
  }) {
    return User(
      id: id ?? this.id,
      userName: userName ?? this.userName,
      userPassword: userPassword ?? this.userPassword,
      role: role ?? this.role,
      controlUnit: controlUnit ?? this.controlUnit,
      technicalId: technicalId ?? this.technicalId,
    );
  }
}
