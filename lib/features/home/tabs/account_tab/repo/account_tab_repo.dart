import '../../../../../core/services/server_gate.dart';
import '../model/logout_model.dart';

class ProfileService {
  final ServerGate _serverGate;

  ProfileService(this._serverGate);

  Future<LogoutResponse> logout(String deviceToken, String type) async {
    try {
      final response = await _serverGate.sendToServer(
        url: 'logout',
        body: {
          'device_token': deviceToken,
          'type': type,
        },
      );
      if (response.success) {
        return LogoutResponse.fromJson(response.data);
      } else {
        throw Exception(response.msg.isNotEmpty ? response.msg : 'Failed to logout');
      }
    } catch (e) {
      throw Exception('Error during logout: $e');
    }
  }

  Future<Map<String, dynamic>> getProfile() async {
    try {
      final response = await _serverGate.getFromServer(
        url: 'client/profile',
      );
      if (response.success) {
        return response.data;
      } else {
        throw Exception(response.msg.isNotEmpty ? response.msg : 'Failed to fetch profile');
      }
    } catch (e) {
      throw Exception('Error fetching profile: $e');
    }
  }
}