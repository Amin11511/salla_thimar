import '../../../../core/services/server_gate.dart';

class AuthRepository {
  final ServerGate serverGate;

  AuthRepository(this.serverGate);

  Future<dynamic> login({
    required String phone,
    required String password,
  }) async {
    final response = await serverGate.sendToServer(
      url: 'login',
      body: {
        'phone': phone,
        'password': password,
        'device_token': 'test',
        'type': 'ios',
        'user_type': 'client',
      },
    );
    return response;
  }

  Future<CustomResponse> register({
    required String fullname,
    required String phone,
    required String password,
    required String passwordConfirmation,
    required String city,
    required double latitude,
    required double longitude,
  }) async {
    final response = await serverGate.sendToServer(
      url: 'client_register',
      body: {
        'fullname': fullname,
        'phone': phone,
        'password': password,
        'password_confirmation': passwordConfirmation,
        'city': city,
        'latitude': latitude.toString(),
        'longitude': longitude.toString(),
      },
    );
    return response;
  }

  Future<CustomResponse> verify({
    required String code,
    required String phone,
    String deviceToken = 'test',
    String type = 'ios',
  }) async {
    try {
      final response = await serverGate.sendToServer(
        url: 'verify',
        body: {
          'code': code,
          'phone': phone,
          'device_token': deviceToken,
          'type': type,
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<CustomResponse> resendCode({
    required String phone,
  }) async {
    try {
      final response = await serverGate.sendToServer(
        url: 'resend_code',
        body: {
          'phone': phone,
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<CustomResponse> forgetPassword({
    required String phone,
  }) async {
    try {
      final response = await serverGate.sendToServer(
        url: 'forget_password',
        body: {
          'phone': phone,
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<CustomResponse> checkCode({
    required String phone,
    required String code,
  }) async {
    try {
      final response = await serverGate.sendToServer(
        url: 'check_code',
        body: {
          'phone': phone,
          'code': code,
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  Future<CustomResponse> resetPassword({
    required String phone,
    required String code,
    required String password,
  }) async {
    try {
      final response = await serverGate.sendToServer(
        url: 'reset_password',
        body: {
          'phone': phone,
          'code': code,
          'password': password,
        },
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
