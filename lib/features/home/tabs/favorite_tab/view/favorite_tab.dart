import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skydive/core/utils/extensions.dart';
import '../../../../../core/routes/routes.dart';
import '../../../../../core/services/server_gate.dart';
import '../../../../../core/utils/app_theme.dart';
import '../../../../../core/widgets/home_tab/build_product_card.dart';
import '../../../../cart/cubit/cart_cubit.dart';
import '../../../../cart/repo/cart_service.dart';
import '../cubit/favorite_tab_cubit.dart';
import '../cubit/favorite_tab_state.dart';

class FavoriteTab extends StatefulWidget {
  const FavoriteTab({super.key});

  @override
  State<FavoriteTab> createState() => _FavoriteTabState();
}

class _FavoriteTabState extends State<FavoriteTab> {
  // @override
  // void initState() {
  //   super.initState();
  //   context.read<FavoriteTabCubit>().fetchFavoriteProducts();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppThemes.whiteColor.color,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: Text(
          "المفضلة",
          style: TextStyle(
            fontFamily: "Tajawal",
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppThemes.greenColor.color,
          ),
        ),
      ),
      body: BlocBuilder<FavoriteTabCubit, FavoriteTabState>(
        builder: (context, state) {
          if (state is FavoriteTabLoading) {
            return Center(child: CircularProgressIndicator(color: AppThemes.greenColor.color));
          } else if (state is FavoriteTabError) {
            return Center(
              child: Text(
                state.message,
                style: TextStyle(
                  fontFamily: "Tajawal",
                  fontSize: 18,
                  color: AppThemes.greenColor.color,
                ),
              ),
            );
          } else if (state is FavoriteTabSuccess) {
            if (state.products.isEmpty) {
              return Center(
                child: Text(
                  "لا يوجد منتجات في المفضلة",
                  style: TextStyle(
                    fontFamily: "Tajawal",
                    fontSize: 18,
                    color: AppThemes.greenColor.color,
                  ),
                ),
              );
            }
            return GridView.builder(
              padding: const EdgeInsets.all(16.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.64,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
              ),
              itemCount: state.products.length,
              itemBuilder: (context, index) {
                final product = state.products[index];
                return BlocProvider(
                  create: (context) => CartCubit(CartService(ServerGate.i)),
                  child: GestureDetector(
                    onTap: () {
                      //Navigator.pushNamed(context, NamedRoutes.productDetails(product.id));
                    },
                    child: BuildProductCard(
                      imagePath: product.mainImage,
                      title: product.title,
                      price: "${product.price} ر.س",
                      oldPrice: "${product.priceBeforeDiscount} ر.س",
                      discount: "${(product.discount * 100).toInt()}%",
                      productId: product.id,
                    ),
                  ),
                );
              },
            );
          }
          return Center(
            child: Text(
              "لا يوجد منتجات في المفضلة",
              style: TextStyle(
                fontFamily: "Tajawal",
                fontSize: 18,
                color: AppThemes.greenColor.color,
              ),
            ),
          );
        },
      ),
    );
  }
}