import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skydive/core/utils/extensions.dart';
import '../../../features/cart/cubit/cart_cubit.dart';
import '../../../features/cart/cubit/cart_state.dart';
import '../../utils/app_theme.dart';

class ProductItem extends StatelessWidget {
  final int id;
  final String name;
  final String price;
  final String image;
  final int quantity;
  final VoidCallback? onDelete;
  final VoidCallback? onIncrease;
  final VoidCallback? onDecrease;

  const ProductItem({
    super.key,
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    required this.quantity,
    this.onDelete,
    this.onIncrease,
    this.onDecrease,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          // صورة المنتج
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              image,
              width: 90,
              height: 80,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
            ),
          ),
          // النصوص + الكمية
          Column(
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  fontFamily: "Tajawal",
                  color: Colors.green,
                ),
              ),
              Text(
                price,
                textDirection: TextDirection.rtl,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  fontFamily: "Tajawal",
                  color: Colors.green,
                ),
              ),
              // الكمية
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // زر النقصان
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: GestureDetector(
                              onTap: onDecrease,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.remove,
                                  color: Colors.green,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 4),
                          // النص (الكمية)
                          Text(
                            "$quantity",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.green,
                              fontFamily: "Tajawal",
                            ),
                          ),
                          const SizedBox(width: 4),
                          // زر الزيادة
                          Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: GestureDetector(
                              onTap: onIncrease,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.add,
                                  color: Colors.green,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Spacer(),
          // زر الحذف
          BlocBuilder<CartCubit, CartState>(
            buildWhen: (previous, current) =>
            (previous.loadingProductIds?.contains(id) ?? false) !=
                (current.loadingProductIds?.contains(id) ?? false),
            builder: (context, state) {
              bool isLoading = state.loadingProductIds?.contains(id) ?? false;
              print('Delete button - isLoading: $isLoading');
              return GestureDetector(
                onTap: isLoading ? null : onDelete,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppThemes.lightRed.color,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: isLoading
                        ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.red,
                        strokeWidth: 2,
                      ),
                    )
                        : const Icon(Icons.delete, color: Colors.red),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}