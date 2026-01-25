import 'package:dart_frog/dart_frog.dart';
import 'package:pick_location_api/middleware/auth_middleware.dart';
import 'package:pick_location_api/middleware/cors_middleware.dart';

Handler middleware(Handler handler) {
  return handler
      .use(authMiddleware())
      .use(activeCorsMiddleware)
      .use(requestLogger());
}
