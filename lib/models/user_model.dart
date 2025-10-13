import 'dart:convert';
import '../main.dart';
import 'base.dart';
import 'country.dart';

class UserModel extends Model {
  UserModel._();
  static UserModel i = UserModel._();

  late String token, fullname, image, phoneCode, phone, email, userType, locale;
  late bool isActive;
  late CountryModel country;

  bool get isAuth => token.isNotEmpty;

  fromJson([Map<String, dynamic>? json]) {
    id = stringFromJson(json, "id");
    token = stringFromJson(json, "token");
    fullname = stringFromJson(json, "full_name");
    image = stringFromJson(json, "image");
    phoneCode = stringFromJson(json, "phone_code");
    phone = stringFromJson(json, "phone");
    email = stringFromJson(json, "email");
    userType = stringFromJson(json, "user_type");
    isActive = boolFromJson(json, "is_active");
    locale = stringFromJson(json, "locale");
    country = CountryModel.fromJson(json?["country"] ?? {});
  }

  save() {
    Prefs.setString('user', jsonEncode(toJson()));
  }

  clear() {
    Prefs.remove('user');
    fromJson();
  }

  get() {
    String user = Prefs.getString('user') ?? '{}';
    fromJson(jsonDecode(user));
  }

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "token": token,
        "full_name": fullname,
        "image": image,
        "phone_code": phoneCode,
        "phone": phone,
        "email": email,
        "user_type": userType,
        "is_active": isActive,
        "locale": locale,
        "country": country.toJson(),
      };
}
