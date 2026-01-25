import 'package:dart_frog/dart_frog.dart';
import 'package:pick_location_api/middleware/cors_middleware.dart';
import 'package:pick_location_api/middleware/redis_middleware.dart';

Handler middleware(Handler handler) {
  return handler
      .use(requestLogger())
      .use(activeCorsMiddleware)
      .use(middlewareForRedis);
}
