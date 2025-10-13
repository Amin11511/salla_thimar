import 'package:flutter/material.dart';
import 'package:skydive/core/utils/extensions.dart';
import '../../utils/app_theme.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback onBackPressed;

  const CustomAppBar({
    super.key,
    required this.title,
    required this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppThemes.whiteColor.color,
      centerTitle: true,
      automaticallyImplyLeading: false,
      title: Text(
        title,
        style: TextStyle(
          fontFamily: "Tajawal",
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppThemes.greenColor.color,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Container(
            decoration: BoxDecoration(
              color: AppThemes.lightLightGrey.color,
              borderRadius: BorderRadius.circular(16),
            ),
            width: 48,
            height: 48,
            child: IconButton(
              icon: Icon(
                Icons.arrow_forward_ios,
                color: AppThemes.greenColor.color,
              ),
              onPressed: onBackPressed,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}