import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skydive/core/services/server_gate.dart';
import 'package:skydive/core/utils/extensions.dart';
import 'package:skydive/core/widgets/custom_app_bar/custom_app_bar.dart';
import '../../../core/utils/app_theme.dart';
import '../../../core/widgets/home_tab/build_product_card.dart';
import '../../../gen/assets.gen.dart';
import '../../home/tabs/home_tab/cubit/categories_cubit.dart';
import '../../home/tabs/home_tab/cubit/categories_state.dart';
import '../../home/tabs/home_tab/repo/home_service.dart';

class CategoryProductsScreen extends StatefulWidget {
  final int categoryId;
  final String categoryName;

  const CategoryProductsScreen({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  State<CategoryProductsScreen> createState() => _CategoryProductsScreenState();
}

class _CategoryProductsScreenState extends State<CategoryProductsScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          HomeCubit(HomeService(ServerGate.i))
            ..fetchProductsByCategory(widget.categoryId),
      child: Scaffold(
        appBar: CustomAppBar(
          title: widget.categoryName,
          onBackPressed: () {
            Navigator.pop(context);
          },
        ),
        body: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            if (state is HomeLoading) {
              return Center(
                child: CircularProgressIndicator(
                  color: AppThemes.greenColor.color,
                ),
              );
            } else if (state is HomeProductsLoaded) {
              final products = state.products.data;
              if (products.isEmpty) {
                return Center(
                  child: Text(
                    'لا توجد منتجات في قسم ${widget.categoryName}',
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: "Tajawal",
                      fontWeight: FontWeight.bold,
                      color: AppThemes.greenColor.color,
                    ),
                  ),
                );
              }

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppThemes.lightLightGrey.color,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: TextFormField(
                        enabled: false,
                        textAlign: TextAlign.right,
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          hintText: "ابحث عن ما تريد؟",
                          hintStyle: TextStyle(
                            color: AppThemes.lightGrey.color,
                            fontFamily: "Tajawal",
                          ),
                          border: InputBorder.none,
                          contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                          suffixIcon: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset(
                              Assets.images.search.path,
                              width: 24,
                              height: 24,
                              color: AppThemes.greyColor.color,
                            ),
                          ),
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 36,
                              width: 36,
                              decoration: BoxDecoration(
                                color: AppThemes.greenColor.color,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Icon(
                                Icons.filter_list,
                                color: AppThemes.whiteColor.color,
                                size: 20,
                              ),
                            ),
                          ),
                          prefixIconConstraints: const BoxConstraints(
                            minWidth: 48,
                            minHeight: 48,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // 🛒 GridView of products
                  Expanded(
                    child: GridView.builder(
                      padding: const EdgeInsets.all(8.0),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.68,
                        crossAxisSpacing: 8.0,
                        mainAxisSpacing: 8.0,
                      ),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return GestureDetector(
                          child: BuildProductCard(
                            imagePath: product.mainImage.isNotEmpty
                                ? product.mainImage
                                : 'https://via.placeholder.com/150',
                            title: product.title,
                            price: '${product.price} ر.س',
                            oldPrice: '${product.priceBeforeDiscount} ر.س',
                            discount:
                            '-${(product.discount * 100).toStringAsFixed(0)}%',
                            productId: product.id,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );

            } else if (state is HomeError) {
              return Center(
                child: Text(
                  'خطأ في جلب منتجات قسم ${widget.categoryName}: ${state.message}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: "Tajawal",
                    fontWeight: FontWeight.bold,
                    color: AppThemes.greenColor.color,
                  ),
                ),
              );
            }
            return const Center(child: Text('لا توجد بيانات'));
          },
        ),
      ),
    );
  }
}
