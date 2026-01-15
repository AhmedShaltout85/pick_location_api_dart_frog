// ignore_for_file: public_member_api_docs, sort_constructors_first

class User {
  final int? id;
  final String? userName;
  final String? userPassword;
  final int? role;
  final String? controlUnit;
  final int? technicalId;

  User({
    this.id,
    this.userName,
    this.userPassword,
    this.role,
    this.controlUnit,
    this.technicalId,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int?,
      userName: json['user_name'] as String?,
      userPassword: json['user_password'] as String?,
      role: json['role'] as int?,
      controlUnit: json['control_unit'] as String?,
      technicalId: json['technical_id'] as int?,
    );
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
