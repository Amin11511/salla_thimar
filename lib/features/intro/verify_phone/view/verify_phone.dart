import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:skydive/core/routes/app_routes_fun.dart';
import 'package:skydive/core/routes/routes.dart';
import 'package:skydive/core/utils/app_theme.dart';
import 'package:skydive/core/utils/extensions.dart';
import '../../../../core/services/server_gate.dart';
import '../../../../core/widgets/app_btn.dart';
import '../../../../gen/assets.gen.dart';
import '../../shared_repo/auth_repository.dart';
import '../cubit/verify_phone_cubit.dart';
import '../cubit/verify_phone_state.dart';

class VerifyPhone extends StatefulWidget {
  final String phoneNumber;
  final String? countryCode;
  final int? initialDevMessage;

  const VerifyPhone({
    super.key,
    required this.phoneNumber,
    this.countryCode,
    this.initialDevMessage,
  });

  @override
  _VerifyPhoneState createState() => _VerifyPhoneState();
}

class _VerifyPhoneState extends State<VerifyPhone> {
  final CountDownController _controller = CountDownController();
  bool isTimerRunning = true;
  String otp = '';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => VerifyPhoneCubit(
        AuthRepository(ServerGate.i),
        devMessage: widget.initialDevMessage,
      ),
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
            child: SingleChildScrollView(
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
                    "تفعيل الحساب",
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: "Tajawal",
                      fontWeight: FontWeight.bold,
                      color: AppThemes.greenColor.color,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "أدخل الكود المكون من 4 أرقام المرسل على رقم الجوال",
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: "Tajawal",
                      fontWeight: FontWeight.normal,
                      color: AppThemes.greyColor.color,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        widget.phoneNumber,
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: "Tajawal",
                          fontWeight: FontWeight.normal,
                          color: AppThemes.greyColor.color,
                        ),
                      ),
                      const SizedBox(width: 5),
                      GestureDetector(
                        onTap: () {
                          push(NamedRoutes.register);
                        },
                        child: Text(
                          "تغيير رقم الجوال",
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: "Tajawal",
                            fontWeight: FontWeight.bold,
                            color: AppThemes.greenColor.color,
                            decoration: TextDecoration.underline,
                            decorationColor: AppThemes.greenColor.color,
                            decorationThickness: 2,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  PinCodeTextField(
                    appContext: context,
                    length: 4,
                    obscureText: false,
                    animationType: AnimationType.fade,
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(16),
                      fieldHeight: 60,
                      fieldWidth: 70,
                      inactiveColor: AppThemes.lightLightGrey.color,
                      activeColor: AppThemes.greenColor.color,
                      selectedColor: AppThemes.greenColor.color,
                    ),
                    animationDuration: const Duration(milliseconds: 300),
                    enableActiveFill: false,
                    onChanged: (value) {
                      setState(() {
                        otp = value;
                      });
                    },
                    // إزالة onCompleted لمنع التحقق المزدوج
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 27),
                  Row(
                    children: [
                      Expanded(
                        child: BlocConsumer<VerifyPhoneCubit, VerifyPhoneState>(
                          listener: (context, state) {
                            if (state is VerifyPhoneVerifySuccess) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(state.message),
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                              replacement(NamedRoutes.login);
                            } else if (state is VerifyPhoneResendSuccess) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(state.message),
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            } else if (state is VerifyPhoneError) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(state.message),
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            }
                          },
                          builder: (context, state) {
                            if (state is VerifyPhoneLoading) {
                              return Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(AppThemes.greenColor.color),
                                ),
                              );
                            }
                            return AppBtn(
                              title: "تأكيد الكود",
                              backgroundColor: AppThemes.greenColor.color,
                              onPressed: () {
                                if (otp.length == 4) {
                                  context.read<VerifyPhoneCubit>().verifyOtp(
                                    code: otp,
                                    phone: widget.phoneNumber,
                                    countryCode: widget.countryCode,
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('الرجاء إدخال كود مكون من 4 أرقام'),
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                }
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 27),
                  Column(
                    children: [
                      Text(
                        "لم تستلم الكود؟",
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: "Tajawal",
                          fontWeight: FontWeight.normal,
                          color: AppThemes.greyColor.color,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "يمكنك إعادة إرسال الكود بعد",
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: "Tajawal",
                          fontWeight: FontWeight.normal,
                          color: AppThemes.greyColor.color,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: CircularCountDownTimer(
                      duration: 60,
                      initialDuration: 0,
                      controller: _controller,
                      width: 70,
                      height: 70,
                      ringColor: AppThemes.lightLightGrey.color,
                      fillColor: AppThemes.greenColor.color,
                      backgroundColor: Colors.transparent,
                      strokeWidth: 5.0,
                      strokeCap: StrokeCap.round,
                      textStyle: const TextStyle(
                        fontSize: 21.0,
                        color: Colors.green,
                        fontWeight: FontWeight.normal,
                      ),
                      textFormat: CountdownTextFormat.MM_SS,
                      isReverse: true,
                      isTimerTextShown: true,
                      autoStart: true,
                      onComplete: () {
                        setState(() {
                          isTimerRunning = false;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: GestureDetector(
                      onTap: isTimerRunning
                          ? null
                          : () {
                        setState(() {
                          isTimerRunning = true;
                          _controller.restart();
                        });
                        context.read<VerifyPhoneCubit>().resendCode(
                          phone: widget.phoneNumber,
                          countryCode: widget.countryCode,
                        );
                      },
                      child: Container(
                        height: 60,
                        width: 140,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isTimerRunning ? AppThemes.greyColor.color : AppThemes.greenColor.color,
                            width: 1.5,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "إعادة إرسال",
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: "Tajawal",
                              fontWeight: FontWeight.bold,
                              color: isTimerRunning ? AppThemes.greyColor.color : AppThemes.greenColor.color,
                            ),
                          ),
                        ),
                      ),
                    ),
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
    );
  }
}