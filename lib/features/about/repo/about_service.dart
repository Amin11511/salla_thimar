import '../../../core/services/server_gate.dart';

class AboutService {
  final ServerGate _serverGate;

  AboutService(this._serverGate);

  Future<Map<String, dynamic>> getAbout() async {
    try {
      final response = await _serverGate.getFromServer(
        url: 'about',
      );
      if (response.success) {
        return response.data;
      } else {
        throw Exception(response.msg.isNotEmpty ? response.msg : 'Failed to fetch about data');
      }
    } catch (e) {
      throw Exception('Error fetching about data: $e');
    }
  }
}