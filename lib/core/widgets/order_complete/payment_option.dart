import 'package:flutter/material.dart';
import 'package:skydive/core/utils/extensions.dart';

import '../../utils/app_theme.dart';

class PaymentOption extends StatelessWidget {
  final Widget child;
  final bool isSelected;
  final VoidCallback? onTap; // جعل onTap اختياريًا (nullable)
  final String? disabledMessage; // رسالة اختيارية للحالة المعطلة

  const PaymentOption({
    super.key,
    required this.child,
    required this.isSelected,
    this.onTap,
    this.disabledMessage,
  });

  @override
  Widget build(BuildContext context) {
    final isDisabled = onTap == null; // التحقق مما إذا كان الخيار معطلًا

    return Expanded(
      child: GestureDetector(
        onTap: isDisabled
            ? () {
          if (disabledMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(disabledMessage!),
                duration: const Duration(seconds: 2),
              ),
            );
          }
        }
            : onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? AppThemes.greenColor.color : AppThemes.lightGrey.color,
              width: 2,
            ),
            color: isDisabled ? AppThemes.lightGrey.color.withOpacity(0.5) : null, // خلفية معتمة عند التعطيل
          ),
          height: 60,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Opacity(
              opacity: isDisabled ? 0.5 : 1.0, // تعتيم المحتوى عند التعطيل
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}