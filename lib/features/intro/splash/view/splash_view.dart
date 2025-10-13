import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skydive/features/intro/splash/logic/splash_cubit.dart';
import '../../../../../../gen/assets.gen.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SplashCubit>().checkAuth(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Assets.images.pattern.image(
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Assets.images.logo.image(
              width: 160.w,
              height: 160.h,
            ),
          ),
          Positioned(
            bottom: -50.h,
            right: -150.w,
            child: Assets.images.splash.image(
              fit: BoxFit.contain,
              width: 450.w,
              height: 300.h,
            ),
          ),
        ],
      ),
    );
  }
}
