class ProfileData {
  final int id;
  final String fullname;
  final String phone;
  final String? image;
  final String? city;
  final bool isVip;

  ProfileData({
    required this.id,
    required this.fullname,
    required this.phone,
    this.image,
    this.city,
    required this.isVip,
  });

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    return ProfileData(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      fullname: json['fullname'] is String ? json['fullname'] : json['fullname']?.toString() ?? '',
      phone: json['phone'] is String ? json['phone'] : json['phone']?.toString() ?? '',
      image: json['image'] is String ? json['image'] : json['image']?.toString(),
      city: json['city'] is String ? json['city'] : json['city']?.toString(),
      isVip: json['is_vip'] is bool
          ? json['is_vip']
          : json['is_vip'] == 1 || json['is_vip'].toString().toLowerCase() == 'true',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullname': fullname,
      'phone': phone,
      'image': image,
      'city': city,
      'is_vip': isVip,
    };
  }
}