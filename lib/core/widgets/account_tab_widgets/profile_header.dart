import 'package:flutter/material.dart';
import 'package:skydive/core/utils/extensions.dart';
import '../../utils/app_theme.dart';

class ProfileHeader extends StatelessWidget {
  final String title;
  final String? iconPath;
  final VoidCallback? onTab;

  const ProfileHeader({
    super.key,
    required this.title,
    this.iconPath,
    this.onTab,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: GestureDetector(
        onTap: onTab,
        child: Row(
          children: [
            if (iconPath != null)
              Image.asset(
                iconPath!,
                width: 24,
                height: 24,
              ),
            const SizedBox(width: 10),
            Text(
              title,
              textDirection: TextDirection.rtl,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: "Tajawal",
                color: AppThemes.greenColor.color,
              ),
            ),
            const Spacer(),
            Icon(
              Icons.arrow_circle_left_outlined,
              color: AppThemes.lightGrey.color,
            ),
          ],
        ),
      ),
    );
  }
}
