import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skydive/core/routes/routes.dart';

import '../../../../core/routes/app_routes_fun.dart';
import '../../../../models/user_model.dart';
part 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(SplashInitial());

  Future<void> checkAuth(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 3));
    UserModel.i.get();
    final token = UserModel.i.token;
    if (!context.mounted) return;
    if (token.isNotEmpty) {
      replacement(NamedRoutes.home);
    } else {
      replacement(NamedRoutes.login);
    }
  }

}
