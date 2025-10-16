import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skydive/core/utils/extensions.dart';
import 'package:skydive/features/home/tabs/account_tab/cubit/logout_cubit.dart';
import 'package:skydive/features/home/tabs/account_tab/cubit/profile_cubit.dart';
import 'package:skydive/features/home/tabs/account_tab/repo/account_tab_repo.dart';
import 'package:skydive/features/home/tabs/account_tab/view/account_tab.dart';
import 'package:skydive/features/home/tabs/favorite_tab/cubit/favorite_tab_cubit.dart';
import 'package:skydive/features/home/tabs/favorite_tab/repo/favorite_tab_service.dart';
import 'package:skydive/features/home/tabs/favorite_tab/view/favorite_tab.dart';
import 'package:skydive/features/home/tabs/home_tab/view/home_tab.dart';
import 'package:skydive/features/home/tabs/my_orders_tab/cubit/my_orders_tab_cubit.dart';
import 'package:skydive/features/home/tabs/my_orders_tab/repo/my_orders_tab_service.dart';
import 'package:skydive/features/home/tabs/my_orders_tab/view/my_orders_tab.dart';
import 'package:skydive/features/home/tabs/notification_tab/view/notification_tab.dart';
import '../../core/services/server_gate.dart';
import '../../core/utils/app_theme.dart';
import '../../gen/assets.gen.dart';

class Home extends StatefulWidget {
  final int initialIndex;
  final Map<String, dynamic>? arguments;

  const Home({super.key, this.initialIndex = 0, this.arguments});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late int selectedIndex;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.initialIndex;
  }

  List<Widget> get tabs => [
    HomeTab(),
    BlocProvider(
      create: (context) => OrdersCubit(MyOrdersService(ServerGate.i),)..fetchOrders(),
      child: MyOrdersTab(),
    ),
    const NotificationTab(),
    BlocProvider(
      create: (context) => FavoriteTabCubit(FavoriteTabService(ServerGate.i))..fetchFavoriteProducts(),
      child: const FavoriteTab(),
    ),
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => ProfileCubit(ProfileService(ServerGate.i)),
        ),
        BlocProvider(
          create: (_) => LogoutCubit(ProfileService(ServerGate.i)),
        ),
      ],
      child: AccountTab(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabs[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppThemes.greenColor.color,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppThemes.whiteColor.color,
        unselectedItemColor: AppThemes.whiteColor.color,
        iconSize: 25,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedLabelStyle: TextStyle(
          fontFamily: 'Tajawal',
          fontWeight: FontWeight.bold,
          fontSize: 14,
          color: AppThemes.whiteColor.color,
        ),
        unselectedLabelStyle: TextStyle(
          fontFamily: 'Tajawal',
          fontWeight: FontWeight.normal,
          fontSize: 14,
          color: AppThemes.whiteColor.color,
        ),
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        currentIndex: selectedIndex,
        items: [
          BottomNavigationBarItem(
            icon: buildBottomNavigationBarIcon(Assets.images.home.path, selectedIndex == 0),
            label: 'الرئيسية',
          ),
          BottomNavigationBarItem(
            icon: buildBottomNavigationBarIcon(Assets.images.myOrders.path, selectedIndex == 1),
            label: 'طلباتي',
          ),
          BottomNavigationBarItem(
            icon: buildBottomNavigationBarIcon(Assets.images.notification.path, selectedIndex == 2),
            label: 'الإشعارات',
          ),
          BottomNavigationBarItem(
            icon: buildBottomNavigationBarIcon(Assets.images.favorite.path, selectedIndex == 3),
            label: 'المفضلة',
          ),
          BottomNavigationBarItem(
            icon: buildBottomNavigationBarIcon(Assets.images.account.path, selectedIndex == 4),
            label: 'حسابي',
          ),
        ],
      ),
    );
  }

  Widget buildBottomNavigationBarIcon(String icon, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ImageIcon(
        AssetImage(icon),
        color: isSelected ? AppThemes.whiteColor.color : AppThemes.whiteColor.color.withOpacity(0.7),
      ),
    );
  }
}