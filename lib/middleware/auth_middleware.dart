// ignore_for_file: public_member_api_docs

import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:pick_location_api/config/jwt.dart';

Middleware authMiddleware() {
  return (handler) {
    return (context) async {
      final request = context.request;
      final authHeader = request.headers[HttpHeaders.authorizationHeader];

      if (authHeader == null || !authHeader.startsWith('Bearer ')) {
        return Response.json(
          statusCode: HttpStatus.unauthorized,
          body: {'error': 'Missing or invalid authorization header'},
        );
      }

      final token = authHeader.substring(7);
      final payload = JWTConfig.verifyToken(token);

      if (payload == null) {
        return Response.json(
          statusCode: HttpStatus.unauthorized,
          body: {'error': 'Invalid or expired token'},
        );
      }

      final updatedContext =
          context.provide<Map<String, dynamic>>(() => payload);
      return handler(updatedContext);
    };
  };
}
