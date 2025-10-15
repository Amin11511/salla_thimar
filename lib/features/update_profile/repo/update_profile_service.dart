import 'package:dio/dio.dart';
import '../../../core/services/server_gate.dart';
import '../../../models/user_model.dart';

class UpdateProfileService {
  final ServerGate _serverGate;

  UpdateProfileService(this._serverGate);

  Future<Map<String, dynamic>> updateProfile({
    required String fullname,
    required String phone,
    required int cityId,
    String? password,
    String? passwordConfirmation,
    String? imagePath,
  }) async {
    final token = UserModel.i.token;
    if (token == null || token.isEmpty) {
      throw Exception('التوكن غير موجود. يرجى تسجيل الدخول مرة أخرى.');
    }

    final formData = <String, dynamic>{
      'fullname': fullname,
      'phone': phone,
      'city_id': cityId.toString(),
      if (password != null && password.isNotEmpty) 'password': password,
      if (passwordConfirmation != null && passwordConfirmation.isNotEmpty)
        'password_confirmation': passwordConfirmation,
    };

    if (imagePath != null) {
      formData['image'] = await MultipartFile.fromFile(imagePath, filename: 'profile.jpg');
    }

    final response = await ServerGate.i.sendToServer(
      url: 'client/profile',
      formData: formData,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.success) {
      return response.data as Map<String, dynamic>;
    } else {
      throw Exception(response.msg);
    }
  }
}