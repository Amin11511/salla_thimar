import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../shared_repo/auth_repository.dart';
import 'forget_password_state.dart';

class ForgetPasswordCubit extends Cubit<ForgetPasswordState> {
  final AuthRepository authRepository;
  final Logger _logger = Logger();

  ForgetPasswordCubit(this.authRepository) : super(ForgetPasswordInitial());

  Future<void> forgetPassword({required String phone}) async {
    emit(ForgetPasswordLoading());
    try {
      _logger.d('Sending forget_password request: phone=$phone');

      final response = await authRepository.forgetPassword(phone: phone);
      _logger.d('ForgetPassword response: status=${response.statusCode}, data=${response.data}');

      if (response.statusCode == 200 && response.data['status'] == 'success') {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        final devMessage = response.data['dev_message'] as int?;
        await prefs.setInt('dev_message', response.data['dev_message'] as int);
        _logger.d('dev_message saved: $devMessage');
        emit(ForgetPasswordSuccess(
          response.data['message'] ?? 'تم الإرسال بنجاح',
          response.data['dev_message'] as int,
        ));
      } else {
        emit(ForgetPasswordError(response.data['message'] ?? 'خطأ غير معروف'));
      }
    } catch (e) {
      if (e is DioException) {
        _logger.e('DioException in forget_password: type=${e.type}, message=${e.message}, response=${e.response?.data}');
        emit(ForgetPasswordError(e.response?.data['message'] ?? e.message ?? 'خطأ في الشبكة'));
      } else {
        _logger.e('ForgetPassword error: $e');
        emit(ForgetPasswordError('خطأ غير متوقع: $e'));
      }
    }
  }
}