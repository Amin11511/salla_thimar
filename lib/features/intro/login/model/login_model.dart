class LoginData {
  final int? id;
  final String fullname;
  final String phone;
  final String? email;
  final String? image;
  final int? isBan;
  final bool? isActive;
  final int? unreadNotifications;
  final String? userType;
  final String? token;
  final dynamic country;
  final dynamic city;
  final dynamic identityNumber;
  final int? userCartCount;

  LoginData({
    this.id,
    required this.fullname,
    required this.phone,
    this.email,
    this.image,
    this.isBan,
    this.isActive,
    this.unreadNotifications,
    this.userType,
    this.token,
    this.country,
    this.city,
    this.identityNumber,
    this.userCartCount,
  });

  factory LoginData.fromJson(Map<String, dynamic> json) {
    return LoginData(
      id: json['id'] as int,
      fullname: json['fullname'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String,
      image: json['image'] as String,
      isBan: json['is_ban'] as int,
      isActive: json['is_active'] as bool,
      unreadNotifications: json['unread_notifications'] as int,
      userType: json['user_type'] as String,
      token: json['token'] as String,
      country: json['country'],
      city: json['city'],
      identityNumber: json['identity_number'],
      userCartCount: json['user_cart_count'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullname': fullname,
      'phone': phone,
      'email': email,
      'image': image,
      'is_ban': isBan,
      'is_active': isActive,
      'unread_notifications': unreadNotifications,
      'user_type': userType,
      'token': token,
      'country': country,
      'city': city,
      'identity_number': identityNumber,
      'user_cart_count': userCartCount,
    };
  }
}