import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skydive/features/about/cubit/about_cubit.dart';
import 'package:skydive/features/about/repo/about_service.dart';
import 'package:skydive/features/about/view/about.dart';
import 'package:skydive/features/address/add_address/cubit/add_address_cubit.dart';
import 'package:skydive/features/address/add_address/repo/address_service.dart';
import 'package:skydive/features/address/add_address/view/add_address.dart';
import 'package:skydive/features/address/address/view/address.dart';
import 'package:skydive/features/address/edit_address/view/edit_address.dart';
import 'package:skydive/features/cart/view/cart.dart';
import 'package:skydive/features/category_product_screen/view/category_product_screen.dart';
import 'package:skydive/features/contact_us/cubit/contact_cubit.dart';
import 'package:skydive/features/contact_us/view/contact.dart';
import 'package:skydive/features/faqs/cubit/faqs_cubit.dart';
import 'package:skydive/features/faqs/model/faqs_model.dart';
import 'package:skydive/features/faqs/repo/faqs_service.dart';
import 'package:skydive/features/home/home.dart';
import 'package:skydive/features/home/tabs/account_tab/view/account_tab.dart';
import 'package:skydive/features/home/tabs/favorite_tab/view/favorite_tab.dart';
import 'package:skydive/features/home/tabs/home_tab/view/home_tab.dart';
import 'package:skydive/features/home/tabs/notification_tab/cubit/notification_cubit.dart';
import 'package:skydive/features/home/tabs/notification_tab/repo/notofication_service.dart';
import 'package:skydive/features/home/tabs/notification_tab/view/notification_tab.dart';
import 'package:skydive/features/intro/confirm_phone/view/confirm_phone.dart';
import 'package:skydive/features/intro/forget_password/view/forget_password.dart';
import 'package:skydive/features/intro/login/view/login.dart';
import 'package:skydive/features/intro/register/view/register.dart';
import 'package:skydive/features/order_complete/repo/order_complete_service.dart';
import 'package:skydive/features/order_complete/view/order_complete.dart';
import 'package:skydive/features/order_details_screen/view/order_details_screen.dart';
import 'package:skydive/features/policy/cubit/policy_cubit.dart';
import 'package:skydive/features/policy/repo/policy_service.dart';
import 'package:skydive/features/policy/view/policy.dart';
import 'package:skydive/features/product_details/repo/favorite_service.dart';
import 'package:skydive/features/product_details/repo/product_details_service.dart';
import 'package:skydive/features/product_details/repo/rate_service.dart';
import 'package:skydive/features/product_details/view/product_details.dart';
import 'package:skydive/features/sug_and_comp/cubit/sug_and_comp_cubit.dart';
import 'package:skydive/features/sug_and_comp/repo/sug_and_comp_service.dart';
import 'package:skydive/features/sug_and_comp/view/sug_and_comp.dart';
import 'package:skydive/features/update_profile/cubit/update_profile_cubit.dart';
import 'package:skydive/features/update_profile/repo/update_profile_service.dart';
import 'package:skydive/features/update_profile/view/update_profile.dart';
import 'package:skydive/features/wallet/charge/cubit/charge_cubit.dart';
import 'package:skydive/features/wallet/charge/repo/charge_service.dart';
import 'package:skydive/features/wallet/charge/view/charge.dart';
import 'package:skydive/features/wallet/payment/view/payment.dart';
import 'package:skydive/features/wallet/transaction/view/transaction.dart';
import 'package:skydive/features/wallet/wallet/cubit/wallet_cubit.dart';
import 'package:skydive/features/wallet/wallet/repo/wallet_service.dart';
import 'package:skydive/features/wallet/wallet/view/wallet.dart';
import '../../features/address/address/cubit/address_cubit.dart';
import '../../features/address/address/model/address_model.dart';
import '../../features/address/address/repo/address_service.dart';
import '../../features/cart/cubit/cart_cubit.dart';
import '../../features/cart/repo/cart_service.dart';
import '../../features/contact_us/repo/contact_service.dart';
import '../../features/faqs/view/faqs.dart';
import '../../features/home/tabs/account_tab/cubit/logout_cubit.dart';
import '../../features/home/tabs/account_tab/cubit/profile_cubit.dart';
import '../../features/home/tabs/account_tab/repo/account_tab_repo.dart';
import '../../features/home/tabs/home_tab/cubit/categories_cubit.dart';
import '../../features/home/tabs/home_tab/cubit/home_product_cubit.dart';
import '../../features/home/tabs/home_tab/cubit/slider_cubit.dart';
import '../../features/home/tabs/home_tab/repo/home_service.dart';
import '../../features/home/tabs/my_orders_tab/cubit/my_orders_tab_cubit.dart';
import '../../features/home/tabs/my_orders_tab/repo/my_orders_tab_service.dart';
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
import '../../features/order_complete/cubit/order_complete_cubit.dart';
import '../../features/product_details/cubit/favorite_cubit.dart';
import '../../features/product_details/cubit/product_details_cubit.dart';
import '../../features/product_details/cubit/rate_cubit.dart';
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
    NamedRoutes.homeTab: (context) => const HomeTab(),
    NamedRoutes.notificationTab: (context) =>  BlocProvider(
      create: (context) => NotificationCubit(NotificationService(ServerGate.i)),
      child: const NotificationTab(),
    ),
    NamedRoutes.myOrdersTab: (c) => BlocProvider(
      create: (context) => OrdersCubit(context.read<MyOrdersService>())..fetchOrders(),
      child: const MyOrdersTab(),
    ),
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
    NamedRoutes.favoriteTab: (context) => BlocProvider(
        create: (context) => CartCubit(CartService(ServerGate.i)),
      child: FavoriteTab(),
    ),
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
    NamedRoutes.about: (context) => BlocProvider(
      create: (context) => AboutCubit(AboutService(ServerGate.i)),
      child: const About(),
    ),
    NamedRoutes.contact: (context) => BlocProvider(
      create: (context) => ContactCubit(ContactService(ServerGate.i)),
      child: Contact(),
    ),
    NamedRoutes.faqs: (contact) => BlocProvider(
        create: (context) => FaqsCubit(FaqsService(ServerGate.i)),
      child: const Faqs(),
    ),
    NamedRoutes.address: (context) => BlocProvider(
      create: (context) => CurrentAddressesCubit(CurrentAddressesService(ServerGate.i)),
      child: const Address(),
    ),
    NamedRoutes.addAddress: (context) {
      final args = ModalRoute.of(context)?.settings.arguments;
      CurrentAddressesCubit? currentCubit;
      if (args != null && args is CurrentAddressesCubit) {
        currentCubit = args;
      }
      return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AddressCubit(AddressService(ServerGate.i)),
          ),
          if (currentCubit != null)
            BlocProvider.value(value: currentCubit!)
          else
            BlocProvider(
              create: (context) => CurrentAddressesCubit(CurrentAddressesService(ServerGate.i)),
            ),
        ],
        child: const AddAddress(),
      );
    },
    NamedRoutes.editAddress: (context) {
      final CurrentAddressesModel address =
      ModalRoute.of(context)!.settings.arguments as CurrentAddressesModel;
      return EditAddress(address: address);
    },
    NamedRoutes.wallet: (context) => BlocProvider(
        create: (context) => WalletCubit(WalletService(ServerGate.i)),
      child: const Wallet(),
    ),
    NamedRoutes.charge: (context) => BlocProvider(
        create: (context) => WalletChargeCubit(WalletChargeService(ServerGate.i)),
      child: const Charge(),
    ),
    NamedRoutes.payment: (c) => Payment(),
    NamedRoutes.transaction: (context) => BlocProvider(
        create: (context) => WalletCubit(WalletService(ServerGate.i)),
      child: const Transaction(),
    ),
    NamedRoutes.policy: (context) => BlocProvider(
        create: (context) => PolicyCubit(PolicyService(ServerGate.i)),
      child: const Policy(),
    ),
    NamedRoutes.sugAndComp: (context) => BlocProvider(
        create: (context) => SugAndCompCubit(SugAndCompService(ServerGate.i)),
      child: const SugAndComp(),
    ),
    NamedRoutes.updateProfile: (context) => MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => UpdateProfileCubit(UpdateProfileService(ServerGate.i)),
        ),
        BlocProvider(
          create: (context) => ProfileCubit(ProfileService(ServerGate.i))..fetchProfile(),
        ),
      ],
      child: const UpdateProfile(),
    ),
    NamedRoutes.cart: (context) => BlocProvider(
      create: (context) => CartCubit(CartService(ServerGate.i)),
      child: const Cart(),
    ),
    NamedRoutes.orderComplete: (context) {
      final args =
      ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

      return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => OrderCubit(OrderService(ServerGate.i)),
          ),
          BlocProvider(
            create: (context) => CurrentAddressesCubit(CurrentAddressesService(ServerGate.i)),
          ),
        ],
        child: OrderComplete(cartData: args),
      );
    },
    NamedRoutes.categoryProduct: (context) {
      final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      final int categoryId = args['categoryId'];
      final String categoryName = args['categoryName'];

      return BlocProvider(
        create: (context) => CartCubit(CartService(ServerGate.i)),
        child: CategoryProductsScreen(
          categoryId: categoryId,
          categoryName: categoryName,
        ),
      );
    },
    NamedRoutes.productDetails: (context) {
      final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      final int productId = args['productId'];

      return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => ProductDetailsCubit(ProductService(ServerGate.i)),
          ),
          BlocProvider(
            create: (context) => RateCubit(RateService(ServerGate.i)),
          ),
          BlocProvider(
            create: (context) => FavoriteCubit(FavoriteService()),
          ),
          BlocProvider(
            create: (context) => CartCubit(CartService(ServerGate.i)),
          ),
        ],
        child: ProductDetails(productId: productId),
      );
    },
    NamedRoutes.orderDetails: (context)  {
      final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      final int orderId = args['orderId'];

      return OrderDetailsScreen(orderId: orderId);
    },
  };
}
