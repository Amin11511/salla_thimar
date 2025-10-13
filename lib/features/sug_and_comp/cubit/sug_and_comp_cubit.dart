import 'package:flutter_bloc/flutter_bloc.dart';
import '../repo/sug_and_comp_service.dart';
import 'sug_and_comp_state.dart';

class SugAndCompCubit extends Cubit<SugAndCompState> {
  final SugAndCompService sugAndCompService;

  SugAndCompCubit(this.sugAndCompService) : super(SugAndCompInitial());

  Future<void> sendSuggestionOrComplaint({
    required String fullname,
    required String phone,
    required String title,
    required String content,
  }) async {
    emit(SugAndCompLoading());
    try {
      final message = await sugAndCompService.sendSuggestionOrComplaint(
        fullname: fullname,
        phone: phone,
        title: title,
        content: content,
      );
      emit(SugAndCompSuccess(message));
    } catch (e) {
      print('Detailed error: $e'); // Log for debugging
      String userMessage = 'حدث خطأ أثناء إرسال الشكوى أو الاقتراح، حاول مرة أخرى';
      if (e.toString().contains('DioException') && e is Exception) {
        userMessage = e.toString().replaceAll('Exception: ', '');
      }
      emit(SugAndCompError(userMessage));
    }
  }
}