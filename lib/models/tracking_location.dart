// ignore_for_file: public_member_api_docs, sort_constructors_first

class TrackingLocation {
  final int? id;
  final String? address;
  final String? latitude;
  final String? longitude;
  final String? technicalName;
  final String? startLatitude;
  final String? startLongitude;
  final String? currentLatitude;
  final String? currentLongitude;

  TrackingLocation({
    this.id,
    this.address,
    this.latitude,
    this.longitude,
    this.technicalName,
    this.startLatitude,
    this.startLongitude,
    this.currentLatitude,
    this.currentLongitude,
  });

  factory TrackingLocation.fromJson(Map<String, dynamic> json) {
    return TrackingLocation(
      id: json['id'] as int?,
      address: json['address'] as String?,
      latitude: json['latitude'] as String?,
      longitude: json['longitude'] as String?,
      technicalName: json['technical_Name'] as String?,
      startLatitude: json['start_latitude'] as String?,
      startLongitude: json['start_longitude'] as String?,
      currentLatitude: json['current_latitude'] as String?,
      currentLongitude: json['current_longitude'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'technical_Name': technicalName,
      'start_latitude': startLatitude,
      'start_longitude': startLongitude,
      'current_latitude': currentLatitude,
      'current_longitude': currentLongitude,
    };
  }
}
