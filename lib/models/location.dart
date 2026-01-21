// ignore_for_file: public_member_api_docs, sort_constructors_first

class Location {
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

  // factory Location.fromJson(Map<String, dynamic> json) {
  //   return Location(
  //     id: _parseIntSafe(json['ID']),
  //     address:
  //         json['Address']?.toString() ?? '', // Handle null and provide default
  //     latitude: json['Latitude']?.toString(),
  //     longitude: json['Longitude']?.toString(),
  //     date: _parseDateSafe(json['Date']),
  //     flag: _parseIntSafe(json['Flag']),
  //     gisUrl: json['Gis_Url']?.toString(),
  //     handasahName: json['Handasah_Name']?.toString(),
  //     technicalName: json['Technical_Name']?.toString(),
  //     isFinished: _parseIntSafe(json['Is_Finished']) ?? 0,
  //     isApproved: _parseIntSafe(json['Is_Approved']) ?? 0,
  //     callerName: json['Caller_Name']?.toString(),
  //     brokenType: json['Broken_Type']?.toString(),
  //     callerNumber: json['Caller_Number']?.toString(),
  //     videoCall: _parseIntSafe(json['Video_Call']),
  //   );
  // }
  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      id: _parseIntSafe(json['ID']),
      address: json['Address']?.toString() ?? '',
      latitude: json['Latitude']
          ?.toString(), // ✅ This is correct - converts to string
      longitude: json['Longitude']
          ?.toString(), // ✅ This is correct - converts to string
      date: _parseDateSafe(json['Date']),
      flag: _parseIntSafe(json['Flag']),
      gisUrl: json['Gis_Url']?.toString(),
      handasahName: json['Handasah_Name']?.toString(),
      technicalName: json['Technical_Name']?.toString(),
      isFinished: _parseIntSafe(json['Is_Finished']) ?? 0,
      isApproved: _parseIntSafe(json['Is_Approved']) ?? 0,
      callerName: json['Caller_Name']?.toString(),
      brokenType: json['Broken_Type']?.toString(),
      callerNumber: json['Caller_Number']?.toString(),
      videoCall: _parseIntSafe(json['Video_Call']),
    );
  }
  // static int? _parseIntSafe(dynamic value) {
  //   if (value == null) return null;
  //   if (value is int) return value;
  //   if (value is String) return int.tryParse(value);
  //   return int.tryParse(value.toString());
  // }

  // static DateTime _parseDateSafe(dynamic value) {
  //   if (value == null) return DateTime.now();
  //   if (value is DateTime) return value;
  //   if (value is String) return DateTime.tryParse(value) ?? DateTime.now();
  //   return DateTime.now();
  // }

  static DateTime _parseDateSafe(dynamic value) {
    print(
      '_parseDateSafe input: $value (type: ${value.runtimeType})',
    ); // ADD THIS
    if (value == null) return DateTime.now();
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value) ?? DateTime.now();
    return DateTime.now();
  }

  static int? _parseIntSafe(dynamic value) {
    print(
      '_parseIntSafe input: $value (type: ${value.runtimeType})',
    ); // ADD THIS
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return int.tryParse(value.toString());
  }

  Map<String, dynamic> toJson() {
    return {
      'ID': id,
      'Address': address,
      'Latitude': latitude,
      'Longitude': longitude,
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

  Location copyWith({
    int? id,
    String? address,
    String? latitude,
    String? longitude,
    DateTime? date,
    int? flag,
    String? gisUrl,
    String? handasahName,
    String? technicalName,
    int? isFinished,
    int? isApproved,
    String? callerName,
    String? brokenType,
    String? callerNumber,
    int? videoCall,
  }) {
    return Location(
      id: id ?? this.id,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      date: date ?? this.date,
      flag: flag ?? this.flag,
      gisUrl: gisUrl ?? this.gisUrl,
      handasahName: handasahName ?? this.handasahName,
      technicalName: technicalName ?? this.technicalName,
      isFinished: isFinished ?? this.isFinished,
      isApproved: isApproved ?? this.isApproved,
      callerName: callerName ?? this.callerName,
      brokenType: brokenType ?? this.brokenType,
      callerNumber: callerNumber ?? this.callerNumber,
      videoCall: videoCall ?? this.videoCall,
    );
  }
}
