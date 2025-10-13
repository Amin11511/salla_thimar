class CurrentAddressesModel {
  final int id;
  final String type;
  final double lat;
  final double lng;
  final String location;
  final String description;
  final bool isDefault;
  final String phone;

  CurrentAddressesModel({
    required this.id,
    required this.type,
    required this.lat,
    required this.lng,
    required this.location,
    required this.description,
    required this.isDefault,
    required this.phone,
  });

  factory CurrentAddressesModel.fromJson(Map<String, dynamic> json) {
    return CurrentAddressesModel(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      type: json['type'] is String ? json['type'] : json['type']?.toString() ?? '',
      lat: (json['lat'] is num ? json['lat'].toDouble() : double.parse(json['lat'].toString())),
      lng: (json['lng'] is num ? json['lng'].toDouble() : double.parse(json['lng'].toString())),
      location: json['location'] is String ? json['location'] : json['location']?.toString() ?? '',
      description: json['description'] is String ? json['description'] : json['description']?.toString() ?? '',
      isDefault: json['is_default'] is bool ? json['is_default'] : json['is_default'] == 1 || json['is_default'].toString().toLowerCase() == 'true',
      phone: json['phone'] is String ? json['phone'] : json['phone']?.toString() ?? '',
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