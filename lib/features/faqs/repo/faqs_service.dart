import '../../../core/services/server_gate.dart';
import '../model/faqs_model.dart';

class FaqsService {
  final ServerGate _serverGate;

  FaqsService(this._serverGate);

  Future<List<Faq>> fetchFaqs() async {
    try {
      final response = await _serverGate.getFromServer(
          url: 'faqs'
      );
      if (response.statusCode == 200) {
        final data = response.data['data'] as List;
        return data.map((json) => Faq.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load FAQs');
      }
    } catch (e) {
      throw Exception('Error fetching FAQs: $e');
    }
  }
}