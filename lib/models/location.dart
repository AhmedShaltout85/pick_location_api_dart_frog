// // ignore_for_file: public_member_api_docs, sort_constructors_first, always_put_required_named_parameters_first

// class Location {
//   final int? id;
//   final String address;
//   final String? latitude;
//   final String? longitude;
//   final DateTime date;
//   final int? flag;
//   final String? gisUrl;
//   final String? handasahName;
//   final String? technicalName;
//   final int isFinished;
//   final int isApproved;
//   final String? callerName;
//   final String? brokenType;
//   final String? callerNumber;
//   final int? videoCall;

//   Location({
//     this.id,
//     required this.address,
//     this.latitude,
//     this.longitude,
//     required this.date,
//     this.flag,
//     this.gisUrl,
//     this.handasahName,
//     this.technicalName,
//     this.isFinished = 0,
//     this.isApproved = 0,
//     this.callerName,
//     this.brokenType,
//     this.callerNumber,
//     this.videoCall,
//   });

//   factory Location.fromJson(Map<String, dynamic> json) {
//     return Location(
//       id: json['ID'] as int?,
//       address: json['Address'] as String,
//       latitude: json['Latitude'] as String?,
//       longitude: json['Longtiude'] as String?,
//       date: json['Date'] is String
//           ? DateTime.parse(json['Date'] as String)
//           : json['Date'] as DateTime,
//       flag: json['Flag'] as int?,
//       gisUrl: json['Gis_Url'] as String?,
//       handasahName: json['Handasah_Name'] as String?,
//       technicalName: json['Technical_Name'] as String?,
//       isFinished: json['Is_Finished'] as int? ?? 0,
//       isApproved: json['Is_Approved'] as int? ?? 0,
//       callerName: json['Caller_Name'] as String?,
//       brokenType: json['Broken_Type'] as String?,
//       callerNumber: json['Caller_Number'] as String?,
//       videoCall: json['Video_Call'] as int?,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'ID': id,
//       'Address': address,
//       'Latitude': latitude,
//       'Longtiude': longitude,
//       'Date': date.toIso8601String(),
//       'Flag': flag,
//       'Gis_Url': gisUrl,
//       'Handasah_Name': handasahName,
//       'Technical_Name': technicalName,
//       'Is_Finished': isFinished,
//       'Is_Approved': isApproved,
//       'Caller_Name': callerName,
//       'Broken_Type': brokenType,
//       'Caller_Number': callerNumber,
//       'Video_Call': videoCall,
//     };
//   }
// }
class Location {
  Location({
    required this.address,
    required this.date,
    this.id,
    this.latitude,
    this.longitude,
    this.flag,
    this.gisUrl,
    this.handasahName,
    this.technicalName,
    this.isFinished = 0,
    this.isApproved = 0,
    this.callerName,
    this.brokenType,
    this.callerNumber,
    this.videoCall,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: _parseIntSafe(json['ID']),
      address: json['Address'] as String,
      latitude: json['Latitude'] as String?,
      longitude: json['Longtiude'] as String?,
      date: _parseDateSafe(json['Date']),
      flag: _parseIntSafe(json['Flag']),
      gisUrl: json['Gis_Url'] as String?,
      handasahName: json['Handasah_Name'] as String?,
      technicalName: json['Technical_Name'] as String?,
      isFinished: _parseIntSafe(json['Is_Finished']) ?? 0,
      isApproved: _parseIntSafe(json['Is_Approved']) ?? 0,
      callerName: json['Caller_Name'] as String?,
      brokenType: json['Broken_Type'] as String?,
      callerNumber: json['Caller_Number'] as String?,
      videoCall: _parseIntSafe(json['Video_Call']),
    );
  }
  final int? id;
  final String address;
  final String? latitude;
  final String? longitude;
  final DateTime date;
  final int? flag;
  final String? gisUrl;
  final String? handasahName;
  final String? technicalName;
  final int isFinished;
  final int isApproved;
  final String? callerName;
  final String? brokenType;
  final String? callerNumber;
  final int? videoCall;

  static int? _parseIntSafe(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return int.tryParse(value.toString());
  }

  static DateTime _parseDateSafe(dynamic value) {
    if (value == null) return DateTime.now();
    if (value is DateTime) return value;
    if (value is String) return DateTime.parse(value);
    return DateTime.now();
  }

  Map<String, dynamic> toJson() {
    return {
      'ID': id,
      'Address': address,
      'Latitude': latitude,
      'Longtiude': longitude,
      'Date': date.toIso8601String(),
      'Flag': flag,
      'Gis_Url': gisUrl,
      'Handasah_Name': handasahName,
      'Technical_Name': technicalName,
      'Is_Finished': isFinished,
      'Is_Approved': isApproved,
      'Caller_Name': callerName,
      'Broken_Type': brokenType,
      'Caller_Number': callerNumber,
      'Video_Call': videoCall,
    };
  }
}
