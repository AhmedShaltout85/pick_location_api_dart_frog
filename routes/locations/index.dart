// ignore_for_file: no_default_cases

import 'dart:developer';
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

    // Helper function to safely parse nullable values
    String? parseString(dynamic value) {
      if (value == null) return null;
      return value.toString();
    }

    int? parseInt(dynamic value) {
      if (value == null) return null;
      if (value is int) return value;
      if (value is String) return int.tryParse(value);
      return int.tryParse(value.toString());
    }

    final location = Location(
      address: body['address']?.toString() ??
          body['Address']?.toString() ??
          '', // Check both snake_case and PascalCase
      latitude: parseString(body['latitude'] ?? body['Latitude']),
      longitude: parseString(
        body['longitude'] ?? body['Longitude'] ?? body['Longitude'],
      ), // Handle typo in request
      date: body['date'] != null
          ? DateTime.parse(body['date'] as String)
          : body['Date'] != null
              ? DateTime.parse(body['Date'] as String)
              : DateTime.now(),
      flag: parseInt(body['flag'] ?? body['Flag']),
      gisUrl: parseString(body['gis_url'] ?? body['Gis_Url']),
      handasahName: parseString(body['handasah_name'] ?? body['Handasah_Name']),
      technicalName:
          parseString(body['technical_name'] ?? body['Technical_Name']),
      isFinished: parseInt(body['is_finished'] ?? body['Is_Finished']) ?? 0,
      isApproved: parseInt(body['is_approved'] ?? body['Is_Approved']) ?? 0,
      callerName: parseString(body['caller_name'] ?? body['Caller_Name']),
      brokenType: parseString(body['broken_type'] ?? body['Broken_Type']),
      callerNumber: parseString(body['caller_number'] ?? body['Caller_Number']),
      videoCall: parseInt(body['video_call'] ?? body['Video_Call']),
    );

    // Validate required fields
    if (location.address.isEmpty) {
      return Response.json(
        statusCode: HttpStatus.badRequest,
        body: {'error': 'Address is required'},
      );
    }

    final createdLocation = await repo.create(location);

    return Response.json(
      statusCode: HttpStatus.created,
      body: {
        'message': 'Location created successfully',
        'location': createdLocation.toJson(),
      },
    );
  } on FormatException catch (e) {
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: {'error': 'Invalid JSON format: $e'},
    );
  } catch (e) {
    log('Error creating location: $e'); // Log the error for debugging
    return Response.json(
      statusCode: HttpStatus.internalServerError,
      body: {'error': 'Server error: $e'},
    );
  }
}
