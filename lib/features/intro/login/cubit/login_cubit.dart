import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import '../../../../models/user_model.dart';
import '../../shared_repo/auth_repository.dart';
import '../../verify_phone/model/verify_phone_model.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepository authRepository;
  final Logger _logger = Logger();

  LoginCubit(this.authRepository) : super(LoginInitial());

  Future<void> login({
    required String phone,
    required String password,
  }) async {
    emit(LoginLoading());

    try {
      String apiPhone = phone.replaceAll(RegExp(r'[^0-9]'), '');
      if (apiPhone.startsWith('0')) {
        apiPhone = apiPhone.substring(1);
      }
      _logger.d('Original phone: $phone, Formatted phone: $apiPhone');

      _logger.d('Sending login request: phone=$apiPhone, password=$password');
      final response = await authRepository.login(
        phone: apiPhone,
        password: password,
      );

      _logger.d('Login response: status=${response.statusCode}, data=${response.data}');

      if (response.statusCode == 200 && response.data['status'] == 'success') {
        if (response.data['data'] != null && response.data['data'] is Map<String, dynamic>) {
          final userData = response.data['data'] as Map<String, dynamic>;
          final user = UserData.fromJson(userData);
          final token = user.token;
          if (token == null || token.isEmpty) {
            _logger.e('Token is null or empty in response data');
            emit(LoginError('خطأ: التوكن غير موجود أو فارغ'));
            return;
          }
          UserModel.i.fromJson(userData);
          UserModel.i.save();
          _logger.d('UserModel updated and saved with token: $token');
          emit(LoginSuccess(user));
        } else {
          _logger.e('Invalid data structure in response: ${response.data}');
          emit(LoginError('خطأ: هيكل البيانات غير صحيح'));
        }
      } else {
        final errorMessage = response.data['message']?.toString() ?? 'خطأ غير معروف';
        _logger.e('API error: $errorMessage, statusCode=${response.statusCode}, fullResponse=${response.data}');
        emit(LoginError(errorMessage));
      }
    } catch (e) {
      _logger.e('Login error: $e');
      String errorMessage = 'خطأ غير متوقع';
      if (e is DioException) {
        errorMessage = e.response?.data['message']?.toString() ?? e.message ?? 'خطأ في الاتصال';
        _logger.e('DioException: type=${e.type}, message=${e.message}, response=${e.response?.data}');
      }
      emit(LoginError(errorMessage));
    }
  }
}
