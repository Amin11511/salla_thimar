import 'dart:io';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:skydive/core/utils/extensions.dart';
import '../../../core/utils/app_theme.dart';
import '../../../core/widgets/app_btn.dart';
import '../../../core/widgets/app_field.dart';
import '../../../core/widgets/custom_app_bar/custom_app_bar.dart';
import '../../../gen/assets.gen.dart';
import '../../home/tabs/account_tab/cubit/profile_cubit.dart';
import '../../home/tabs/account_tab/cubit/profile_state.dart';
import '../../home/tabs/account_tab/model/profile_model.dart';
import '../cubit/update_profile_cubit.dart';
import '../cubit/update_profile_state.dart';

class UpdateProfile extends StatefulWidget {
  const UpdateProfile({super.key});

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  String? _selectedCountryCode = '+966';
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _fullnameController;
  late TextEditingController _phoneController;
  late TextEditingController _cityController;
  late TextEditingController _passwordController;
  late TextEditingController _passwordConfirmationController;
  String? _imagePath;

  @override
  void initState() {
    super.initState();
    final profileState = context.read<ProfileCubit>().state;
    if (profileState is ProfileSuccess) {
      final profile = profileState.profileData;
      _fullnameController = TextEditingController(text: profile.fullname);
      _phoneController = TextEditingController(text: profile.phone.replaceFirst('966', ''));
      _cityController = TextEditingController(text: 'جدة');
      _passwordController = TextEditingController();
      _passwordConfirmationController = TextEditingController();
    } else {
      _fullnameController = TextEditingController();
      _phoneController = TextEditingController();
      _cityController = TextEditingController(text: 'جدة');
      _passwordController = TextEditingController();
      _passwordConfirmationController = TextEditingController();
    }
  }

