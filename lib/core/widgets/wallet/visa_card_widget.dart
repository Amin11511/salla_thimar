import 'package:flutter/material.dart';
import 'package:skydive/core/utils/app_theme.dart';
import 'package:skydive/core/utils/extensions.dart';

import '../../../gen/assets.gen.dart';

class VisaCardWidget extends StatelessWidget {
  final String name;
  final String cardNumber;
  final String validDate;
  final bool isSelected;
  final VoidCallback? onDelete;
  final ValueChanged<bool?>? onToggleSelect;
  final double height;

  const VisaCardWidget({
    super.key,
    required this.name,
    required this.cardNumber,
    required this.validDate,
    this.isSelected = false,
    this.onDelete,
    this.onToggleSelect,
    this.height = 0.22, // كنسبة من ارتفاع الشاشة عند الاستخدام داخل MediaQuery
  });

  String _formatCardNumber(String input) {
    // لو المستخدم مرر رقم كامل (أرقام فقط وبطول >= 4) هعرضه كـ "**** **** **** 1234"
    final digitsOnly = input.replaceAll(RegExp(r'\s+'), '');
    if (RegExp(r'^\*').hasMatch(input)) return input; // already masked
    if (RegExp(r'^\d{4,}$').hasMatch(digitsOnly) && digitsOnly.length >= 4) {
      final last4 = digitsOnly.substring(digitsOnly.length - 4);
      return '**** **** **** $last4';
    }
    // وإلا رجع النص كما هو
    return input;
  }

  @override
  Widget build(BuildContext context) {
    final displayedNumber = _formatCardNumber(cardNumber);
    final containerHeight = MediaQuery.of(context).size.height * height;

    return Container(
      width: double.infinity,
      height: containerHeight,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -30,
            bottom: -20,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.09),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            left: -40,
            top: -30,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.09),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            top: 8,
            left: 8,
            child: Image.asset(
              Assets.images.visaWhite.path,
              height: 15,
              width: 45,
              fit: BoxFit.contain,
            ),
          ),
          // ===== Trash & Check Icon =====
          Positioned(
            top: 0,
            right: 0,
            child: Row(
              children: [
                GestureDetector(
                  onTap: onDelete,
                  child: Image.asset(
                    Assets.images.trash.path,
                    width: 24,
                    height: 24,
                    color: AppThemes.whiteColor.color,
                  ),
                ),
                const SizedBox(width: 8),
                Checkbox(
                  value: isSelected,
                  onChanged: onToggleSelect,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  checkColor: Colors.black,
                  activeColor: Colors.white,
                ),
              ],
            ),
          ),

          // ===== Card Details =====
          Positioned(
            left: 16,
            bottom: 50,
            child: Text(
              name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),

          // Card Number
          Positioned(
            left: 16,
            bottom: 20,
            child: Text(
              displayedNumber,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                letterSpacing: 2,
              ),
            ),
          ),

          // Valid Date
          Positioned(
            right: 16,
            bottom: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text(
                  "VALID DATE",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 10,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  validDate,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
