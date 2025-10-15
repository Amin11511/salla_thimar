import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:logger/logger.dart';
import 'package:skydive/core/routes/routes.dart';
import 'package:skydive/core/utils/extensions.dart';
import 'package:skydive/core/widgets/app_btn.dart';
import 'package:skydive/core/widgets/app_field.dart';
import '../../../../core/services/server_gate.dart';
import '../../../../core/utils/app_theme.dart';
import '../../../../gen/assets.gen.dart';
import '../../shared_repo/auth_repository.dart';
import '../cubit/login_cubit.dart';
import '../cubit/login_state.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController(text: "123452222");
  final _passwordController = TextEditingController(text: "123456");
  String? _selectedCountryCode = '+966';
  final Logger _logger = Logger();

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(AuthRepository(ServerGate.i)),
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
                      "مرحبا بك مرة أخرى",
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: "Tajawal",
                        fontWeight: FontWeight.bold,
                        color: AppThemes.greenColor.color,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "يمكنك تسجيل الدخول الأن",
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: "Tajawal",
                        fontWeight: FontWeight.normal,
                        color: AppThemes.greyColor.color,
                      ),
                    ),
                    SizedBox(height: 30),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: AppThemes.lightLightGrey.color,
                                width: 1.5,
                              ),
                            ),
                            child: CountryCodePicker(
                              onChanged: (country) {
                                setState(() {
                                  _selectedCountryCode = country.dialCode;
                                });
                              },
                              initialSelection: 'SA',
                              favorite: ['+966', 'SA'],
                              showCountryOnly: false,
                              showOnlyCountryWhenClosed: false,
                              alignLeft: false,
                              builder: (country) {
                                final uri = country?.flagUri;
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      if (uri != null && uri.isNotEmpty)
                                        Image.asset(
                                          uri,
                                          package: 'country_code_picker',
                                          width: 32,
                                          height: 20,
                                          fit: BoxFit.contain,
                                        )
                                      else
                                        const SizedBox(height: 20),
                                      const SizedBox(height: 6),
                                      Text(
                                        country?.dialCode ?? '',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontFamily: "Tajawal",
                                          fontWeight: FontWeight.bold,
                                          color: AppThemes.greenColor.color,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          flex: 8,
                          child: AppField(
                            hintText: "رقم الجوال",
                            prefixIcon: Assets.images.phone.image(
                              width: 20.w,
                              height: 20.h,
                            ),
                            controller: _phoneController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'الرجاء إدخال رقم الجوال';
                              }
                              if (value.replaceAll(RegExp(r'[^0-9]'), '').length < 9) {
                                return 'رقم الجوال يجب أن يكون 9 أرقام على الأقل';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: AppField(
                            hintText: "كلمة المرور",
                            prefixIcon: Assets.images.lock.image(
                              width: 20.w,
                              height: 20.h,
                            ),
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
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, NamedRoutes.forgetPassword);
                          },
                          child: Text(
                            "هل نسيت كلمة المرور؟",
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: "Tajawal",
                              fontWeight: FontWeight.bold,
                              color: AppThemes.greenColor.color,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 22),
                    Row(
                      children: [
                        Expanded(
                          child: BlocConsumer<LoginCubit, LoginState>(
                            listener: (context, state) {
                              if (state is LoginSuccess) {
                                _logger.d('LoginSuccess emitted, navigating to home with user: ${state.user}');
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('تم تسجيل الدخول بنجاح'),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                                Navigator.pushReplacementNamed(
                                  context,
                                  NamedRoutes.home,
                                );
                              } else if (state is LoginError) {
                                _logger.e('LoginError: ${state.message}');
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(state.message),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              }
                            },
                            builder: (context, state) {
                              if (state is LoginLoading) {
                                return Center(
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(AppThemes.greenColor.color),
                                  ),
                                );
                              }
                              return AppBtn(
                                title: "تسجيل الدخول",
                                backgroundColor: AppThemes.greenColor.color,
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    context.read<LoginCubit>().login(
                                      phone: _phoneController.text,
                                      password: _passwordController.text,
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
                            Navigator.pushNamed(context, NamedRoutes.register);
                          },
                          child: Row(
                            children: [
                              Text(
                                "ليس لديك حساب ؟",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: "Tajawal",
                                  fontWeight: FontWeight.normal,
                                  color: AppThemes.greenColor.color,
                                ),
                              ),
                              Text(
                                "تسجيل الآن ",
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