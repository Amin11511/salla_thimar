import 'package:flutter/material.dart';
import 'package:skydive/core/utils/extensions.dart';

import '../../../gen/assets.gen.dart';
import '../../utils/app_theme.dart';

class TransactionCard extends StatelessWidget {
  final String date;
  final String title;
  final String amount;
  final bool isIncome;

  const TransactionCard({
    super.key,
    required this.date,
    required this.title,
    required this.amount,
    this.isIncome = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                date,
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  fontFamily: "Tajawal",
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: AppThemes.lightGrey.color,
                ),
              ),
              const Spacer(),
              Text(
                title,
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  fontFamily: "Tajawal",
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isIncome ? AppThemes.greenColor.color : Colors.red,
                ),
              ),
              const SizedBox(width: 10),
              Image.asset(
                isIncome ? Assets.images.arrowDown.path : Assets.images.arrowUp.path,
                width: 18,
                height: 18,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Spacer(),
              Text(
                amount,
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  fontFamily: "Tajawal",
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: isIncome ? AppThemes.greenColor.color : Colors.red,
                ),
              ),
              const SizedBox(width: 30),
            ],
          )
        ],
      ),
    );
  }
}
