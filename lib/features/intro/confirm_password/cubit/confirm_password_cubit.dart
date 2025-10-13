import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../shared_repo/auth_repository.dart';
import 'confirm_password_state.dart';

class ConfirmPasswordCubit extends Cubit<ConfirmPasswordState> {
  final AuthRepository authRepository;

  ConfirmPasswordCubit(this.authRepository) : super(ConfirmPasswordInitial());

  Future<void> resetPassword({
    required String phone,
    required String code,
    required String password,
    required String confirmPassword,
  }) async {
    if (password != confirmPassword) {
      emit(ConfirmPasswordError('كلمتا المرور غير متطابقتين'));
      return;
    }

    emit(ConfirmPasswordLoading());
    try {
      print('Sending reset_password request: phone=$phone, code=$code, password=$password');

      final response = await authRepository.resetPassword(
        phone: phone,
        code: code,
        password: password,
      );
      print('ResetPassword response: ${response.statusCode}, ${response.data}');

      if (response.statusCode == 200 && response.data['status'] == 'success') {
        emit(ConfirmPasswordSuccess(response.data['message'] ?? 'تم تغيير كلمة المرور بنجاح'));
      } else {
        emit(ConfirmPasswordError(response.data['message'] ?? 'خطأ غير معروف'));
      }
    } catch (e) {
      if (e is DioException) {
        print('DioException in reset_password: ${e.type}, ${e.message}, Response: ${e.response?.data}');
        emit(ConfirmPasswordError(e.response?.data['message'] ?? e.message ?? 'خطأ في الشبكة'));
      } else {
        print('ResetPassword error: $e');
        emit(ConfirmPasswordError('خطأ غير متوقع: $e'));
      }
    }
  }
}