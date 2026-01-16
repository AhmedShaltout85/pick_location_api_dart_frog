import 'dart:developer';

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

    final user = User.fromJson(result.first);
    log(
      'DEBUG: User loaded - id: ${user.id}, name: ${user.userName}, role: ${user.role}',
    );

    return user;
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
// import 'package:dart_odbc/dart_odbc.dart';
// import 'package:pick_location_api/config/database.dart';
// import 'package:pick_location_api/models/user.dart';
// import 'package:pick_location_api/utils/password_helper.dart';

// class UserRepository {
  
//   Future<User?> findByUsername(String username) async {
//     log('DEBUG findByUsername: Looking for user: $username');
    
//     try {
//       // Get connection - adjust if your DatabaseConfig.getConnection() needs await
//       final conn = DatabaseConfig.getConnection();
      
//       // Execute query
//       final result = conn.execute(
//         'SELECT * FROM pick_location_users WHERE user_name = ?',
//         params: [username],
//       );
      
//       // Check if result is empty
//       if (result.isEmpty) {
//         log('DEBUG: No user found with username: $username');
//         return null;
//       }
      
//       // Get the first row
//       final row = result.first;
//       log('DEBUG: Raw row type: ${row.runtimeType}');
//       log('DEBUG: Raw row: $row');
      
//       // Convert to Map<String, dynamic>
//       Map<String, dynamic> rowMap = {};
      
//       // Check if row is already a Map
//       if (row is Map) {
//         // Convert Map<dynamic, dynamic> to Map<String, dynamic>
//         for (final key in row.keys) {
//           final stringKey = key.toString();
//           rowMap[stringKey] = row[key];
//         }
//       } else {
//         // Handle other types (like List or custom objects)
//         log('WARNING: Row is not a Map, type: ${row.runtimeType}');
//         // Try to convert based on your database driver
//         rowMap = _convertRowToMap(row);
//       }
      
//       log('DEBUG: Converted rowMap: $rowMap');
      
//       // Create User from JSON
//       final user = User.fromJson(rowMap);
      
//       log('DEBUG: Successfully created user: ${user.userName}');
      
//       return user;
      
//     } catch (e, stackTrace) {
//       log('ERROR in findByUsername for $username: $e');
//       log('Stack trace: $stackTrace');
//       return null;
//     }
//   }
  
//   // Helper method to convert unknown row types to Map
//   Map<String, dynamic> _convertRowToMap(dynamic row) {
//     final map = <String, dynamic>{};
    
//     if (row is List) {
//       // Handle list of values
//       log('WARNING: Row is a List, manual conversion needed');
//       // You might need to map column names to values
//       // This depends on your database driver
//       return map;
//     }
    
//     // Try to use reflection or toString parsing
//     final rowString = row.toString();
//     log('DEBUG: Row as string: $rowString');
    
//     return map;
//   }
  
//   Future<User?> findById(int id) async {
//     try {
//       final conn = DatabaseConfig.getConnection();
      
//       final result = conn.execute(
//         'SELECT * FROM pick_location_users WHERE id = ?',
//         params: [id],
//       );

//       if (result.isEmpty) return null;
      
//       // Convert row to Map
//       final row = result.first;
//       Map<String, dynamic> rowMap = {};
      
//       if (row is Map) {
//         for (final key in row.keys) {
//           final stringKey = key.toString();
//           rowMap[stringKey] = row[key];
//         }
//       } else {
//         rowMap = _convertRowToMap(row);
//       }
      
//       return User.fromJson(rowMap);
//     } catch (e) {
//       log('ERROR in findById: $e');
//       return null;
//     }
//   }

//   Future<List<User>> findAll() async {
//     try {
//       final conn = DatabaseConfig.getConnection();
      
//       final result = conn.execute('SELECT * FROM pick_location_users');

//       final users = <User>[];
      
//       for (final row in result) {
//         Map<String, dynamic> rowMap = {};
        
//         if (row is Map) {
//           for (final key in row.keys) {
//             final stringKey = key.toString();
//             rowMap[stringKey] = row[key];
//           }
//         } else {
//           rowMap = _convertRowToMap(row);
//         }
        
//         try {
//           final user = User.fromJson(rowMap);
//           users.add(user);
//         } catch (e) {
//           log('Error converting row to User: $e');
//         }
//       }
      
//       return users;
//     } catch (e) {
//       log('ERROR in findAll: $e');
//       return [];
//     }
//   }

//   Future<User?> authenticate(String username, String password) async {
//     log('DEBUG authenticate: Starting authentication for $username');
    
//     try {
//       // Find user by username
//       final user = await findByUsername(username);
      
//       if (user == null) {
//         log('DEBUG: User $username not found');
//         return null;
//       }
      
//       log('DEBUG: Found user: ${user.toJson()}');
      
//       // Check if user has a password
//       if (user.userPassword == null || user.userPassword!.isEmpty) {
//         log('DEBUG: User has no password set');
//         return null;
//       }
      
