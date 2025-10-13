import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../shared_repo/auth_repository.dart';
import '../cubit/verify_phone_state.dart';
import '../model/verify_phone_model.dart';

class VerifyPhoneCubit extends Cubit<VerifyPhoneState> {
  final AuthRepository authRepository;
  final Logger _logger = Logger();
  int? devMessage;

  VerifyPhoneCubit(this.authRepository, {this.devMessage}) : super(VerifyPhoneInitial());

  Future<void> verifyOtp({
    required String code,
    required String phone,
    String? countryCode,
    String deviceToken = 'test',
    String type = 'ios',
  }) async {
    emit(VerifyPhoneLoading());
    try {
      // Validate code
      final intCode = int.tryParse(code);
      if (intCode == null) {
        _logger.w("Invalid OTP: $code cannot be parsed to int");
        emit(VerifyPhoneError('الرجاء إدخال كود مكون من 4 أرقام'));
        return;
      }

      // تنسيق رقم الهاتف
      String apiPhone = phone.replaceAll(RegExp(r'[^0-9]'), ''); // إزالة أي أحرف غير أرقام
      if (apiPhone.startsWith('0')) {
        apiPhone = apiPhone.substring(1); // إزالة الصفر الأولي إذا وجد
      }
      _logger.d('Original phone: $phone, countryCode: $countryCode, Final apiPhone: $apiPhone');

      _logger.d('Sending verify request: code=$intCode, phone=$apiPhone, device_token=$deviceToken, type=$type');

      final response = await authRepository.verify(
        code: intCode.toString(),
        phone: apiPhone,
        deviceToken: deviceToken,
        type: type,
      );
      _logger.d('Verify response: status=${response.statusCode}, data=${response.data}, message=${response.data['message'] ?? 'No message'}');

      // تحقق من استجابة الـ API
      if (response.statusCode == 200) {
        if (response.data['data'] != null && response.data['data'] is Map<String, dynamic>) {
          final user = UserData.fromJson(response.data['data'] as Map<String, dynamic>);
          final token = user.token;
          if (token == null || token.isEmpty) {
            _logger.e('Token is null or empty in response data');
            emit(VerifyPhoneError('خطأ: التوكن غير موجود أو فارغ'));
            return;
          }
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', token);
          _logger.d('Token saved: $token');
          emit(VerifyPhoneVerifySuccess(
            response.data['message']?.toString() ?? 'تم تفعيل الحساب بنجاح!',
            token,
          ));
        } else {
          _logger.e('Invalid data structure in response: ${response.data}');
          emit(VerifyPhoneError('خطأ: هيكل البيانات غير صحيح'));
        }
      } else {
        final errorMessage = response.data['message']?.toString() ?? 'خطأ غير معروف';
        _logger.e('API error: $errorMessage, statusCode=${response.statusCode}, fullResponse=${response.data}');
        emit(VerifyPhoneError(errorMessage));
        // إذا كان الحساب تم تفعيله بالفعل، حاول إعادة توجيه المستخدم
        if (response.statusCode == 404 && errorMessage.contains('الكود غير صحيح')) {
          _logger.w('Possible account already activated, redirecting to login');
          emit(VerifyPhoneVerifySuccess(
            'تم تفعيل الحساب مسبقًا، يرجى تسجيل الدخول',
            '',
          ));
        }
      }
    } catch (e) {
      _logger.e('Error: $e');
      String errorMessage = 'خطأ غير متوقع';
      if (e is DioException) {
        errorMessage = e.response?.data['message']?.toString() ?? e.message ?? 'خطأ في الاتصال';
        _logger.e('DioException: type=${e.type}, message=${e.message}, response=${e.response?.data}');
        // التحقق من حالة الحساب المفعل مسبقًا
        if (e.response?.statusCode == 404 && e.response?.data['message']?.toString().contains('الكود غير صحيح') == true) {
          _logger.w('Possible account already activated, redirecting to login');
          emit(VerifyPhoneVerifySuccess(
            'تم تفعيل الحساب مسبقًا، يرجى تسجيل الدخول',
            '',
          ));
        }
      }
      emit(VerifyPhoneError(errorMessage));
    }
  }

  Future<void> resendCode({required String phone, String? countryCode}) async {
    emit(VerifyPhoneLoading());
    try {
      // Use phone as received (already formatted as 966xxxxxxxxx)
      String apiPhone = phone;
      _logger.d('Original phone: $phone, countryCode: $countryCode, Final apiPhone: $apiPhone');
      _logger.d('Sending resend request: phone=$apiPhone');

      final response = await authRepository.resendCode(phone: apiPhone);
      _logger.d('Resend response: status=${response.statusCode}, data=${response.data}, message=${response.data['message'] ?? 'No message'}');

      if (response.statusCode == 200 && response.data['status'] == 'success') {
        final devMessage = response.data['dev_message'] as int?;
        _logger.d('New devMessage: $devMessage');
        if (devMessage != null) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setInt('devMessage', devMessage);
          _logger.d('Saved devMessage to SharedPreferences: $devMessage');
        }
        emit(VerifyPhoneResendSuccess(
          response.data['message']?.toString() ?? 'تم إعادة إرسال الكود بنجاح!',
          devMessage,
        ));
      } else {
        final errorMessage = response.data['message']?.toString() ?? 'خطأ غير معروف';
        _logger.e('API error: $errorMessage, fullResponse=${response.data}');
        emit(VerifyPhoneError(errorMessage));
      }
    } catch (e) {
      _logger.e('Error: $e');
      String errorMessage = 'خطأ غير متوقع';
      if (e is DioException) {
        errorMessage = e.response?.data['message']?.toString() ?? e.message ?? 'خطأ في الاتصال';
        _logger.e('DioException: type=${e.type}, message=${e.message}, response=${e.response?.data}');
      }
      emit(VerifyPhoneError(errorMessage));
    }
  }
}