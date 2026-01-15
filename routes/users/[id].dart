// ignore_for_file: no_default_cases

import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:pick_location_api/models/user.dart';
import 'package:pick_location_api/repositories/user_repository.dart';

Future<Response> onRequest(RequestContext context, String id) async {
  final userId = int.tryParse(id);
  if (userId == null) {
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: {'error': 'Invalid user ID'},
    );
  }

  final userRepo = UserRepository();

  switch (context.request.method) {
    case HttpMethod.get:
      return _getUser(userRepo, userId);
    case HttpMethod.put:
      return _updateUser(context, userRepo, userId);
    case HttpMethod.delete:
      return _deleteUser(userRepo, userId);
    default:
      return Response.json(
        statusCode: HttpStatus.methodNotAllowed,
        body: {'error': 'Method not allowed'},
      );
  }
}

Future<Response> _getUser(UserRepository repo, int id) async {
  try {
    final user = await repo.findById(id);

    if (user == null) {
      return Response.json(
        statusCode: HttpStatus.notFound,
        body: {'error': 'User not found'},
      );
    }

    return Response.json(body: {'user': user.toJson()});
  } catch (e) {
    return Response.json(
      statusCode: HttpStatus.internalServerError,
      body: {'error': 'Server error: $e'},
    );
  }
}

Future<Response> _updateUser(
  RequestContext context,
  UserRepository repo,
  int id,
) async {
  try {
    final body = await context.request.json() as Map<String, dynamic>;

    final user = User(
      userName: body['username'] as String?,
      userPassword: body['password'] as String?,
      role: body['role'] as int?,
      controlUnit: body['control_unit'] as String?,
      technicalId: body['technical_id'] as int?,
    );

    await repo.update(id, user);

    return Response.json(
      body: {'message': 'User updated successfully'},
    );
  } catch (e) {
    return Response.json(
      statusCode: HttpStatus.internalServerError,
      body: {'error': 'Server error: $e'},
    );
  }
}

Future<Response> _deleteUser(UserRepository repo, int id) async {
  try {
    await repo.delete(id);

    return Response.json(
      body: {'message': 'User deleted successfully'},
    );
  } catch (e) {
    return Response.json(
      statusCode: HttpStatus.internalServerError,
      body: {'error': 'Server error: $e'},
    );
  }
}
