// // ignore_for_file: no_default_cases

// import 'dart:io';
// import 'package:dart_frog/dart_frog.dart';
// import 'package:pick_location_api/models/location.dart';
// import 'package:pick_location_api/repositories/location_repository.dart';

// Future<Response> onRequest(RequestContext context, String id) async {
//   final locationId = int.tryParse(id);
//   if (locationId == null) {
//     return Response.json(
//       statusCode: HttpStatus.badRequest,
//       body: {'error': 'Invalid location ID'},
//     );
//   }

//   final locationRepo = LocationRepository();

//   switch (context.request.method) {
//     case HttpMethod.get:
//       return _getLocation(locationRepo, locationId);
//     case HttpMethod.put:
//       return _updateLocation(context, locationRepo, locationId);
//     case HttpMethod.delete:
//       return _deleteLocation(locationRepo, locationId);
//     default:
//       return Response.json(
//         statusCode: HttpStatus.methodNotAllowed,
//         body: {'error': 'Method not allowed'},
//       );
//   }
// }

// Future<Response> _getLocation(LocationRepository repo, int id) async {
//   try {
//     final location = await repo.findById(id);

//     if (location == null) {
//       return Response.json(
//         statusCode: HttpStatus.notFound,
//         body: {'error': 'Location not found'},
//       );
//     }

//     return Response.json(body: {'location': location.toJson()});
//   } catch (e) {
//     return Response.json(
//       statusCode: HttpStatus.internalServerError,
//       body: {'error': 'Server error: $e'},
//     );
//   }
// }

// Future<Response> _updateLocation(
//   RequestContext context,
//   LocationRepository repo,
//   int id,
// ) async {
//   try {
//     final body = await context.request.json() as Map<String, dynamic>;

//     final location = Location(
//       address: body['address'] as String,
//       latitude: body['latitude'] as String?,
//       longitude: body['longitude'] as String?,
//       date: body['date'] != null
//           ? DateTime.parse(body['date'] as String)
//           : DateTime.now(),
//       flag: body['flag'] as int?,
//       gisUrl: body['gis_url'] as String?,
//       handasahName: body['handasah_name'] as String?,
//       technicalName: body['technical_name'] as String?,
//       isFinished: body['is_finished'] as int? ?? 0,
//       isApproved: body['is_approved'] as int? ?? 0,
//       callerName: body['caller_name'] as String?,
//       brokenType: body['broken_type'] as String?,
//       callerNumber: body['caller_number'] as String?,
//       videoCall: body['video_call'] as int?,
//     );

//     await repo.update(id, location);

//     return Response.json(
//       body: {'message': 'Location updated successfully'},
//     );
//   } catch (e) {
//     return Response.json(
//       statusCode: HttpStatus.internalServerError,
//       body: {'error': 'Server error: $e'},
//     );
//   }
// }

// Future<Response> _deleteLocation(LocationRepository repo, int id) async {
//   try {
//     await repo.delete(id);

//     return Response.json(
//       body: {'message': 'Location deleted successfully'},
//     );
//   } catch (e) {
//     return Response.json(
//       statusCode: HttpStatus.internalServerError,
//       body: {'error': 'Server error: $e'},
//     );
//   }
// }
// ignore_for_file: no_default_cases

import 'dart:developer';
import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:pick_location_api/models/location.dart';
import 'package:pick_location_api/repositories/location_repository.dart';
import 'package:pick_location_api/services/redis_service.dart';

Future<Response> onRequest(RequestContext context, String id) async {
  final locationId = int.tryParse(id);
  if (locationId == null) {
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: {'error': 'Invalid location ID'},
    );
  }

  final locationRepo = LocationRepository();
  final redis = context.read<RedisService>();

  switch (context.request.method) {
    case HttpMethod.get:
      return _getLocation(locationRepo, redis, locationId);
    case HttpMethod.put:
      return _updateLocation(context, locationRepo, redis, locationId);
    case HttpMethod.delete:
      return _deleteLocation(locationRepo, redis, locationId);
    default:
      return Response.json(
        statusCode: HttpStatus.methodNotAllowed,
        body: {'error': 'Method not allowed'},
      );
  }
}

