import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:skydive/core/utils/extensions.dart';
import '../../../../../core/routes/routes.dart';
import '../../../../../core/utils/app_theme.dart';
import '../../../../../core/widgets/account_tab_widgets/profile_header.dart';
import '../../../../../gen/assets.gen.dart';
import '../cubit/logout_cubit.dart';
import '../cubit/logout_state.dart';
import '../cubit/profile_cubit.dart';
import '../cubit/profile_state.dart';

class AccountTab extends StatefulWidget {
  const AccountTab({super.key});

  @override
  State<AccountTab> createState() => _AccountTabState();
}

class _AccountTabState extends State<AccountTab> {
  final _logger = Logger();
  @override
  void initState() {
    super.initState();
    context.read<ProfileCubit>().fetchProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<LogoutCubit, LogoutState>(
        listener: (context, state) {
          _logger.i('AccountTab: LogoutCubit state = $state');
          if (state is LogoutSuccess) {
            _logger.i('AccountTab: Logout successful, navigating to login...');
            // Navigate to login screen after successful logout
            Navigator.pushReplacementNamed(context, NamedRoutes.login);
          } else if (state is LogoutError) {
            _logger.e('AccountTab: Logout error = ${state.message}');
            // Show error message
            //showCustomMessageDialog(context, state.message);
          }
        },
        child: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            _logger.i('AccountTab: ProfileCubit state = $state');
            if (state is ProfileLoading) {
              return Center(child: CircularProgressIndicator(color: AppThemes.greenColor.color));
            } else if (state is ProfileSuccess) {
              _logger.i('AccountTab: Profile loaded successfully, data = ${state.profileData}');
              final profile = state.profileData;
              return SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.3,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppThemes.greenColor.color,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(32),
                          bottomRight: Radius.circular(32),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(height: 25),
                            Text(
                              "حسابي",
                              textDirection: TextDirection.rtl,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                fontFamily: "Tajawal",
                                color: AppThemes.whiteColor.color,
                              ),
                            ),
                            const SizedBox(height: 20),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: profile.image != null
                                  ? Image.network(
                                profile.image!,
                                width: 75,
                                height: 75,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Image.asset(
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
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              profile.fullname,
                              textDirection: TextDirection.rtl,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                fontFamily: "Tajawal",
                                color: AppThemes.whiteColor.color,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              profile.phone,
                              textDirection: TextDirection.ltr,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                fontFamily: "Tajawal",
                                color: AppThemes.whiteColor.color.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 16),
                      child: Column(
                        children: [
                          //update profile
                          ProfileHeader(
                            title: "البيانات الشخصية",
                            iconPath: Assets.images.profileIc.path,
                            onTab: () {
                              Navigator.pushNamed(context, NamedRoutes.updateProfile);
                            },
                          ),
                          //wallet
                          ProfileHeader(
                            title: "المحفظة",
                            iconPath: Assets.images.wallet.path,
                            onTab: () {
                              Navigator.pushNamed(context, NamedRoutes.wallet);
                            },
                          ),
                          //Addresses
                          ProfileHeader(
                            title: "العناوين",
                            iconPath: Assets.images.address.path,
                            onTab: () {
                              Navigator.pushNamed(context, NamedRoutes.address);
                            },
                          ),
                          //payment
                          ProfileHeader(
                            title: "الدفع",
                            iconPath: Assets.images.pay.path,
                            onTab: () {
                              Navigator.pushNamed(context, NamedRoutes.payment);
                            },
                          ),
                          //FAQs
                          ProfileHeader(
                            title: "أسئلة متكررة",
                            iconPath: Assets.images.question.path,
                            onTab: () {
                              Navigator.pushNamed(context, NamedRoutes.faqs);
                            },
                          ),
                          //Policy
                          ProfileHeader(
                            title: "سياسة الخصوصية",
                            iconPath: Assets.images.check.path,
                            onTab: () {
                              Navigator.pushNamed(context, NamedRoutes.policy);
                            },
                          ),
                          //contact us
                          ProfileHeader(
                            title: "تواصل معنا",
                            iconPath: Assets.images.call.path,
                            onTab: () {
                              Navigator.pushNamed(context, NamedRoutes.contact);
                            },
                          ),
                          // sug & comp
                          ProfileHeader(
                            title: "الشكاوي والأقتراحات",
                            iconPath: Assets.images.info.path,
                            onTab: () {
                              Navigator.pushNamed(context, NamedRoutes.sugAndComp);
                            },
                          ),
                          //share app
                          ProfileHeader(
                            title: "مشاركة التطبيق",
                            iconPath: Assets.images.share.path,
                            onTab: () {},
                          ),
                          //about
                          ProfileHeader(
                            title: "عن التطبيق",
                            iconPath: Assets.images.info.path,
                            onTab: () {
                              Navigator.pushNamed(context, NamedRoutes.about);
                            },
                          ),
                          //change language
                          ProfileHeader(
                            title: "تغيير اللغة",
                            iconPath: Assets.images.edit.path,
                            onTab: () {},
                          ),
                          //roles
                          ProfileHeader(
                            title: "الشروط والأحكام",
                            iconPath: Assets.images.note.path,
                            onTab: () {},
                          ),
                          //rate app
                          ProfileHeader(
                            title: "تقييم التطبيق",
                            iconPath: Assets.images.star.path,
                            onTab: () {},
                          ),
                          const SizedBox(height: 25),
                          GestureDetector(
                            onTap: () {
                              // showCustomConfirmDialog(
                              //   context: context,
                              //   message: "هل تريد تسجيل الخروج؟",
                              //   onConfirm: () {
                              //     context.read<LogoutCubit>().logout();
                              //   },
                              //   onCancel: () {
                              //     Navigator.of(context).pop();
                              //   },
                              // );
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Row(
                                children: [
                                  Text(
                                    "تسجيل الخروج",
                                    textDirection: TextDirection.rtl,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Tajawal",
                                      color: AppThemes.greenColor.color,
                                    ),
                                  ),
                                  Spacer(),
                                  Image(
                                    image: AssetImage(Assets.images.turnOff.path),
                                    width: 24,
                                    height: 24,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            } else if (state is ProfileError) {
              return Center(child: Text(state.message));
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}