import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skydive/core/routes/app_routes_fun.dart';
import 'package:skydive/core/utils/app_theme.dart';
import 'package:skydive/core/utils/extensions.dart';
import '../../../../core/routes/routes.dart';
import '../../../../core/services/server_gate.dart';
import '../../../../core/widgets/app_btn.dart';
import '../../../../core/widgets/app_field.dart';
import '../../../../core/widgets/custom_message_dialog.dart';
import '../../../../gen/assets.gen.dart';
import '../../shared_repo/auth_repository.dart';
import '../cubit/confirm_password_cubit.dart';
import '../cubit/confirm_password_state.dart';

class ConfirmPassword extends StatefulWidget {
  final String phone;
  final String code;

  const ConfirmPassword({
    super.key,
    required this.phone,
    required this.code,
  });

  @override
  _ConfirmPasswordState createState() => _ConfirmPasswordState();
}

class _ConfirmPasswordState extends State<ConfirmPassword> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ConfirmPasswordCubit(AuthRepository(ServerGate.i)),
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Image(
                      image: AssetImage(Assets.images.logo.path),
                      width: 130,
                      height: 130,
                    ),
                    Text(
                          "نسيت كلمة المرور",
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: "Tajawal",
                            fontWeight: FontWeight.bold,
                            color: AppThemes.greenColor.color,
                          ),
                        ),
                    SizedBox(height: 10),
                    Text(
                          "ادخل كلمة المرور الجديدة",
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: "Tajawal",
                            fontWeight: FontWeight.normal,
                            color: AppThemes.greyColor.color,
                          ),
                        ),
                    SizedBox(height: 17),
                    Row(
                      children: [
                        Expanded(
                          child: AppField(
                            hintText: "كلمة المرور",
                            suffixIcon: Assets.images.lock.image(width: 20.w, height: 20.h,),
                            controller: _passwordController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'الرجاء إدخال كلمة المرور';
                              }
                              if (value.length < 6) {
                                return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: AppField(
                            hintText: "تأكيد كلمة المرور",
                            suffixIcon: Assets.images.lock.image(width: 20.w, height: 20.h),
                            controller: _confirmPasswordController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'الرجاء إدخال تأكيد كلمة المرور';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: BlocConsumer<ConfirmPasswordCubit, ConfirmPasswordState>(
                            listener: (context, state) {
                              if (state is ConfirmPasswordSuccess) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(state.message)),
                                );
                                replacement(NamedRoutes.login);
                              } else if (state is ConfirmPasswordError) {
                                showCustomMessageDialog(
                                  context,
                                  state.message,
                                );
                              }
                            },
                            builder: (context, state) {
                              if (state is ConfirmPasswordLoading) {
                                return Center(
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(AppThemes.greenColor.color),
                                  ),
                                );
                              }
                              return AppBtn(
                                title: "تغيير كلمة المرور",
                                backgroundColor: AppThemes.greenColor.color,
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    context.read<ConfirmPasswordCubit>().resetPassword(
                                      phone: widget.phone,
                                      code: widget.code,
                                      password: _passwordController.text,
                                      confirmPassword: _confirmPasswordController.text,
                                    );
                                  }
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            push(NamedRoutes.login);
                          },
                          child: Row(
                            children: [
                              Text(
                                "لديك حساب بالفعل؟",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: "Tajawal",
                                  fontWeight: FontWeight.normal,
                                  color: AppThemes.greenColor.color,
                                ),
                              ),
                              Text(
                                "تسجيل الدخول ",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: "Tajawal",
                                  fontWeight: FontWeight.bold,
                                  color: AppThemes.greenColor.color,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
