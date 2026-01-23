// ignore_for_file: public_member_api_docs, cascade_invocations

import 'package:dart_odbc/dart_odbc.dart';
import 'package:pick_location_api/config/database.dart';
import 'package:pick_location_api/models/location.dart';

class LocationRepository {
  /// Clean ODBC row data by removing NULL bytes from keys and string values
  /// This fixes a bug in dart_odbc where fixed-width buffers aren't properly
  Map<String, dynamic> _cleanOdbcRow(Map<String, dynamic> row) {
    final cleanRow = <String, dynamic>{};

    for (final entry in row.entries) {
      final cleanKey = entry.key.replaceAll('\u0000', '');
      final value = entry.value;
      final cleanValue =
          value is String ? value.replaceAll('\u0000', '') : value;

      cleanRow[cleanKey] = cleanValue;
    }

    return cleanRow;
  }

  /// Clean and map multiple ODBC rows to Location objects
  List<Location> _mapToLocations(List<Map<String, dynamic>> rows) {
    return rows.map(_cleanOdbcRow).map(Location.fromJson).toList();
  }

  Future<List<Location>> findAll() async {
    final conn = DatabaseConfig.getConnection();
    final result = conn.execute('SELECT * FROM Locations');
    return _mapToLocations(result);
  }

  Future<Location?> findById(int id) async {
    final conn = DatabaseConfig.getConnection();

    final result = conn.execute(
      'SELECT * FROM Locations WHERE ID = ?',
      params: [id],
    );

    if (result.isEmpty) return null;

    return Location.fromJson(_cleanOdbcRow(result.first));
  }

  Future<List<Location>> findByHandasah(String handasahName) async {
    final conn = DatabaseConfig.getConnection();

    final result = conn.execute(
      'SELECT * FROM Locations WHERE Handasah_Name = ?',
      params: [handasahName],
    );

    return _mapToLocations(result);
  }

  Future<List<Location>> findPending() async {
    final conn = DatabaseConfig.getConnection();

    final result = conn.execute(
      'SELECT * FROM Locations WHERE Is_Finished = 0',
    );

    return _mapToLocations(result);
  }

  Future<Location> create(Location location) async {
    final conn = DatabaseConfig.getConnection();

    // Convert DateTime to SQL Server compatible format (YYYY-MM-DD)
    final dateStr = location.date.toIso8601String().split('T')[0];

    conn.execute(
      '''
      INSERT INTO Locations 
      (Address, Latitude, Longitude, Date, Flag, Gis_Url, Handasah_Name, 
       Technical_Name, Is_Finished, Is_Approved, Caller_Name, Broken_Type, 
       Caller_Number, Video_Call)
      VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
      ''',
      params: [
        location.address,
        location.latitude,
        location.longitude,
        dateStr,
        location.flag,
        location.gisUrl,
        location.handasahName,
        location.technicalName,
        location.isFinished,
        location.isApproved,
        location.callerName,
        location.brokenType,
        location.callerNumber,
        location.videoCall,
      ],
    );

    // Get the last inserted ID
    final insertedId = await _getLastInsertedId(conn);

    return location.copyWith(id: insertedId);
  }

  /// Retrieve the last inserted ID from SQL Server
  Future<int?> _getLastInsertedId(DartOdbc conn) async {
    final idResult = conn.execute('SELECT SCOPE_IDENTITY() AS ID');

    if (idResult.isEmpty) return null;

    final cleanRow = _cleanOdbcRow(idResult.first);
    final idValue = cleanRow['ID'];

    if (idValue == null) return null;

    if (idValue is int) return idValue;
    if (idValue is double) return idValue.toInt();

    return int.tryParse(idValue.toString());
  }

  Future<bool> update(int id, Location location) async {
    final conn = DatabaseConfig.getConnection();

    conn.execute(
      '''
      UPDATE Locations 
      SET Address = ?, 
          Latitude = ?, 
          Longitude = ?,
          Flag = ?,
          Gis_Url = ?,
          Handasah_Name = ?,
          Technical_Name = ?,
          Is_Finished = ?,
          Is_Approved = ?,
          Caller_Name = ?,
          Broken_Type = ?,
          Caller_Number = ?,
          Video_Call = ?
      WHERE ID = ?
      ''',
      params: [
        location.address,
        location.latitude,
        location.longitude,
        location.flag,
        location.gisUrl,
        location.handasahName,
        location.technicalName,
        location.isFinished,
        location.isApproved,
        location.callerName,
        location.brokenType,
        location.callerNumber,
        location.videoCall,
        id,
      ],
    );

    return true;
  }

  Future<bool> delete(int id) async {
    final conn = DatabaseConfig.getConnection();

    conn.execute(
      'DELETE FROM Locations WHERE ID = ?',
      params: [id],
    );

    return true;
  }
}
