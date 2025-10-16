import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:skydive/core/routes/app_routes_fun.dart';
import 'package:skydive/core/routes/routes.dart';
import 'package:skydive/core/utils/app_theme.dart';
import 'package:skydive/core/utils/extensions.dart';
import 'package:skydive/core/widgets/app_btn.dart';
import 'package:skydive/features/intro/shared_repo/auth_repository.dart';
import '../../../../core/services/server_gate.dart';
import '../../../../core/widgets/app_field.dart';
import '../../../../gen/assets.gen.dart';
import '../cubit/register_cubit.dart';
import '../cubit/register_state.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _cityController = TextEditingController();
  String? _selectedCountryCode = '+966';
  final Logger _logger = Logger();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _logger.d("Initializing Register screen, checking location permission...");
      context.read<RegisterCubit>().checkLocationPermission();
    });
  }

  // الكود الحالي لعرض الدايلوج (بدون تغيير)
  void _showLocationPermissionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("إذن الموقع"),
        content: const Text(
          "هذا التطبيق يحتاج إلى إذن الموقع لتحديد عنوان التسجيل. هل تريد السماح؟",
        ),
        actions: [
          TextButton(
            onPressed: () {
              pushBack();
              context.read<RegisterCubit>().setDefaultLocation();
            },
            child: const Text("إلغاء"),
          ),
          TextButton(
            onPressed: () {
              pushBack();
              context.read<RegisterCubit>().checkLocationPermission();
            },
            child: const Text("السماح"),
          ),
        ],
      ),
    );
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("إذن الموقع مرفوض"),
        content: const Text(
          "هذا التطبيق يحتاج إلى إذن الموقع لتحديد عنوان التسجيل. هل تريد إعادة المحاولة؟",
        ),
        actions: [
          TextButton(
            onPressed: () {
              pushBack();
              context.read<RegisterCubit>().setDefaultLocation();
            },
            child: const Text("إلغاء"),
          ),
          TextButton(
            onPressed: () {
              pushBack();
              context.read<RegisterCubit>().checkLocationPermission();
            },
            child: const Text("إعادة المحاولة"),
          ),
        ],
      ),
    );
  }

  void _showPermissionPermanentlyDeniedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("إذن الموقع مرفوض نهائيًا"),
        content: const Text(
          "تم رفض إذن الموقع بشكل دائم. يرجى تفعيل الإذن من إعدادات الجهاز.",
        ),
        actions: [
          TextButton(
            onPressed: () {
              pushBack();
              context.read<RegisterCubit>().setDefaultLocation();
            },
            child: const Text("إلغاء"),
          ),
          TextButton(
            onPressed: () {
              pushBack();
              openAppSettings();
            },
            child: const Text("فتح الإعدادات"),
          ),
        ],
      ),
    );
  }

  void _showLocationServicesDisabledDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("خدمات الموقع غير مفعلة"),
        content: const Text(
          "يرجى تفعيل خدمات الموقع من إعدادات الجهاز للسماح للتطبيق بالوصول إلى موقعك.",
        ),
        actions: [
          TextButton(
            onPressed: () {
              pushBack();
              context.read<RegisterCubit>().setDefaultLocation();
            },
            child: const Text("إلغاء"),
          ),
          TextButton(
            onPressed: () {
              pushBack();
              Geolocator.openLocationSettings();
            },
            child: const Text("فتح إعدادات الموقع"),
          ),
        ],
      ),
    );
  }

  void _showLocationFetchErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("خطأ في جلب الموقع"),
        content: Text(
          "تعذر جلب الموقع الحالي: $message. هل تريد إعادة المحاولة؟",
        ),
        actions: [
          TextButton(
            onPressed: () {
              pushBack();
              context.read<RegisterCubit>().setDefaultLocation();
            },
            child: const Text("إلغاء"),
          ),
          TextButton(
            onPressed: () {
              pushBack();
              context.read<RegisterCubit>().checkLocationPermission();
            },
            child: const Text("إعادة المحاولة"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterCubit(AuthRepository(ServerGate.i)),
      child: BlocConsumer<RegisterCubit, RegisterState>(
        listener: (context, state) {
          _logger.d("Current state: $state");
          if (state is RegisterSuccess) {
            _logger.d("Register success: ${state.message}");
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
            _logger.d("Navigating to VerifyPhone screen");
            final cleanCountryCode = _selectedCountryCode?.replaceAll('+', '') ?? '966';
            final phoneNumber = _phoneController.text;
            push(
              NamedRoutes.verifyPhone,
              arg: {
                'phoneNumber': phoneNumber,
                'countryCode': _selectedCountryCode,
                'initialDevMessage': state.devMessage,
              },
            );
          } else if (state is RegisterError) {
            _logger.e("Register error: ${state.message}");
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is LocationError) {
            _logger.e("Location error: ${state.message}");
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
            if (state.message.contains("خدمات الموقع غير مفعلة")) {
              _showLocationServicesDisabledDialog();
            } else {
              _showLocationFetchErrorDialog(state.message);
            }
          } else if (state is LocationPermissionDenied) {
            _logger.w("Location permission denied");
            _showPermissionDeniedDialog();
          } else if (state is LocationPermissionPermanentlyDenied) {
            _logger.w("Location permission permanently denied");
            _showPermissionPermanentlyDeniedDialog();
          }
        },
        builder: (context, state) {
          double? latitude;
          double? longitude;
          bool isLoading = state is LocationLoading || state is RegisterLoading;

          if (state is LocationPermissionGranted) {
            latitude = state.latitude;
            longitude = state.longitude;
            _logger.d("Location granted: lat=$latitude, lng=$longitude");
          }

          return Scaffold(
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 16,
                ),
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
                          "يمكنك تسجيل حساب جديد الأن",
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
                              child: AppField(
                                hintText: "اسم المستخدم",
                                prefixIcon: Assets.images.user.image(
                                  width: 20.w,
                                  height: 20.h,
                                ),
                                controller: _usernameController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'الرجاء إدخال اسم المستخدم';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
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
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
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
                                  if (value.length < 9) {
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
                                hintText: "المدينة",
                                prefixIcon: Assets.images.flagIc.image(
                                  width: 20.w,
                                  height: 20.h,
                                ),
                                controller: _cityController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'الرجاء إدخال المدينة';
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
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: AppField(
                                hintText: "تأكيد كلمة المرور",
                                prefixIcon: Assets.images.lock.image(
                                  width: 20.w,
                                  height: 20.h,
                                ),
                                controller: _confirmPasswordController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'الرجاء إدخال تأكيد كلمة المرور';
                                  }
                                  if (value != _passwordController.text) {
                                    return 'كلمة المرور غير متطابقة';
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
                              child: isLoading
                                  ? Center(
                                child: CircularProgressIndicator(
                                  valueColor:
                                  AlwaysStoppedAnimation<Color>(
                                    AppThemes.greenColor.color,
                                  ),
                                ),
                              )
                                  : AppBtn(
                                title: "تسجيل",
                                backgroundColor: AppThemes.greenColor.color,
                                onPressed: () {
                                  _logger.d(
                                      "Register button pressed, validating form...");
                                  if (_formKey.currentState!.validate()) {
                                    _logger.d(
                                        "Form validated, proceeding with registration...");
                                    context.read<RegisterCubit>().registerWithLocation(
                                      fullname: _usernameController.text,
                                      phone: _phoneController.text, // إرسال رقم الهاتف بدون رمز الدولة
                                      password: _passwordController.text,
                                      passwordConfirmation:
                                      _confirmPasswordController.text,
                                      city: _cityController.text,
                                      latitude: latitude,
                                      longitude: longitude,
                                      countryCode: _selectedCountryCode ?? '+966', // تمرير رمز الدولة
                                    );
                                  } else {
                                    _logger.w("Form validation failed");
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05,
                        ),
                        GestureDetector(
                          onTap: () {
                            push(NamedRoutes.login);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "تسجيل دخول ",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: "Tajawal",
                                  fontWeight: FontWeight.bold,
                                  color: AppThemes.greenColor.color,
                                ),
                              ),
                              Text(
                                "لديك حساب بالفعل ؟",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: "Tajawal",
                                  fontWeight: FontWeight.normal,
                                  color: AppThemes.greenColor.color,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _cityController.dispose();
    super.dispose();
  }
}