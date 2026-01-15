// ignore_for_file: no_default_cases

import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:pick_location_api/models/location.dart';
import 'package:pick_location_api/repositories/location_repository.dart';


Future<Response> onRequest(RequestContext context) async {
  final locationRepo = LocationRepository();

  switch (context.request.method) {
    case HttpMethod.get:
      return _getLocations(context, locationRepo);
    case HttpMethod.post:
      return _createLocation(context, locationRepo);
    default:
      return Response.json(
        statusCode: HttpStatus.methodNotAllowed,
        body: {'error': 'Method not allowed'},
      );
  }
}

Future<Response> _getLocations(
  RequestContext context,
  LocationRepository repo,
) async {
  try {
    final uri = context.request.uri;
    final handasahName = uri.queryParameters['handasah_name'];
    final pending = uri.queryParameters['pending'];

    List<Location> locations;

    if (pending == 'true') {
      locations = await repo.findPending();
    } else if (handasahName != null) {
      locations = await repo.findByHandasah(handasahName);
    } else {
      locations = await repo.findAll();
    }

    return Response.json(
      body: {
        'locations': locations.map((l) => l.toJson()).toList(),
      },
    );
  } catch (e) {
    return Response.json(
      statusCode: HttpStatus.internalServerError,
      body: {'error': 'Server error: $e'},
    );
  }
}

Future<Response> _createLocation(
  RequestContext context,
  LocationRepository repo,
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

    final createdLocation = await repo.create(location);

    return Response.json(
      statusCode: HttpStatus.created,
      body: {
        'message': 'Location created successfully',
        'location': createdLocation.toJson(),
      },
    );
  } catch (e) {
    return Response.json(
      statusCode: HttpStatus.internalServerError,
      body: {'error': 'Server error: $e'},
    );
  }
}
