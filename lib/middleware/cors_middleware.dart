import 'package:dart_frog/dart_frog.dart';

/// Middleware that adds CORS headers to the response.
Handler activeCorsMiddleware(Handler handler) {
  return handler.use(corsMiddleware());
}

/// Middleware that adds CORS headers to the response.
Middleware corsMiddleware() {
  return (handler) {
    return (context) async {
      final request = context.request;

      // Handle preflight requests
      if (request.method == HttpMethod.options) {
        return Response(
          statusCode: 204,
          headers: _corsHeaders(),
        );
      }

      // Process the request
      final response = await handler(context);

      // Add CORS headers to the response
      return response.copyWith(
        headers: {
          ...response.headers,
          ..._corsHeaders(),
        },
      );
    };
  };
}

Map<String, String> _corsHeaders() {
  return {
    'Access-Control-Allow-Origin': '*', // Or specify your frontend domain
    'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, PATCH, OPTIONS',
    'Access-Control-Allow-Headers':
        'Content-Type, Authorization, X-Requested-With',
    'Access-Control-Max-Age': '86400', // 24 hours
  };
}

// import 'package:dart_frog/dart_frog.dart';

// /// Middleware that adds CORS headers to the response.
// Handler middleware(Handler handler) {
//   return handler.use(requestLogger()).use(
//         (handler) => (context) async {
//           final response = await handler(context);
//           return response.copyWith(
//             headers: {
//               'Access-Control-Allow-Origin': '*',
//               'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS'
//               'Access-Control-Allow-Headers': 'Content-Type',
//             },
//           );
//         },
//       );
// }
