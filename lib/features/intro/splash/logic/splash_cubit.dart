import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:skydive/core/routes/routes.dart';
part 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(SplashInitial());

  Future<void> checkAuth(context) async {
    await Future.delayed(const Duration(seconds: 3));
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (!context.mounted) return;

    if (token != null && token.isNotEmpty) {
      Navigator.pushReplacementNamed(context, NamedRoutes.home);
    } else {
      Navigator.pushReplacementNamed(context, NamedRoutes.login);
    }
  }
}
