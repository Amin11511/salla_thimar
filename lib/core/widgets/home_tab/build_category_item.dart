import 'package:flutter/material.dart';
import 'package:skydive/core/utils/extensions.dart';

import '../../utils/app_theme.dart';

class BuildCategoryItem extends StatelessWidget {
  final String imagePath;
  final String title;
  final Color containerColor;
  final VoidCallback onTap;

  const BuildCategoryItem({
    Key? key,
    required this.imagePath,
    required this.title,
    required this.containerColor,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 75,
            height: 75,
            margin: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  containerColor.withOpacity(0.3),
                  containerColor.withOpacity(0.9),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    imagePath,
                    height: 45,
                    width: 45,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      }
                      return Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(AppThemes.greenColor.color),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      print('Category image error: $error, URL: $imagePath');
                      return const Icon(
                        Icons.error,
                        size: 45,
                        color: Colors.red,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Tajawal',
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}