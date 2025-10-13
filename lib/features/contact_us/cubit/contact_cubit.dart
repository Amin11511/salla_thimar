import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../model/contact_model.dart';
import '../repo/contact_service.dart';
import 'contact_state.dart';

class ContactCubit extends Cubit<ContactState> {
  final ContactService contactService;
  ContactInfo? contactInfo;

  ContactCubit(this.contactService) : super(ContactInitial());

  Future<void> fetchContactInfo() async {
    emit(ContactLoading());
    try {
      final info = await contactService.fetchContactInfo();
      contactInfo = info;
      emit(ContactSuccess(info));
    } catch (e) {
      emit(ContactError('حدث خطأ أثناء جلب بيانات التواصل: ${e.toString()}'));
    }
  }

  Future<void> sendMessage({
    required String fullname,
    required String phone,
    required String title,
    required String content,
  }) async {
    emit(SendMessageLoading());
    try {
      final message = await contactService.sendMessage(
        fullname: fullname,
        phone: phone,
        title: title,
        content: content,
      );
      emit(SendMessageSuccess(message));
    } catch (e) {
      print('Detailed error: $e'); // Log detailed error for debugging
      String userMessage = 'حدث خطأ أثناء إرسال الرسالة، حاول مرة أخرى';
      if (e is DioException && e.response != null) {
        final responseData = e.response?.data;
        if (responseData is Map && responseData.containsKey('message')) {
          userMessage = responseData['message']?.toString() ?? userMessage;
        }
      }
      emit(SendMessageError(userMessage));
    }
  }
}