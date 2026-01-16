import 'package:pick_location_api/config/database.dart';
import 'package:pick_location_api/models/location.dart';

class LocationRepository {
  Future<List<Location>> findAll() async {
    final conn = DatabaseConfig.getConnection();

    final result = conn.execute('SELECT * FROM Locations');
    return result.map(Location.fromJson).toList();
  }

  Future<Location?> findById(int id) async {
    final conn = DatabaseConfig.getConnection();

    final result = conn.execute(
      'SELECT * FROM Locations WHERE ID = ?',
      params: [id],
    );

    if (result.isEmpty) return null;
    return Location.fromJson(result.first);
  }

  Future<List<Location>> findByHandasah(String handasahName) async {
    final conn = DatabaseConfig.getConnection();

    final result = conn.execute(
      'SELECT * FROM Locations WHERE Handasah_Name = ?',
      params: [handasahName],
    );

    return result.map(Location.fromJson).toList();
  }

  Future<List<Location>> findPending() async {
    final conn = DatabaseConfig.getConnection();

    final result = conn.execute(
      'SELECT * FROM Locations WHERE Is_Finished = 0',
    );

    return result.map(Location.fromJson).toList();
  }

  Future<Location> create(Location location) async {
    final conn = DatabaseConfig.getConnection();

    conn.execute(
      '''
      INSERT INTO Locations 
      (Address, Latitude, Longtiude, Date, Flag, Gis_Url, Handasah_Name, 
       Technical_Name, Is_Finished, Is_Approved, Caller_Name, Broken_Type, 
       Caller_Number, Video_Call)
      VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
      ''',
      params: [
        location.address,
        location.latitude,
        location.longitude,
        location.date,
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

    // Get the last inserted ID using SCOPE_IDENTITY()
    final idResult = conn.execute('SELECT SCOPE_IDENTITY() AS ID');

    if (idResult.isEmpty || idResult.first['ID'] == null) {
      // If we can't get the ID, return location without it
      return location;
    }

    final idValue = idResult.first['ID'];
    int insertedId;

    if (idValue is int) {
      insertedId = idValue;
    } else if (idValue is double) {
      insertedId = idValue.toInt();
    } else {
      insertedId = int.parse(idValue.toString());
    }

    return Location(
      id: insertedId,
      address: location.address,
      latitude: location.latitude,
      longitude: location.longitude,
      date: location.date,
      flag: location.flag,
      gisUrl: location.gisUrl,
      handasahName: location.handasahName,
      technicalName: location.technicalName,
      isFinished: location.isFinished,
      isApproved: location.isApproved,
      callerName: location.callerName,
      brokenType: location.brokenType,
      callerNumber: location.callerNumber,
      videoCall: location.videoCall,
    );
  }

  Future<bool> update(int id, Location location) async {
    final conn = DatabaseConfig.getConnection();

    conn.execute(
      '''
      UPDATE Locations 
      SET Address = ?, 
          Latitude = ?, 
          Longtiude = ?,
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
