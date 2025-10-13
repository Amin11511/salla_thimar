import '../../../core/services/server_gate.dart';

class SugAndCompService {
  final ServerGate _serverGate;

  SugAndCompService(this._serverGate);

  Future<String> sendSuggestionOrComplaint({
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
        return response.data['message']?.toString() ?? 'تم الإرسال بنجاح';
      } else {
        throw Exception(response.msg.isNotEmpty ? response.msg : 'حدث خطأ أثناء إرسال الشكوى أو الاقتراح، حاول مرة أخرى');
      }
    } catch (e) {
      throw Exception('حدث خطأ غير متوقع أثناء إرسال الشكوى أو الاقتراح: $e');
    }
  }
}