  @override
  void dispose() {
    _fullnameController.dispose();
    _phoneController.dispose();
    _cityController.dispose();
    _passwordController.dispose();
    _passwordConfirmationController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    // طلب إذن الوصول إلى الجاليري
    final status = await Permission.photos.request();
    if (status.isGranted) {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _imagePath = pickedFile.path;
        });
        print('Image selected: ${_imagePath}'); // للتحقق
      } else {
        print('No image selected');
      }
    } else if (status.isDenied || status.isPermanentlyDenied) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'يرجى منح إذن الوصول إلى الجاليري',
            textDirection: TextDirection.rtl,
            style: TextStyle(fontFamily: 'Tajawal'),
          ),
          backgroundColor: Colors.red,
        ),
      );
      if (status.isPermanentlyDenied) {
        openAppSettings(); // فتح إعدادات التطبيق إذا تم رفض الإذن نهائيًا
      }
    }
  }

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: AppThemes.greenColor.color, width: 1),
        ),
        title: Text(
          'هل تريد حفظ البيانات؟',
          textDirection: TextDirection.rtl,
          style: TextStyle(
            fontFamily: 'Tajawal',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppThemes.greenColor.color,
          ),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actionsPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              side: BorderSide(color: AppThemes.greenColor.color),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            ),
            child: Text(
              'لا',
              style: TextStyle(
                fontFamily: 'Tajawal',
                color: AppThemes.greenColor.color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showPasswordConfirmationDialog(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppThemes.greenColor.color, // ✅ زر أخضر
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            ),
            child: const Text(
              'نعم',
              style: TextStyle(
                fontFamily: 'Tajawal',
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showPasswordConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Text(
          'تأكيد كلمة المرور',
          textDirection: TextDirection.rtl,
          style: TextStyle(
            fontFamily: 'Tajawal',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppThemes.greenColor.color,
          ),
        ),
        content: AppField(
          hintText: 'تأكيد كلمة المرور',
          prefixIcon: Assets.images.lock.image(width: 20.w, height: 20.h,),
          controller: _passwordConfirmationController,
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
        actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        actionsAlignment: MainAxisAlignment.spaceBetween,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(
              foregroundColor: AppThemes.greenColor.color,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'إلغاء',
              style: TextStyle(
                fontFamily: 'Tajawal',
                fontSize: 16,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                context.read<UpdateProfileCubit>().updateProfile(
                  fullname: _fullnameController.text,
                  phone: _phoneController.text,
                  cityId: 7,
                  password: _passwordController.text.isNotEmpty ? _passwordController.text : null,
                  passwordConfirmation: _passwordConfirmationController.text.isNotEmpty ? _passwordConfirmationController.text : null,
                  imagePath: _imagePath,
                );
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppThemes.greenColor.color,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'تأكيد',
              style: TextStyle(
                fontFamily: 'Tajawal',
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),

    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "البيانات الشخصية",
        onBackPressed: () {
          Navigator.pop(context);
        },
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
          child: BlocConsumer<UpdateProfileCubit, UpdateProfileState>(
            listener: (context, state) {
              if (state is UpdateProfileSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      state.response.message,
                      textDirection: TextDirection.rtl,
                      style: const TextStyle(fontFamily: 'Tajawal'),
                    ),
                    backgroundColor: AppThemes.greenColor.color,
                  ),
                );
                Navigator.pop(context);
              } else if (state is UpdateProfileError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      state.message,
                      textDirection: TextDirection.rtl,
                      style: const TextStyle(fontFamily: 'Tajawal'),
                    ),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            builder: (context, state) {
              if (state is UpdateProfileLoading) {
                return Center(child: CircularProgressIndicator(color: AppThemes.greenColor.color));
              }
              return Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      BlocBuilder<ProfileCubit, ProfileState>(
                        builder: (context, profileState) {
                          ProfileData? profile;
                          if (profileState is ProfileSuccess) {
                            profile = profileState.profileData;
                          }
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  print('Image tapped'); // للتحقق من النقر
                                  _pickImage();
                                },
                                child: Container(
                                  width: 75,
                                  height: 75,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: AppThemes.lightGrey.color, width: 2),
                                  ),
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(6),
                                        child: _imagePath != null
                                            ? Image.file(
                                          File(_imagePath!),
                                          width: 75,
                                          height: 75,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) => Image.asset(
                                            Assets.images.profile.path,
                                            width: 75,
                                            height: 75,
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                            : (profile?.image != null
                                            ? Image.network(
                                          profile!.image!,
                                          width: 75,
                                          height: 75,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) => Image.asset(
                                            Assets.images.profile.path,
                                            width: 75,
                                            height: 75,
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                            : Image.asset(
                                          Assets.images.profile.path,
                                          width: 75,
                                          height: 75,
                                          fit: BoxFit.cover,
                                        )),
                                      ),
                                      // Overlay للدلالة على الاختيار
                                      Container(
                                        width: 75,
                                        height: 75,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(6),
                                          color: Colors.black.withOpacity(0.4),
                                        ),
                                        child: const Icon(
                                          Icons.camera_alt,
                                          color: Colors.white,
                                          size: 30,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                profile?.fullname ?? 'محمد علي',
                                textDirection: TextDirection.rtl,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Tajawal",
                                  color: AppThemes.greenColor.color,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                '${_selectedCountryCode ?? '+966'}${_phoneController.text}',
                                textDirection: TextDirection.ltr,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Tajawal",
                                  color: AppThemes.lightGrey.color,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      // باقي الحقول (اسم المستخدم، رقم الجوال، المدينة، كلمة المرور، زر التعديل)
                      Row(
                        children: [
                          Expanded(
                            child: AppField(
                              hintText: "اسم المستخدم",
                              suffixIcon: Assets.images.profileIc.image(width: 20.w, height: 20.h),
                              controller: _fullnameController,
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
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            flex: 8,
                            child: AppField(
                              hintText: "رقم الجوال",
                              suffixIcon: Assets.images.profileIc.image(width: 20.w, height: 20.h),
                              controller: _phoneController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'الرجاء إدخال رقم الجوال';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
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
                                favorite: const ['+966', 'SA'],
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
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: AppField(
                              hintText: "المدينة",
                              suffixIcon: Assets.images.flagIc.image(width: 20.w, height: 20.h),
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
                      Row(
                        children: [
                          Expanded(
                            child: AppField(
                              hintText: "كلمة المرور",
                              suffixIcon: Assets.images.lock.image(width: 20.w, height: 20.h),
                              controller: _passwordController,
                              validator: (value) {
                                if (value != null && value.isNotEmpty && value.length < 6) {
                                  return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.25),
                      Row(
                        children: [
                          Expanded(
                            child: AppBtn(
                              title: "تعديل البيانات",
                              backgroundColor: AppThemes.greenColor.color,
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  _showConfirmationDialog(context);
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}