//       // Verify the password
//       final storedHash = user.userPassword!;
//       log('DEBUG: Stored hash length: ${storedHash.length}');
//       log('DEBUG: Stored hash preview: ${storedHash.substring(0, storedHash.length > 20 ? 20 : storedHash.length)}...');
      
//       final isPasswordValid = PasswordHelper.verifyPassword(password, storedHash);
      
//       if (!isPasswordValid) {
//         log('DEBUG: Password verification failed');
//         return null;
//       }
      
//       log('DEBUG: Authentication successful for $username');
//       return user;
      
//     } catch (e, stackTrace) {
//       log('ERROR in authenticate: $e');
//       log('Stack trace: $stackTrace');
//       return null;
//     }
//   }

//   Future<User> create(User user) async {
//     try {
//       final conn = DatabaseConfig.getConnection();
      
//       // Hash the password if provided
//       final hashedPassword = user.userPassword != null
//           ? PasswordHelper.hashPassword(user.userPassword!)
//           : null;

//       // Execute insert
//       conn.execute(
//         '''
//         INSERT INTO pick_location_users 
//         (user_name, user_password, role, control_unit, technical_id)
//         VALUES (?, ?, ?, ?, ?)
//         ''',
//         params: [
//           user.userName,
//           hashedPassword,
//           user.role,
//           user.controlUnit,
//           user.technicalId,
//         ],
//       );

//       // Get the last inserted ID
//       final idResult = conn.execute('SELECT SCOPE_IDENTITY() AS id');

//       int? insertedId;
//       if (idResult.isNotEmpty) {
//         final idRow = idResult.first;
//         final idValue = idRow is Map ? idRow['id'] : null;
        
//         if (idValue != null) {
//           if (idValue is int) {
//             insertedId = idValue;
//           } else if (idValue is double) {
//             insertedId = idValue.toInt();
//           } else {
//             insertedId = int.tryParse(idValue.toString());
//           }
//         }
//       }

//       // Return user with ID
//       return user.copyWith(id: insertedId, userPassword: hashedPassword);
      
//     } catch (e) {
//       log('ERROR in create: $e');
//       rethrow;
//     }
//   }

//   Future<bool> update(int id, User user) async {
//     try {
//       final conn = DatabaseConfig.getConnection();
      
//       final params = <dynamic>[
//         user.userName,
//         user.role,
//         user.controlUnit,
//         user.technicalId,
//       ];

//       var sql = '''
//         UPDATE pick_location_users 
//         SET user_name = ?, 
//             role = ?, 
//             control_unit = ?, 
//             technical_id = ?
//       ''';

//       // Add password if updating
//       if (user.userPassword != null && user.userPassword!.isNotEmpty) {
//         final hashedPassword = PasswordHelper.hashPassword(user.userPassword!);
//         params.add(hashedPassword);
//         sql += ', user_password = ?';
//       }

//       params.add(id);
//       sql += ' WHERE id = ?';

//       conn.execute(sql, params: params);
//       return true;
      
//     } catch (e) {
//       log('ERROR in update: $e');
//       return false;
//     }
//   }

//   Future<bool> delete(int id) async {
//     try {
//       final conn = DatabaseConfig.getConnection();
      
//       conn.execute(
//         'DELETE FROM pick_location_users WHERE id = ?',
//         params: [id],
//       );

//       return true;
//     } catch (e) {
//       log('ERROR in delete: $e');
//       return false;
//     }
//   }
  
//   // Debug method to check database state
//   Future<void> debugDatabase() async {
//     try {
//       final conn = DatabaseConfig.getConnection();
      
//       // Get table schema
//       final schemaResult = conn.execute('''
//         SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE, CHARACTER_MAXIMUM_LENGTH
//         FROM INFORMATION_SCHEMA.COLUMNS
//         WHERE TABLE_NAME = 'pick_location_users'
//         ORDER BY ORDINAL_POSITION
//       ''');
      
//       log('\n=== DATABASE DEBUG INFO ===');
//       log('Table Schema:');
//       for (final row in schemaResult) {
//         log('  ${row['COLUMN_NAME']}: ${row['DATA_TYPE']} (Nullable: ${row['IS_NULLABLE']}, MaxLen: ${row['CHARACTER_MAXIMUM_LENGTH']})');
//       }
      
//       // Get sample data
//       final dataResult = conn.execute('''
//         SELECT TOP 5 id, user_name, role, control_unit, technical_id, 
//                LEN(user_password) as pwd_length
//         FROM pick_location_users
//       ''');
      
//       log('\nSample Data (first 5 rows):');
//       for (final row in dataResult) {
//         log('  ID: ${row['id']}, Name: ${row['user_name']}, Role: ${row['role']}, PwdLen: ${row['pwd_length']}');
//       }
//       log('=== END DEBUG INFO ===\n');
      
//     } catch (e) {
//       log('ERROR in debugDatabase: $e');
//     }
//   }
// }