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
    // Access values by iterating and using contains instead of ==
    dynamic id, userName, userPassword, role, controlUnit, technicalId;

    json.forEach((key, value) {
      final keyStr = key.trim().toLowerCase();

      if (keyStr.contains('id') && !keyStr.contains('_')) {
        id = value;
      } else if (keyStr.contains('user_name')) {
        userName = value;
      } else if (keyStr.contains('user_password')) {
        userPassword = value;
      } else if (keyStr.contains('role')) {
        role = value;
      } else if (keyStr.contains('control_unit')) {
        controlUnit = value;
      } else if (keyStr.contains('technical_id')) {
        technicalId = value;
      }
    });

    // Handle password with NVARCHAR padding
    String? trimmedPassword;
    if (userPassword != null) {
      final passwordStr = _parseStringSafe(userPassword) ?? '';
      // SHA-256 is always 64 chars, take first 64 to remove padding
      if (passwordStr.length >= 64) {
        trimmedPassword = passwordStr.substring(0, 64);
      } else {
        trimmedPassword = passwordStr;
      }
    }

    final user = User(
      id: _parseIntSafe(id),
      userName: _parseStringSafe(userName),
      userPassword: trimmedPassword,
      role: _parseIntSafe(role),
      controlUnit: _parseStringSafe(controlUnit),
      technicalId: _parseIntSafe(technicalId),
    );

    return user;
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
    if (value is String) {
      // Remove null padding before parsing
      final cleaned = value.replaceAll(RegExp(r'\x00'), '').trim();
      return int.tryParse(cleaned);
    }
    return int.tryParse(value.toString());
  }

  static String? _parseStringSafe(dynamic value) {
    if (value == null) return null;
    final strValue = value is String ? value : value.toString();
    // Remove null padding characters
    return strValue.replaceAll(RegExp(r'\x00'), '').trim();
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
