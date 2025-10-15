import 'package:logger/logger.dart';
import '../../../../../core/services/server_gate.dart';
import '../../../../../models/user_model.dart';
import '../model/notification_model.dart';

class NotificationService {
  final ServerGate serverGate;
  final Logger _logger = Logger();

  NotificationService(this.serverGate);

  Future<NotificationsResponse> getNotifications({int page = 1}) async {
    try {
      final token = UserModel.i.token;
      if (token.isEmpty) {
        _logger.e('No authentication token found in UserModel');
        throw Exception('No authentication token found');
      }

      final response = await serverGate.getFromServer(
        url: 'notifications',
      );

      return NotificationsResponse.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to fetch notifications: $e');
    }
  }

  Future<NotificationResponse> showNotification(int id) async {
    try {
      final token = UserModel.i.token;
      if (token.isEmpty) {
        _logger.e('No authentication token found in UserModel');
        throw Exception('No authentication token found');
      }

      final response = await serverGate.getFromServer(
        url: 'notifications/$id',
      );

      return NotificationResponse.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to fetch notification: $e');
    }
  }

  Future<NotificationResponse> deleteNotification(int id) async {
    try {
      final token = UserModel.i.token;
      if (token.isEmpty) {
        _logger.e('No authentication token found in UserModel');
        throw Exception('No authentication token found');
      }

      final response = await serverGate.deleteFromServer(
        url: 'notifications/$id',
      );

      return NotificationResponse.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to delete notification: $e');
    }
  }

  Future<NotificationResponse> clearAllNotifications() async {
    try {
      final token = UserModel.i.token;
      if (token.isEmpty) {
        _logger.e('No authentication token found in UserModel');
        throw Exception('No authentication token found');
      }

      final response = await serverGate.sendToServer(
        url: 'notifications/clear_all_notifications',
      );

      return NotificationResponse.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to clear notifications: $e');
    }
  }
}