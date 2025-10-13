class AddressModel {
  final int id;
  final String type;
  final double lat;
  final double lng;
  final String location;
  final String description;
  final bool isDefault;
  final String phone;

  AddressModel({
    required this.id,
    required this.type,
    required this.lat,
    required this.lng,
    required this.location,
    required this.description,
    required this.isDefault,
    required this.phone,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['id'] as int,
      type: json['type'] as String,
      lat: (json['lat'] is int ? json['lat'].toDouble() : json['lat']) as double,
      lng: (json['lng'] is int ? json['lng'].toDouble() : json['lng']) as double,
      location: json['location'] as String,
      description: json['description'] as String,
      isDefault: json['is_default'] as bool,
      phone: json['phone'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'lat': lat,
      'lng': lng,
      'location': location,
      'description': description,
      'is_default': isDefault,
      'phone': phone,
    };
  }
}