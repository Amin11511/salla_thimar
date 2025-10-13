import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../shared_repo/auth_repository.dart';
import 'confirm_phone_state.dart';

class ConfirmPhoneCubit extends Cubit<ConfirmPhoneState> {
  final AuthRepository authRepository;
  int? devMessage;

  ConfirmPhoneCubit(this.authRepository) : super(ConfirmPhoneInitial()) {
    _loadDevMessage();
  }

  Future<void> _loadDevMessage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    devMessage = prefs.getInt('dev_message');
    emit(ConfirmPhoneInitial());
  }

  Future<void> verifyCode({
    required String phone,
    required String code,
    String? countryCode,
  }) async {
    emit(ConfirmPhoneLoading());
    try {
      String apiPhone = phone;
      if (countryCode != null && apiPhone.startsWith(countryCode)) {
        apiPhone = apiPhone.substring(countryCode.length);
      }
      print('Sending check_code request: phone=$apiPhone, code=$code');

      if (devMessage != null && int.tryParse(code) != devMessage) {
        emit(ConfirmPhoneError('الكود غير صحيح'));
        return;
      }

      final response = await authRepository.checkCode(
        phone: apiPhone,
        code: code,
      );
      print('CheckCode response: ${response.statusCode}, ${response.data}');

      if (response.statusCode == 200 && response.data['status'] == 'success') {
        emit(ConfirmPhoneVerifySuccess(response.data['message'] ?? 'تم التحقق بنجاح'));
      } else {
        emit(ConfirmPhoneError(response.data['message'] ?? 'خطأ غير معروف'));
      }
    } catch (e) {
      if (e is DioException) {
        print('DioException in check_code: ${e.type}, ${e.message}, Response: ${e.response?.data}');
        emit(ConfirmPhoneError(e.response?.data['message'] ?? e.message ?? 'خطأ في الشبكة'));
      } else {
        print('CheckCode error: $e');
        emit(ConfirmPhoneError('خطأ غير متوقع: $e'));
      }
    }
  }

  Future<void> resendCode({required String phone, String? countryCode}) async {
    emit(ConfirmPhoneLoading());
    try {
      String apiPhone = phone;
      if (countryCode != null && apiPhone.startsWith(countryCode)) {
        apiPhone = apiPhone.substring(countryCode.length);
      }
      print('Sending resend_code request: phone=$apiPhone');

      final response = await authRepository.resendCode(phone: apiPhone);
      print('ResendCode response: ${response.statusCode}, ${response.data}');

      if (response.statusCode == 200 && response.data['status'] == 'success') {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setInt('dev_message', response.data['dev_message'] as int);
        devMessage = response.data['dev_message'] as int;
        emit(ConfirmPhoneResendSuccess(
          response.data['message'] ?? 'تم إعادة إرسال الكود بنجاح',
          devMessage!,
        ));
      } else {
        emit(ConfirmPhoneError(response.data['message'] ?? 'خطأ غير معروف'));
      }
    } catch (e) {
      if (e is DioException) {
        print('DioException in resend_code: ${e.type}, ${e.message}, Response: ${e.response?.data}');
        emit(ConfirmPhoneError(e.response?.data['message'] ?? e.message ?? 'خطأ في الشبكة'));
      } else {
        print('ResendCode error: $e');
        emit(ConfirmPhoneError('خطأ غير متوقع: $e'));
      }
    }
  }
}