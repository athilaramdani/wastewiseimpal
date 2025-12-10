class TrashBin {
  final int id;
  final String locationName;
  final double latitude;
  final double longitude;
  final String capacity; // 'empty', 'half', 'full'
  final String type; // 'organic', 'inorganic'
  double? distanceInKm; // Mutable field for UI display

  TrashBin({
    required this.id,
    required this.locationName,
    required this.latitude,
    required this.longitude,
    required this.capacity,
    required this.type,
    this.distanceInKm,
  });

  factory TrashBin.fromJson(Map<String, dynamic> json) {
    return TrashBin(
      id: json['bin_id'] ?? 0,
      locationName: json['location_name'] ?? '',
      latitude: json['latitude'] is num ? (json['latitude'] as num).toDouble() : 0.0,
      longitude: json['longitude'] is num ? (json['longitude'] as num).toDouble() : 0.0,
      capacity: json['capacity'] ?? 'empty',
      type: json['type'] ?? 'organic',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bin_id': id,
      'location_name': locationName,
      'latitude': latitude,
      'longitude': longitude,
      'capacity': capacity,
      'type': type,
    };
  }
}
