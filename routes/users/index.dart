import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:pick_location_api/repositories/user_repository.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.get) {
    return Response.json(
      statusCode: HttpStatus.methodNotAllowed,
      body: {'error': 'Method not allowed'},
    );
  }

  try {
    final userRepo = UserRepository();
    final users = await userRepo.findAll();

    return Response.json(
      body: {
        'users': users.map((u) => u.toJson()).toList(),
      },
    );
  } catch (e) {
    return Response.json(
      statusCode: HttpStatus.internalServerError,
      body: {'error': 'Server error: $e.'},
    );
  }
}
