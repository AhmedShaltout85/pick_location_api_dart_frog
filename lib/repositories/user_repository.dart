// ignore_for_file: await_only_futures

import 'dart:developer';

import 'package:pick_location_api/config/database.dart';
import 'package:pick_location_api/models/user.dart';
import 'package:pick_location_api/utils/password_helper.dart';

/// UserRepository
class UserRepository {
  /// findByUsername
  Future<User?> findByUsername(String username) async {
    final conn = await DatabaseConfig.getConnection();

    final result = await conn.execute(
      'SELECT * FROM pick_location_users WHERE user_name = ?',
      params: [username],
    );

    if (result.isEmpty) return null;
    return User.fromJson(result.first);
  }

  /// findById
  Future<User?> findById(int id) async {
    final conn = await DatabaseConfig.getConnection();

    final result = await conn.execute(
      'SELECT * FROM pick_location_users WHERE id = ?',
      params: [id],
    );

    if (result.isEmpty) return null;
    return User.fromJson(result.first);
  }

  /// findAll
  Future<List<User>> findAll() async {
    final conn = await DatabaseConfig.getConnection();

    final result = await conn.execute('SELECT * FROM pick_location_users');

    return result.map(User.fromJson).toList();
  }

  /// authenticate
  Future<User?> authenticate(String username, String password) async {
    final user = await findByUsername(username);

    if (user == null || user.userPassword == null) return null;

    if (!PasswordHelper.verifyPassword(password, user.userPassword!)) {
      return null;
    }

    return user;
  }

  /// create user
  Future<User> create(User user) async {
    final conn = await DatabaseConfig.getConnection();

    final hashedPassword = user.userPassword != null
        ? PasswordHelper.hashPassword(user.userPassword!)
        : '';

    await conn.execute(
      '''
      INSERT INTO pick_location_users 
      (user_name, user_password, role, control_unit, technical_id)
      VALUES (?, ?, ?, ?, ?)
      ''',
      params: [
        user.userName ?? '',
        hashedPassword,
        user.role ?? 0,
        user.controlUnit ?? '',
        user.technicalId ?? 0,
      ],
    );

    // Try to get the inserted ID
    try {
      final idResult = await conn.execute(
        'SELECT MAX(id) AS id FROM pick_location_users WHERE user_name = ?',
        params: [user.userName ?? ''],
      );

      if (idResult.isNotEmpty && idResult.first['id'] != null) {
        final idValue = idResult.first['id'];
        int? insertedId;

        if (idValue is int) {
          insertedId = idValue;
        } else if (idValue is double) {
          insertedId = idValue.toInt();
        } else if (idValue is String) {
          insertedId =
              int.tryParse(idValue.replaceAll(RegExp(r'\x00'), '').trim());
        }

        return user.copyWith(id: insertedId, userPassword: hashedPassword);
      }
    } catch (e) {
      // If getting ID fails, just return the user
      log('Could not get inserted ID: $e');
    }

    return user.copyWith(userPassword: hashedPassword);
  }

  /// update user
  Future<bool> update(int id, User user) async {
    final conn = await DatabaseConfig.getConnection();

    final params = <dynamic>[
      user.userName ?? '',
      user.role ?? 0,
      user.controlUnit ?? '',
      user.technicalId ?? 0,
    ];

    var sql = '''
      UPDATE pick_location_users 
      SET user_name = ?, 
          role = ?, 
          control_unit = ?, 
          technical_id = ?
    ''';

    if (user.userPassword != null && user.userPassword!.isNotEmpty) {
      final hashedPassword = PasswordHelper.hashPassword(user.userPassword!);
      params.add(hashedPassword);
      sql += ', user_password = ?';
    }

    params.add(id);
    sql += ' WHERE id = ?';

    await conn.execute(sql, params: params);
    return true;
  }

  /// delete user
  Future<bool> delete(int id) async {
    final conn = await DatabaseConfig.getConnection();

    await conn.execute(
      'DELETE FROM pick_location_users WHERE id = ?',
      params: [id],
    );

    return true;
  }
}
