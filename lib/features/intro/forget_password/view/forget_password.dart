import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skydive/core/routes/app_routes_fun.dart';
import 'package:skydive/core/routes/routes.dart';
import 'package:skydive/core/utils/app_theme.dart';
import 'package:skydive/core/utils/extensions.dart';
import 'package:skydive/core/widgets/app_btn.dart';
import '../../../../core/services/server_gate.dart';
import '../../../../core/widgets/app_field.dart';
import '../../../../core/widgets/custom_message_dialog.dart';
import '../../../../gen/assets.gen.dart';
import '../../shared_repo/auth_repository.dart';
import '../cubit/forget_password_cubit.dart';
import '../cubit/forget_password_state.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  String? _selectedCountryCode = '+966';

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ForgetPasswordCubit(AuthRepository(ServerGate.i)),
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
                          "أدخل رقم الجوال المرتبط بحسابك",
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: "Tajawal",
                            fontWeight: FontWeight.normal,
                            color: AppThemes.greyColor.color,
                          ),
                        ),
                    SizedBox(height: 30),
                    Row(
                      mainAxisSize: MainAxisSize.min,
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
                            prefixIcon: Assets.images.phone.image(width: 20.w, height: 20.h,),
                            controller: _phoneController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'الرجاء إدخال رقم الجوال';
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
                          child: BlocConsumer<ForgetPasswordCubit, ForgetPasswordState>(
                            listener: (context, state) {
                              if (state is ForgetPasswordSuccess) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(state.message)),
                                );
                                push(
                                  NamedRoutes.confirmPhone,
                                  arg: {
                                    'phoneNumber': '$_selectedCountryCode${_phoneController.text}',
                                    'countryCode': _selectedCountryCode,
                                  },
                                );
                              } else if (state is ForgetPasswordError) {
                                showCustomMessageDialog(
                                  context,
                                  state.message,
                                );
                              }
                            },
                            builder: (context, state) {
                              if (state is ForgetPasswordLoading) {
                                return Center(
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(AppThemes.greenColor.color),
                                  ),
                                );
                              }
                              return AppBtn(
                                title: "تأكيد رقم الجوال",
                                backgroundColor: AppThemes.greenColor.color,
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    context.read<ForgetPasswordCubit>().forgetPassword(
                                      phone: _phoneController.text,
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
                                "لديك حساب ؟",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: "Tajawal",
                                  fontWeight: FontWeight.normal,
                                  color: AppThemes.greenColor.color,
                                ),
                              ),
                              Text(
                                "تسجيل دخول ",
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
