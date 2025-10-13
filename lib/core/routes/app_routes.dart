import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skydive/features/about/view/about.dart';
import 'package:skydive/features/address/add_address/view/add_address.dart';
import 'package:skydive/features/address/address/view/address.dart';
import 'package:skydive/features/address/edit_address/view/edit_address.dart';
import 'package:skydive/features/contact_us/view/contact.dart';
import 'package:skydive/features/home/home.dart';
import 'package:skydive/features/home/tabs/account_tab/view/account_tab.dart';
import 'package:skydive/features/home/tabs/favorite_tab/view/favorite_tab.dart';
import 'package:skydive/features/home/tabs/home_tab/view/home_tab.dart';
import 'package:skydive/features/home/tabs/notification_tab/view/notification_tab.dart';
import 'package:skydive/features/intro/confirm_phone/view/confirm_phone.dart';
import 'package:skydive/features/intro/forget_password/view/forget_password.dart';
import 'package:skydive/features/intro/login/view/login.dart';
import 'package:skydive/features/intro/register/view/register.dart';
import 'package:skydive/features/policy/view/policy.dart';
import 'package:skydive/features/sug_and_comp/view/sug_and_comp.dart';
import 'package:skydive/features/update_profile/view/update_profile.dart';
import 'package:skydive/features/wallet/charge/view/charge.dart';
import 'package:skydive/features/wallet/payment/view/payment.dart';
import 'package:skydive/features/wallet/transaction/view/transaction.dart';
import 'package:skydive/features/wallet/wallet/view/wallet.dart';
import '../../features/address/address/model/address_model.dart';
import '../../features/faqs/view/faqs.dart';
import '../../features/home/tabs/account_tab/cubit/logout_cubit.dart';
import '../../features/home/tabs/account_tab/cubit/profile_cubit.dart';
import '../../features/home/tabs/account_tab/repo/account_tab_repo.dart';
import '../../features/home/tabs/my_orders_tab/view/my_orders_tab.dart';
import '../../features/intro/confirm_password/cubit/confirm_password_cubit.dart';
import '../../features/intro/confirm_password/view/confirm_password.dart';
import '../../features/intro/confirm_phone/cubit/confirm_phone_cubit.dart';
import '../../features/intro/register/cubit/register_cubit.dart';
import '../../features/intro/shared_repo/auth_repository.dart';
import '../../features/intro/splash/logic/splash_cubit.dart';
import '../../features/intro/splash/view/splash_view.dart';
import '../../features/intro/verify_phone/cubit/verify_phone_cubit.dart';
import '../../features/intro/verify_phone/view/verify_phone.dart';
import '../services/server_gate.dart';
import 'routes.dart';

class AppRoutes {
  static AppRoutes get init => AppRoutes._internal();
  String initial = NamedRoutes.splash;
  AppRoutes._internal();
  Map<String, Widget Function(BuildContext)> appRoutes = {
    NamedRoutes.splash: (context) => BlocProvider(
      create: (_) => SplashCubit(),
      child: const SplashView(),
    ),
    NamedRoutes.login: (c) => const Login(),
    NamedRoutes.home: (c) => const Home(),
    NamedRoutes.homeTab: (c) => const HomeTab(),
    NamedRoutes.notificationTab: (c) => const NotificationTab(),
    NamedRoutes.myOrdersTab: (c) => const MyOrdersTab(),
    NamedRoutes.accountTab: (context) => MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => ProfileCubit(ProfileService(ServerGate.i)),
        ),
        BlocProvider(
          create: (_) => LogoutCubit(ProfileService(ServerGate.i)),
        ),
      ],
      child: const AccountTab(),
    ),
    NamedRoutes.favoriteTab: (c) => const FavoriteTab(),
    NamedRoutes.register: (context) => BlocProvider(
      create: (context) => RegisterCubit(AuthRepository(ServerGate.i)),
      child: const Register(),
    ),
    NamedRoutes.verifyPhone: (context) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      final phoneNumber = args?['phoneNumber'] as String? ?? '';
      final countryCode = args?['countryCode'] as String?;
      final initialDevMessage = args?['initialDevMessage'] as int?;
      return BlocProvider(
        create: (context) => VerifyPhoneCubit(
          AuthRepository(ServerGate.i),
          devMessage: initialDevMessage,
        ),
        child: VerifyPhone(
          phoneNumber: phoneNumber,
          countryCode: countryCode,
          initialDevMessage: initialDevMessage,
        ),
      );
    },
    NamedRoutes.forgetPassword: (c) => const ForgetPassword(),
    NamedRoutes.confirmPhone: (context) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      final phoneNumber = args?['phoneNumber'] as String? ?? '';
      final countryCode = args?['countryCode'] as String?;
      return BlocProvider(
        create: (context) => ConfirmPhoneCubit(AuthRepository(ServerGate.i)),
        child: ConfirmPhone(
          phoneNumber: phoneNumber,
          countryCode: countryCode,
        ),
      );
    },
    NamedRoutes.confirmPassword: (context) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      final phone = args?['phone'] as String? ?? '';
      final code = args?['code'] as String? ?? '';
      return BlocProvider(
        create: (context) => ConfirmPasswordCubit(AuthRepository(ServerGate.i)),
        child: ConfirmPassword(
          phone: phone,
          code: code,
        ),
      );
    },
    NamedRoutes.about: (c) => const About(),
    NamedRoutes.contact: (c) => Contact(),
    NamedRoutes.faqs: (c) => Faqs(),
    NamedRoutes.address: (c) => Address(),
    NamedRoutes.addAddress: (c) => AddAddress(),
    NamedRoutes.editAddress: (context) {
      final CurrentAddressesModel address =
      ModalRoute.of(context)!.settings.arguments as CurrentAddressesModel;
      return EditAddress(address: address);
    },
    NamedRoutes.wallet: (c) => Wallet(),
    NamedRoutes.charge: (c) => Charge(),
    NamedRoutes.payment: (c) => Payment(),
    NamedRoutes.transaction: (c) => Transaction(),
    NamedRoutes.policy: (c) => Policy(),
    NamedRoutes.sugAndComp: (c) => SugAndComp(),
    NamedRoutes.updateProfile: (c) => UpdateProfile(),
  };
}
