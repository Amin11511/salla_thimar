import '../../../core/services/server_gate.dart';
import '../model/contact_model.dart';

class ContactService {
  final ServerGate _serverGate;

  ContactService(this._serverGate);

  Future<ContactInfo> fetchContactInfo() async {
    try {
      final response = await _serverGate.getFromServer(
        url: 'contact',
      );
      if (response.success) {
        return ContactInfo.fromJson(response.data['data']);
      } else {
        throw Exception(response.msg.isNotEmpty ? response.msg : 'Failed to fetch contact info');
      }
    } catch (e) {
      throw Exception('Error fetching contact info: $e');
    }
  }

  Future<String> sendMessage({
    required String fullname,
    required String phone,
    required String title,
    required String content,
  }) async {
    try {
      final response = await _serverGate.sendToServer(
        url: 'contact',
        body: {
          'fullname': fullname,
          'phone': phone,
          'title': title,
          'content': content,
        },
      );
      if (response.success) {
        return response.data['message'] as String;
      } else {
        throw Exception(response.msg.isNotEmpty ? response.msg : 'Failed to send message');
      }
    } catch (e) {
      throw Exception('Error sending message: $e');
    }
  }
}