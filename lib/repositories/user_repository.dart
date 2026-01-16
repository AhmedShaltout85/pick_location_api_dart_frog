// ignore_for_file: public_member_api_docs, cascade_invocations

import 'package:pick_location_api/config/database.dart';
import 'package:pick_location_api/models/user.dart';
import 'package:pick_location_api/utils/password_helper.dart';

class UserRepository {
  Future<User?> findByUsername(String username) async {
    final conn = DatabaseConfig.getConnection();

    final result = conn.execute(
      'SELECT * FROM pick_location_users WHERE user_name = ?',
      params: [username],
    );

    if (result.isEmpty) return null;
    return User.fromJson(result.first);
  }

  Future<User?> findById(int id) async {
    final conn = DatabaseConfig.getConnection();

    final result = conn.execute(
      'SELECT * FROM pick_location_users WHERE id = ?',
      params: [id],
    );

    if (result.isEmpty) return null;
    return User.fromJson(result.first);
  }

  Future<List<User>> findAll() async {
    final conn = DatabaseConfig.getConnection();

    final result = conn.execute('SELECT * FROM pick_location_users');

    return result.map(User.fromJson).toList();
  }

  Future<User?> authenticate(String username, String password) async {
    final user = await findByUsername(username);

    if (user == null || user.userPassword == null) return null;

    if (!PasswordHelper.verifyPassword(password, user.userPassword!)) {
      return null;
    }

    return user;
  }

  Future<User> create(User user) async {
    final conn = DatabaseConfig.getConnection();

    final hashedPassword = user.userPassword != null
        ? PasswordHelper.hashPassword(user.userPassword!)
        : null;

    conn.execute(
      '''
      INSERT INTO pick_location_users 
      (user_name, user_password, role, control_unit, technical_id)
      VALUES (?, ?, ?, ?, ?)
      ''',
      params: [
        user.userName,
        hashedPassword,
        user.role,
        user.controlUnit,
        user.technicalId,
      ],
    );

    // Get the last inserted ID using SCOPE_IDENTITY()
    final idResult = conn.execute('SELECT SCOPE_IDENTITY() AS id');

    if (idResult.isEmpty || idResult.first['id'] == null) {
      // If we can't get the ID, just return the user without it
      return user.copyWith(userPassword: hashedPassword);
    }

    final idValue = idResult.first['id'];
    int insertedId;

    if (idValue is int) {
      insertedId = idValue;
    } else if (idValue is double) {
      insertedId = idValue.toInt();
    } else {
      insertedId = int.parse(idValue.toString());
    }

    return user.copyWith(id: insertedId, userPassword: hashedPassword);
  }

  Future<bool> update(int id, User user) async {
    final conn = DatabaseConfig.getConnection();

    final params = <dynamic>[
      user.userName,
      user.role,
      user.controlUnit,
      user.technicalId,
    ];

    var sql = '''
      UPDATE pick_location_users 
      SET user_name = ?, 
          role = ?, 
          control_unit = ?, 
          technical_id = ?
    ''';

    if (user.userPassword != null) {
      final hashedPassword = PasswordHelper.hashPassword(user.userPassword!);
      params.add(hashedPassword);
      sql += ', user_password = ?';
    }

    params.add(id);
    sql += ' WHERE id = ?';

    conn.execute(sql, params: params);
    return true;
  }

  Future<bool> delete(int id) async {
    final conn = DatabaseConfig.getConnection();

    conn.execute(
      'DELETE FROM pick_location_users WHERE id = ?',
      params: [id],
    );

    return true;
  }
}
