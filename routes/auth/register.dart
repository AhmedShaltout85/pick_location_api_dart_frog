// // ignore_for_file: directives_ordering

// import 'dart:io';
// import 'package:dart_frog/dart_frog.dart';
// import 'package:pick_location_api/repositories/user_repository.dart';
// import 'package:pick_location_api/models/user.dart';

// Future<Response> onRequest(RequestContext context) async {
//   if (context.request.method != HttpMethod.post) {
//     return Response.json(
//       statusCode: HttpStatus.methodNotAllowed,
//       body: {'error': 'Method not allowed'},
//     );
//   }

//   try {
//     final body = await context.request.json() as Map<String, dynamic>;

//     final user = User(
//       userName: body['username'] as String?,
//       userPassword: body['password'] as String?,
//       role: body['role'] as int?,
//       controlUnit: body['control_unit'] as String?,
//       technicalId: body['technical_id'] as int?,
//     );

//     if (user.userName == null || user.userPassword == null) {
//       return Response.json(
//         statusCode: HttpStatus.badRequest,
//         body: {'error': 'Username and password are required'},
//       );
//     }

//     final userRepo = UserRepository();

//     final existingUser = await userRepo.findByUsername(user.userName!);
//     if (existingUser != null) {
//       return Response.json(
//         statusCode: HttpStatus.conflict,
//         body: {'error': 'Username already exists'},
//       );
//     }

//     final createdUser = await userRepo.create(user);

//     return Response.json(
//       statusCode: HttpStatus.created,
//       body: {
//         'message': 'User created successfully',
//         'user': createdUser.toJson(),
//       },
//     );
//   } catch (e) {
//     return Response.json(
//       statusCode: HttpStatus.internalServerError,
//       body: {'error': 'Server error: $e'},
//     );
//   }
// }
import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:pick_location_api/models/user.dart';
import 'package:pick_location_api/repositories/user_repository.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.post) {
    return Response.json(
      statusCode: HttpStatus.methodNotAllowed,
      body: {'error': 'Method not allowed'},
    );
  }

  try {
    final body = await context.request.json() as Map<String, dynamic>;

    final user = User(
      userName: body['username'] as String?,
      userPassword: body['password'] as String?,
      role: body['role'] as int?,
      controlUnit: body['control_unit'] as String?,
      technicalId: body['technical_id'] as int?,
    );

    if (user.userName == null || user.userPassword == null) {
      return Response.json(
        statusCode: HttpStatus.badRequest,
        body: {'error': 'Username and password are required'},
      );
    }

    final userRepo = UserRepository();

    final existingUser = await userRepo.findByUsername(user.userName!);
    if (existingUser != null) {
      return Response.json(
        statusCode: HttpStatus.conflict,
        body: {'error': 'Username already exists'},
      );
    }

    final createdUser = await userRepo.create(user);

    return Response.json(
      statusCode: HttpStatus.created,
      body: {
        'message': 'User created successfully',
        'user': createdUser.toJson(),
      },
    );
  } catch (e) {
    return Response.json(
      statusCode: HttpStatus.internalServerError,
      body: {'error': 'Server error: $e'},
    );
  }
}
