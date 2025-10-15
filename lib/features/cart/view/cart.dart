import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skydive/core/utils/extensions.dart';
import '../../../core/routes/routes.dart';
import '../../../core/utils/app_theme.dart';
import '../../../core/widgets/app_field.dart';
import '../../../core/widgets/cart/product_item.dart';
import '../../../core/widgets/custom_app_bar/custom_app_bar.dart';
import '../cubit/cart_cubit.dart';
import '../cubit/cart_state.dart';
import '../model/product_cart_model.dart';

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  GetCartResponse? lastCartResponse;
  final TextEditingController _couponController = TextEditingController();
  String? _couponError;

  @override
  void initState() {
    super.initState();
    context.read<CartCubit>().fetchCart();
  }

  @override
  void dispose() {
    _couponController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: "السلة",
        onBackPressed: () {
          Navigator.pop(context);
        },
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: BlocListener<CartCubit, CartState>(
            listener: (context, state) {
              if (state is CartCouponError) {
                setState(() {
                  _couponError = state.message;
                });
              } else if (state is CartSuccess && state.message != 'تم الحذف من السلة بنجاح') {
                setState(() {
                  _couponError = null;
                });
                //showCustomMessageDialog(context, state.message);
              } else if (state is CartError) {
                //showCustomMessageDialog(context, 'خطأ: ${state.message}');
              } else if (state is CartLoaded) {
                setState(() {
                  _couponError = null;
                });
              }
            },
            child: BlocBuilder<CartCubit, CartState>(
              buildWhen: (previous, current) {
                if (current is CartLoaded) {
                  lastCartResponse = current.cartResponse;
                }
                if (current is CartLoading && (current.loadingProductIds?.isNotEmpty ?? false)) {
                  return false;
                }
                if (current is CartSuccess || current is CartCouponError) {
                  return false;
                }
                if (previous is CartLoaded && current is CartLoaded) {
                  return previous.cartResponse.data.length != current.cartResponse.data.length ||
                      previous.cartResponse.totalPriceBeforeDiscount != current.cartResponse.totalPriceBeforeDiscount ||
                      previous.cartResponse.totalDiscount != current.cartResponse.totalDiscount ||
                      previous.cartResponse.totalPriceWithVat != current.cartResponse.totalPriceWithVat ||
                      previous.cartResponse.deliveryCost != current.cartResponse.deliveryCost ||
                      previous.cartResponse.freeDeliveryPrice != current.cartResponse.freeDeliveryPrice ||
                      previous.cartResponse.vat != current.cartResponse.vat ||
                      previous.cartResponse.isVip != current.cartResponse.isVip ||
                      previous.cartResponse.vipDiscountPercentage != current.cartResponse.vipDiscountPercentage ||
                      previous.cartResponse.minVipPrice != current.cartResponse.minVipPrice ||
                      previous.cartResponse.vipMessage != current.cartResponse.vipMessage;
                }
                return true;
              },
              builder: (context, state) {
                print('BlocBuilder received state: ${state.runtimeType} - Data length: ${state is CartLoaded ? state.cartResponse.data.length : 'N/A'}');
                if (state is CartLoading && (state.loadingProductIds?.isEmpty ?? true)) {
                  return Center(child: CircularProgressIndicator(color: AppThemes.greenColor.color));
                } else if (state is CartError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('خطأ: ${state.message}'),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => context.read<CartCubit>().fetchCart(),
                          child: const Text('إعادة المحاولة'),
                        ),
                      ],
                    ),
                  );
                } else {
                  final cart = state is CartLoaded ? state.cartResponse : lastCartResponse;
                  if (cart == null || cart.data.isEmpty) {
                    return Center(
                      child: Text(
                        'السلة فارغة',
                        style: TextStyle(
                          fontFamily: "Tajawal",
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppThemes.greenColor.color,
                        ),
                      ),
                    );
                  }
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: cart.data.length,
                          itemBuilder: (context, index) {
                            final item = cart.data[index];
                            return ProductItem(
                              id: item.id,
                              name: item.title,
                              price: '${item.price} ر.س',
                              image: item.image,
                              quantity: item.amount,
                              onDelete: () {
                                // showCustomConfirmDialog(
                                //   context: context,
                                //   message: 'تأكيد حذف الصنف من السلة؟',
                                //   onConfirm: () {
                                //     context.read<CartCubit>().deleteFromCart(item.id);
                                //     Navigator.of(context).pop(); // إغلاق CustomConfirmDialog
                                //   },
                                //   onCancel: () {
                                //     Navigator.of(context).pop();
                                //   },
                                // );
                              },
                              onIncrease: () {
                                context.read<CartCubit>().updateQuantity(item.id, item.amount + 1);
                              },
                              onDecrease: () {
                                if (item.amount > 1) {
                                  context.read<CartCubit>().updateQuantity(item.id, item.amount - 1);
                                }
                              },
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: AppField(
                                hintText: 'عندك كوبون؟ ادخل رقم الكوبون',
                                controller: _couponController,
                                validator: _couponError != null
                                    ? (value) => _couponError
                                    : null,
                              ),
                            ),
                            const SizedBox(width: 20),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12.0),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.2,
                                child: Align(
                                  alignment: Alignment.topCenter,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      if (_couponController.text.isNotEmpty) {
                                        context.read<CartCubit>().applyCoupon(_couponController.text);
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppThemes.greenColor.color,
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: Text(
                                      'تطبيق',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        fontFamily: 'Tajawal',
                                        color: AppThemes.whiteColor.color,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Text(
                                'جميع الأسعار تشمل قيمة الضريبة المضافة 15%',
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 18,
                                  fontFamily: 'Tajawal',
                                  color: AppThemes.greenColor.color,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Container(
                          decoration: BoxDecoration(
                            color: AppThemes.lightLightGrey.color,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        'إجمالي المنتجات',
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 18,
                                          fontFamily: 'Tajawal',
                                          color: AppThemes.greenColor.color,
                                        ),
                                      ),
                                      const Spacer(),
                                      Text(
                                        '${cart.totalPriceBeforeDiscount} ر.س',
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 18,
                                          fontFamily: 'Tajawal',
                                          color: AppThemes.greenColor.color,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        'الخصم',
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 18,
                                          fontFamily: 'Tajawal',
                                          color: AppThemes.greenColor.color,
                                        ),
                                      ),
                                      const Spacer(),
                                      Text(
                                        '-${cart.totalDiscount} ر.س',
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 18,
                                          fontFamily: 'Tajawal',
                                          color: AppThemes.greenColor.color,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Divider(color: AppThemes.lightGrey.color),
                                const SizedBox(height: 5),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        'المجموع',
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 18,
                                          fontFamily: 'Tajawal',
                                          color: AppThemes.greenColor.color,
                                        ),
                                      ),
                                      const Spacer(),
                                      Text(
                                        '${cart.totalPriceWithVat} ر.س',
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 18,
                                          fontFamily: 'Tajawal',
                                          color: AppThemes.greenColor.color,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        BlocBuilder<CartCubit, CartState>(
                          buildWhen: (previous, current) {
                            if (current is CartLoaded) {
                              lastCartResponse = current.cartResponse;
                            }
                            if (previous is CartLoaded && current is CartLoaded) {
                              return previous.cartResponse.data.length != current.cartResponse.data.length ||
                                  previous.cartResponse.totalPriceWithVat != current.cartResponse.totalPriceWithVat ||
                                  previous.cartResponse.totalDiscount != current.cartResponse.totalDiscount;
                            }
                            return previous is! CartLoaded || current is! CartLoaded;
                          },
                          builder: (context, state) {
                            if (lastCartResponse != null && lastCartResponse!.data.isNotEmpty) {
                              final cartData = lastCartResponse!.data;
                              double total = 0.0;
                              double discount = 0.0;
                              for (var item in cartData) {
                                total += item.price * item.amount;
                                discount += item.discount * item.amount;
                              }
                              print('Checkout button - Data length: ${cartData.length}, Total: $total, Discount: $discount');
                              return SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.pushNamed(
                                      context,
                                      NamedRoutes.orderComplete,
                                      arguments: {
                                        'total': total,
                                        'discount': discount,
                                        'cartItems': cartData,
                                      },
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppThemes.greenColor.color,
                                    foregroundColor: Colors.black,
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      side: BorderSide(color: AppThemes.greenColor.color, width: 2),
                                    ),
                                    elevation: 0,
                                  ),
                                  child: Text(
                                    'الإنتقال لإتمام الطلب',
                                    style: TextStyle(
                                      fontSize: MediaQuery.of(context).size.width * 0.05,
                                      fontWeight: FontWeight.bold,
                                      color: AppThemes.whiteColor.color,
                                      fontFamily: 'Tajawal',
                                    ),
                                  ),
                                ),
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}