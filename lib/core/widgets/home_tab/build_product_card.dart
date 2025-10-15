import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skydive/core/utils/extensions.dart';

import '../../../features/cart/cubit/cart_cubit.dart';
import '../../../features/cart/cubit/cart_state.dart';
import '../../utils/app_theme.dart';

class BuildProductCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String price;
  final String oldPrice;
  final String discount;
  final int productId;

  const BuildProductCard({
    super.key,
    required this.imagePath,
    required this.title,
    required this.price,
    required this.oldPrice,
    required this.discount,
    required this.productId,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    imagePath,
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 120,
                        width: double.infinity,
                        color: Colors.white,
                      );
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        height: 120,
                        width: double.infinity,
                        color: Colors.white,
                        child: Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(AppThemes.greenColor.color),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                child: Container(
                  width: 55,
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppThemes.greenColor.color,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      bottomRight: Radius.circular(12),
                    ),
                  ),
                  child: Text(
                    discount,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Tajawal",
                    color: AppThemes.greenColor.color,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "السعر / 1كجم",
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: "Tajawal",
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: AppThemes.greenColor.color,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  width: 30,
                  height: 30,
                  child: const Icon(Icons.add, color: Colors.white, size: 18),
                ),
                const Spacer(),
                Column(
                  children: [
                    Text(
                      price,
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: "Tajawal",
                        fontWeight: FontWeight.bold,
                        color: AppThemes.greenColor.color,
                      ),
                    ),
                    Text(
                      oldPrice,
                      textDirection: TextDirection.rtl,
                      style: const TextStyle(
                        fontSize: 14,
                        fontFamily: "Tajawal",
                        color: Colors.grey,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: BlocBuilder<CartCubit, CartState>(
              buildWhen: (previous, current) =>
              (previous.loadingProductIds?.contains(productId) ?? false) !=
                  (current.loadingProductIds?.contains(productId) ?? false),
              builder: (context, cartState) {
                bool isLoading = cartState.loadingProductIds?.contains(productId) ?? false;
                return SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : () {
                      context.read<CartCubit>().addToCart(productId, 1);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppThemes.greenColor.color,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: isLoading
                        ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                        : const Text(
                      "أضف للسلة",
                      style: TextStyle(
                        fontFamily: "Tajawal",
                        color: Colors.white,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}