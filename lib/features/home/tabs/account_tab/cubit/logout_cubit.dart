import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../repo/account_tab_repo.dart';
import 'logout_state.dart';

class LogoutCubit extends Cubit<LogoutState> {
  final ProfileService profileService;

  LogoutCubit(this.profileService) : super(LogoutInitial());

  Future<void> logout() async {
    emit(LogoutLoading());
    try {
      final prefs = await SharedPreferences.getInstance();
      final deviceToken = prefs.getString('device_token') ?? '';
      const type = 'android';

      final response = await profileService.logout(deviceToken, type);

      // Clear token after successful logout
      await prefs.remove('auth_token');
      await prefs.remove('device_token');

      emit(LogoutSuccess(response));
    } catch (e) {
      emit(LogoutError(e.toString()));
    }
  }
}