import 'package:flutter/material.dart';
import 'package:skydive/core/utils/extensions.dart';
import '../../../features/home/tabs/my_orders_tab/model/my_orders_tab_model.dart';
import '../../../gen/assets.gen.dart';
import '../../utils/app_theme.dart';

class OrderItem extends StatelessWidget {
  final String status;
  final String orderId;
  final String date;
  final String price;
  final List<ProductModel> products;

  const OrderItem({
    super.key,
    required this.status,
    required this.orderId,
    required this.date,
    required this.price,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // حالة الطلب + كود الطلب
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: AppThemes.lightLightGrey.color,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  status,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontFamily: "Tajawal",
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: AppThemes.greenColor.color,
                  ),
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  Text(
                    "#$orderId",
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      fontFamily: "Tajawal",
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: AppThemes.greenColor.color,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    "طلب",
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      fontFamily: "Tajawal",
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: AppThemes.greenColor.color,
                    ),
                  ),
                ],
              ),
            ],
          ),
          // تاريخ الطلب
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                date,
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  fontFamily: "Tajawal",
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: AppThemes.lightGrey.color,
                ),
              ),
            ],
          ),
          // السعر والأصناف
          Row(
            children: [
              Text(
                "$price ر.س",
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  fontFamily: "Tajawal",
                  fontWeight: FontWeight.normal,
                  fontSize: 18,
                  color: AppThemes.greenColor.color,
                ),
              ),
              const Spacer(),
              Row(
                children: products
                    .map(
                      (product) => Padding(
                    padding: const EdgeInsets.only(left: 4.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppThemes.lightLightGrey.color,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      width: 25,
                      height: 25,
                      child: Image.network(
                        product.url,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Image.asset(
                              Assets.images.tomato.path,
                              fit: BoxFit.cover,
                            ),
                      ),
                    ),
                  ),
                )
                    .toList(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}