Future<Response> _getLocation(
  LocationRepository repo,
  RedisService redis,
  int id,
) async {
  try {
    final cacheKey = 'location:$id';

    // Try to get from cache
    final cachedData = await redis.getJson(cacheKey);
    if (cachedData != null) {
      return Response.json(body: {'location': cachedData});
    }

    // If not in cache, fetch from database
    final location = await repo.findById(id);

    if (location == null) {
      return Response.json(
        statusCode: HttpStatus.notFound,
        body: {'error': 'Location not found'},
      );
    }

    final locationJson = location.toJson();

    // Cache the result for 10 minutes
    await redis.setJson(cacheKey, locationJson, expirySeconds: 600);

    return Response.json(body: {'location': locationJson});
  } catch (e) {
    log('Error in _getLocation: $e');
    return Response.json(
      statusCode: HttpStatus.internalServerError,
      body: {'error': 'Server error: $e'},
    );
  }
}

Future<Response> _updateLocation(
  RequestContext context,
  LocationRepository repo,
  RedisService redis,
  int id,
) async {
  try {
    final body = await context.request.json() as Map<String, dynamic>;

    final location = Location(
      address: body['address'] as String,
      latitude: body['latitude'] as String?,
      longitude: body['longitude'] as String?,
      date: body['date'] != null
          ? DateTime.parse(body['date'] as String)
          : DateTime.now(),
      flag: body['flag'] as int?,
      gisUrl: body['gis_url'] as String?,
      handasahName: body['handasah_name'] as String?,
      technicalName: body['technical_name'] as String?,
      isFinished: body['is_finished'] as int? ?? 0,
      isApproved: body['is_approved'] as int? ?? 0,
      callerName: body['caller_name'] as String?,
      brokenType: body['broken_type'] as String?,
      callerNumber: body['caller_number'] as String?,
      videoCall: body['video_call'] as int?,
    );

    await repo.update(id, location);

    // Invalidate caches
    await _invalidateLocationCaches(redis, id, location.handasahName);

    return Response.json(
      body: {'message': 'Location updated successfully'},
    );
  } catch (e) {
    log('Error in _updateLocation: $e');
    return Response.json(
      statusCode: HttpStatus.internalServerError,
      body: {'error': 'Server error: $e'},
    );
  }
}

Future<Response> _deleteLocation(
  LocationRepository repo,
  RedisService redis,
  int id,
) async {
  try {
    // Get the location first to know which caches to invalidate
    final location = await repo.findById(id);

    await repo.delete(id);

    // Invalidate caches
    await _invalidateLocationCaches(
      redis,
      id,
      location?.handasahName,
    );

    return Response.json(
      body: {'message': 'Location deleted successfully'},
    );
  } catch (e) {
    log('Error in _deleteLocation: $e');
    return Response.json(
      statusCode: HttpStatus.internalServerError,
      body: {'error': 'Server error: $e'},
    );
  }
}

/// Invalidate location caches when data changes
Future<void> _invalidateLocationCaches(
  RedisService redis,
  int locationId,
  String? handasahName,
) async {
  try {
    // Clear specific location cache
    await redis.delete(['location:$locationId']);

    // Clear all locations cache
    await redis.delete(['locations:all']);

    // Clear pending locations cache
    await redis.delete(['locations:pending']);

    // Clear specific handasah cache if applicable
    if (handasahName != null) {
      await redis.delete(['locations:handasah:$handasahName']);
    }

    // Clear all handasah caches
    await redis.deletePattern('locations:handasah:*');
  } catch (e) {
    log('Error invalidating cache: $e');
    // Don't throw - cache invalidation failure shouldn't break the request
  }
}
