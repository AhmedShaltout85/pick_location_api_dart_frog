// import 'dart:io';
// import 'package:dart_frog/dart_frog.dart';
// import 'package:pick_location_api/config/jwt.dart';
// import 'package:pick_location_api/repositories/user_repository.dart';

// Future<Response> onRequest(RequestContext context) async {
//   if (context.request.method != HttpMethod.post) {
//     return Response.json(
//       statusCode: HttpStatus.methodNotAllowed,
//       body: {'error': 'Method not allowed'},
//     );
//   }

//   try {
//     final body = await context.request.json() as Map<String, dynamic>;
//     final username = body['username'] as String?;
//     final password = body['password'] as String?;

//     if (username == null || password == null) {
//       return Response.json(
//         statusCode: HttpStatus.badRequest,
//         body: {'error': 'Username and password are required'},
//       );
//     }

//     final userRepo = UserRepository();
//     final user = await userRepo.authenticate(username, password);

//     if (user == null) {
//       return Response.json(
//         statusCode: HttpStatus.unauthorized,
//         body: {'error': 'Invalid credentials'},
//       );
//     }

//     final token = JWTConfig.generateToken({
//       'userId': user.id,
//       'username': user.userName,
//       'role': user.role,
//     });

//     return Response.json(
//       body: {
//         'token': token,
//         'user': user.toJson(),
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
import 'package:pick_location_api/config/jwt.dart';
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
    final username = body['username'] as String?;
    final password = body['password'] as String?;

    if (username == null || password == null) {
      return Response.json(
        statusCode: HttpStatus.badRequest,
        body: {'error': 'Username and password are required'},
      );
    }

    final userRepo = UserRepository();
    final user = await userRepo.authenticate(username, password);

    if (user == null) {
      return Response.json(
        statusCode: HttpStatus.unauthorized,
        body: {'error': 'Invalid credentials'},
      );
    }

    print('Step A: Creating JWT payload');
    final payload = <String, dynamic>{
      'userId': user.id,
      'username': user.userName,
      'role': user.role,
    };
    print('Step B: Payload = $payload');

    print('Step C: Generating token');
    final token = JWTConfig.generateToken(payload);
    print('Step D: Token generated');

    print('Step E: Creating user response');
    final userResponse = <String, dynamic>{
      'id': user.id,
      'user_name': user.userName,
      'role': user.role,
      'control_unit': user.controlUnit,
      'technical_id': user.technicalId,
    };
    print('Step F: User response = $userResponse');

    print('Step G: Creating final response');
    return Response.json(
      body: {
        'token': token,
        'user': userResponse,
      },
    );
  } catch (e, stackTrace) {
    print('ERROR: $e');
    print('Stack: $stackTrace');
    return Response.json(
      statusCode: HttpStatus.internalServerError,
      body: {'error': 'Server error: $e'},
    );
  }
}
