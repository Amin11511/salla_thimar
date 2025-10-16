import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:skydive/core/utils/extensions.dart';
import '../../../core/utils/app_theme.dart';
import '../../../core/widgets/product_details/product_image_carousel.dart';
import '../../../gen/assets.gen.dart';
import '../../cart/cubit/cart_cubit.dart';
import '../../cart/cubit/cart_state.dart';
import '../cubit/favorite_cubit.dart';
import '../cubit/favorite_state.dart';
import '../cubit/product_details_cubit.dart';
import '../cubit/rate_cubit.dart';
import '../cubit/rate_state.dart';

class ProductDetails extends StatefulWidget {
  final int productId;

  const ProductDetails({super.key, required this.productId});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  int quantity = 1;
  dynamic product;

  @override
  void initState() {
    super.initState();
    context.read<ProductDetailsCubit>().fetchProductDetails(widget.productId);
    context.read<RateCubit>().fetchProductRates(widget.productId);
    context.read<FavoriteCubit>().checkIfFavorite(widget.productId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<FavoriteCubit, FavoriteState>(
      listener: (context, state) {
        if (state is FavoriteSuccess &&
            state.favorites.containsKey(widget.productId)) {
          setState(() {
            if (product != null) {
              product.isFavorite = state.favorites[widget.productId]!;
            }
          });
        }
      },
      child: BlocBuilder<ProductDetailsCubit, ProductDetailsState>(
        builder: (context, state) {
          if (state is ProductDetailsLoading) {
            return Scaffold(
              body: Center(child: CircularProgressIndicator(color: AppThemes.greenColor.color)),
            );
          } else if (state is ProductDetailsError) {
            return Scaffold(
              body: Center(child: Text('Error: ${state.message}')),
            );
          } else if (state is ProductDetailsLoaded) {
            product = state.product;
            final List<String> productImages = [
              product.mainImage,
              ...product.images,
            ];

            return Scaffold(
              appBar: AppBar(
                backgroundColor: AppThemes.whiteColor.color,
                centerTitle: true,
                automaticallyImplyLeading: false,
                leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: AppThemes.greenColor.color,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                actions: [
                  BlocBuilder<FavoriteCubit, FavoriteState>(
                    builder: (context, favoriteState) {
                      bool isLoading =
                          favoriteState is FavoriteLoading &&
                              favoriteState.productId == product.id;
                      bool isFavorite = favoriteState is FavoriteSuccess
                          ? favoriteState.favorites[product.id] ??
                          product.isFavorite
                          : product.isFavorite;

                      return GestureDetector(
                        onTap: isLoading
                            ? null
                            : () {
                          context.read<FavoriteCubit>().toggleFavorite(
                            product.id,
                            isFavorite,
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppThemes.lightLightGrey.color,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            height: 48,
                            width: 48,
                            margin: const EdgeInsetsDirectional.only(start: 8),
                            child: isLoading
                                ? Center(
                              child: SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  color: AppThemes.greenColor.color,
                                  strokeWidth: 2,
                                ),
                              ),
                            )
                                : Icon(
                              Icons.favorite,
                              color: isFavorite
                                  ? AppThemes.greenColor.color
                                  : AppThemes.lightGrey.color,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
              bottomNavigationBar: BlocBuilder<CartCubit, CartState>(
                buildWhen: (previous, current) =>
                (previous.loadingProductIds?.contains(product.id) ?? false) !=
                    (current.loadingProductIds?.contains(product.id) ?? false),
                builder: (context, cartState) {
                  bool isLoading = cartState.loadingProductIds?.contains(product.id) ?? false;
                  return BottomAppBar(
                    color: AppThemes.greenColor.color,
                    child: SizedBox(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: isLoading
                                  ? null
                                  : () {
                                context.read<CartCubit>().addToCart(
                                  product.id,
                                  quantity,
                                );
                              },
                              child: Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: AppThemes.lightGreen.color,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: isLoading
                                          ? const SizedBox(
                                        height: 24,
                                        width: 24,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      )
                                          : Image.asset(
                                        Assets.images.details.path,
                                        height: 24,
                                        width: 24,
                                        color: Colors.white,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    "اضف الى السلة",
                                    style: TextStyle(
                                      fontFamily: "Tajawal",
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              "${(quantity * product.price).toStringAsFixed(2)} ر.س",
                              textDirection: TextDirection.rtl,
                              style: const TextStyle(
                                color: Colors.white,
                                fontFamily: "Tajawal",
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              body: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      ProductImageCarousel(productImages: productImages),
                      const SizedBox(height: 14),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          children: [
                            Text(
                              product.title,
                              style: TextStyle(
                                fontFamily: "Tajawal",
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppThemes.greenColor.color,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              "${(product.discount * 100).toInt()}%",
                              textDirection: TextDirection.rtl,
                              style: const TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 16,
                                fontFamily: "Tajawal",
                                color: Colors.red,
                              ),
                            ),
                            const SizedBox(width: 3),
                            Text(
                              "${product.price} ر.س",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                fontFamily: "Tajawal",
                                color: AppThemes.greenColor.color,
                              ),
                            ),
                            const SizedBox(width: 3),
                            Text(
                              "${product.priceBeforeDiscount} ر.س",
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 14,
                                fontFamily: "Tajawal",
                                color: AppThemes.greenColor.color,
                                decoration: TextDecoration.lineThrough,
                                decorationColor: AppThemes.greenColor.color,
                                decorationThickness: 2,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "السعر / 1${product.unit.name}",
                              style: TextStyle(
                                color: AppThemes.lightGrey.color,
                                fontFamily: "Tajawal",
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                            Container(
                              decoration: BoxDecoration(
                                color: AppThemes.lightLightGrey.color,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        if (quantity > 1) {
                                          setState(() => quantity--);
                                        }
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: AppThemes.whiteColor.color,
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.remove,
                                          color: AppThemes.greenColor.color,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    "$quantity",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: AppThemes.greenColor.color,
                                      fontFamily: "Tajawal",
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        if (quantity < product.amount) {
                                          setState(() => quantity++);
                                        }
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: AppThemes.whiteColor.color,
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.add,
                                          color: AppThemes.greenColor.color,
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
                      const SizedBox(height: 35),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          children: [
                            Text(
                              "كود المنتج",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: AppThemes.greenColor.color,
                                fontFamily: "Tajawal",
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              product.id.toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: AppThemes.lightGrey.color,
                                fontFamily: "Tajawal",
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 35),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          "تفاصيل المنتج",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: AppThemes.greenColor.color,
                            fontFamily: "Tajawal",
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          product.description,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: AppThemes.lightGrey.color,
                            fontFamily: "Tajawal",
                          ),
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                          textDirection: TextDirection.rtl,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8,
                        ),
                        child: Row(
                          children: [
                            Text(
                              "التقييمات",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: AppThemes.greenColor.color,
                                fontFamily: "Tajawal",
                              ),
                            ),
                            Spacer(),
                            Text(
                              "عرض الكل",
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontFamily: "Tajawal",
                                fontSize: 18,
                                color: AppThemes.greenColor.color,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: BlocBuilder<RateCubit, RateState>(
                          builder: (context, rateState) {
                            if (rateState is RateLoading) {
                              return Center(
                                child: CircularProgressIndicator(color: AppThemes.greenColor.color),
                              );
                            } else if (rateState is RateError) {
                              return Text(
                                'لا يوجد تقييمات',
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 18,
                                  fontFamily: "Tajawal",
                                  color: AppThemes.greenColor.color,
                                ),
                              );
                            } else if (rateState is RateLoaded) {
                              final ratesData = rateState.rates?.data;
                              if (ratesData == null || ratesData.isEmpty) {
                                return Text(
                                  'لا يوجد تقييمات',
                                  style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 18,
                                    fontFamily: "Tajawal",
                                    color: AppThemes.greenColor.color,
                                  ),
                                );
                              }
                              return CarouselSlider(
                                options: CarouselOptions(
                                  height: 120.0,
                                  enlargeCenterPage: true,
                                  enableInfiniteScroll: false,
                                  scrollDirection: Axis.horizontal,
                                  reverse: true,
                                ),
                                items: ratesData.map((rate) {
                                  return Builder(
                                    builder: (BuildContext context) {
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 10,
                                        ),
                                        child: Directionality(
                                          textDirection: TextDirection.rtl,
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              CircleAvatar(
                                                radius: 30,
                                                backgroundImage: NetworkImage(
                                                  rate.clientImage,
                                                ),
                                              ),
                                              const SizedBox(width: 20),
                                              Expanded(
                                                child: Column(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      rate.comment,
                                                      style: TextStyle(
                                                        fontFamily: "Tajawal",
                                                        fontSize: 14,
                                                        color:
                                                        AppThemes.lightGrey.color,
                                                      ),
                                                      maxLines: 2,
                                                      overflow:
                                                      TextOverflow.ellipsis,
                                                      textDirection:
                                                      TextDirection.rtl,
                                                    ),
                                                    const SizedBox(height: 8),
                                                    RatingBar.builder(
                                                      initialRating: rate.value
                                                          .toDouble(),
                                                      direction:
                                                      Axis.horizontal,
                                                      allowHalfRating: true,
                                                      itemCount: 5,
                                                      itemSize: 20,
                                                      itemBuilder:
                                                          (
                                                          context,
                                                          _,
                                                          ) => const Icon(
                                                        Icons.star,
                                                        color: Colors.amber,
                                                      ),
                                                      onRatingUpdate: (rating) {
                                                        // Handle rating update if needed
                                                      },
                                                    ),
                                                    const SizedBox(height: 4),
                                                    Text(
                                                      rate.clientName.isNotEmpty
                                                          ? rate.clientName
                                                          : 'مجهول',
                                                      style: TextStyle(
                                                        fontFamily: "Tajawal",
                                                        fontSize: 16,
                                                        fontWeight:
                                                        FontWeight.bold,
                                                        color: AppThemes.greenColor.color,
                                                      ),
                                                      textDirection:
                                                      TextDirection.rtl,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                }).toList(),
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return const Scaffold(body: Center(child: Text('No data')));
          }
        },
      ),
    );
  }
}
