import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skydive/core/services/server_gate.dart';
import 'package:skydive/core/utils/extensions.dart';
import 'package:skydive/features/cart/repo/cart_service.dart';
import '../../../../../core/routes/routes.dart';
import '../../../../../core/utils/app_theme.dart';
import '../../../../../core/widgets/custom_message_dialog.dart';
import '../../../../../core/widgets/home_tab/build_category_item.dart';
import '../../../../../core/widgets/home_tab/build_product_card.dart';
import '../../../../../gen/assets.gen.dart';
import '../../../../address/address/cubit/address_cubit.dart';
import '../../../../address/address/cubit/address_state.dart';
import '../../../../address/address/model/address_model.dart';
import '../../../../address/address/repo/address_service.dart';
import '../../../../cart/cubit/cart_cubit.dart';
import '../../../../cart/cubit/cart_state.dart';
import '../cubit/categories_cubit.dart';
import '../cubit/categories_state.dart';
import '../cubit/home_product_cubit.dart';
import '../cubit/home_product_state.dart';
import '../cubit/slider_cubit.dart';
import '../cubit/slider_state.dart';
import '../model/categories_model.dart';
import '../model/product_model.dart';
import '../model/slider_model.dart';
import '../repo/home_service.dart';

class CombinedHomeState {
  final bool isSlidersLoading;
  final bool isCategoriesLoading;
  final bool isProductsLoading;
  final List<SliderData>? sliders;
  final List<Category>? categories;
  final List<ProductModel>? products;
  final String? slidersError;
  final String? categoriesError;
  final String? productsError;

  CombinedHomeState({
    this.isSlidersLoading = true,
    this.isCategoriesLoading = true,
    this.isProductsLoading = true,
    this.sliders,
    this.categories,
    this.products,
    this.slidersError,
    this.categoriesError,
    this.productsError,
  });

  bool get isLoading => isSlidersLoading || isCategoriesLoading || isProductsLoading;
  bool get hasError => slidersError != null || categoriesError != null || productsError != null;
}

class HomeTab extends StatefulWidget {
  final Map<String, dynamic>? arguments;

  const HomeTab({super.key, this.arguments});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  int _currentIndex = 0;
  CombinedHomeState _combinedState = CombinedHomeState();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => CartCubit(CartService(ServerGate.i))..fetchCart(),
        ),
        BlocProvider(
          create: (context) => HomeCubit(HomeService(ServerGate.i))..fetchCategories(),
        ),
        BlocProvider(
          create: (context) => HomeProductCubit(HomeService(ServerGate.i))..fetchProducts(),
        ),
        BlocProvider(
          create: (context) => SliderCubit(HomeService(ServerGate.i))..fetchSliders(),
        ),
        BlocProvider(
          create: (context) => CurrentAddressesCubit(CurrentAddressesService(ServerGate.i))..fetchAddresses(),
        ),
      ],
      child: Scaffold(
        body: SafeArea(
          child: MultiBlocListener(
            listeners: [
              BlocListener<SliderCubit, SliderState>(
                listener: (context, state) {
                  setState(() {
                    if (state is SliderLoading) {
                      _combinedState = CombinedHomeState(
                        isSlidersLoading: true,
                        isCategoriesLoading: _combinedState.isCategoriesLoading,
                        isProductsLoading: _combinedState.isProductsLoading,
                        categories: _combinedState.categories,
                        products: _combinedState.products,
                      );
                    } else if (state is SliderLoaded) {
                      _combinedState = CombinedHomeState(
                        isSlidersLoading: false,
                        isCategoriesLoading: _combinedState.isCategoriesLoading,
                        isProductsLoading: _combinedState.isProductsLoading,
                        sliders: state.sliders,
                        categories: _combinedState.categories,
                        products: _combinedState.products,
                      );
                    } else if (state is SliderError) {
                      _combinedState = CombinedHomeState(
                        isSlidersLoading: false,
                        isCategoriesLoading: _combinedState.isCategoriesLoading,
                        isProductsLoading: _combinedState.isProductsLoading,
                        slidersError: state.message,
                        categories: _combinedState.categories,
                        products: _combinedState.products,
                      );
                    }
                  });
                },
              ),
              BlocListener<HomeCubit, HomeState>(
                listener: (context, state) {
                  setState(() {
                    if (state is HomeLoading) {
                      _combinedState = CombinedHomeState(
                        isSlidersLoading: _combinedState.isSlidersLoading,
                        isCategoriesLoading: true,
                        isProductsLoading: _combinedState.isProductsLoading,
                        sliders: _combinedState.sliders,
                        products: _combinedState.products,
                      );
                    } else if (state is HomeCategoriesLoaded) {
                      _combinedState = CombinedHomeState(
                        isSlidersLoading: _combinedState.isSlidersLoading,
                        isCategoriesLoading: false,
                        isProductsLoading: _combinedState.isProductsLoading,
                        sliders: _combinedState.sliders,
                        categories: state.categories.data,
                        products: _combinedState.products,
                      );
                    } else if (state is HomeError) {
                      _combinedState = CombinedHomeState(
                        isSlidersLoading: _combinedState.isSlidersLoading,
                        isCategoriesLoading: false,
                        isProductsLoading: _combinedState.isProductsLoading,
                        sliders: _combinedState.sliders,
                        categoriesError: state.message,
                        products: _combinedState.products,
                      );
                    }
                  });
                },
              ),
              BlocListener<HomeProductCubit, HomeProductState>(
                listener: (context, state) {
                  setState(() {
                    if (state is HomeProductLoading) {
                      _combinedState = CombinedHomeState(
                        isSlidersLoading: _combinedState.isSlidersLoading,
                        isCategoriesLoading: _combinedState.isCategoriesLoading,
                        isProductsLoading: true,
                        sliders: _combinedState.sliders,
                        categories: _combinedState.categories,
                      );
                    } else if (state is HomeProductLoaded) {
                      _combinedState = CombinedHomeState(
                        isSlidersLoading: _combinedState.isSlidersLoading,
                        isCategoriesLoading: _combinedState.isCategoriesLoading,
                        isProductsLoading: false,
                        sliders: _combinedState.sliders,
                        categories: _combinedState.categories,
                        products: state.products,
                      );
                    } else if (state is HomeProductError) {
                      _combinedState = CombinedHomeState(
                        isSlidersLoading: _combinedState.isSlidersLoading,
                        isCategoriesLoading: _combinedState.isCategoriesLoading,
                        isProductsLoading: false,
                        sliders: _combinedState.sliders,
                        categories: _combinedState.categories,
                        productsError: state.message,
                      );
                    }
                  });
                },
              ),
              BlocListener<CartCubit, CartState>(
                listener: (context, state) {
                  if (state is CartSuccess) {
                    showCustomMessageDialog(context, state.message,);
                  } else if (state is CartError) {
                    showCustomMessageDialog(context, 'خطأ: ${state.message}',);
                  } else if (state is CartCouponError) {
                    showCustomMessageDialog(context, 'خطأ الكوبون: ${state.message}',);
                  }
                },
              ),
            ],
            child: BlocBuilder<CurrentAddressesCubit, CurrentAddressesState>(
              builder: (context, addressState) {
                String addressText = "اختر عنوانًا";
                if (addressState is CurrentAddressesSuccess) {
                  addressText = addressState.addresses.firstWhere(
                        (CurrentAddressesModel address) => address.isDefault,
                    orElse: () => CurrentAddressesModel(
                      id: 0,
                      type: '',
                      lat: 0.0,
                      lng: 0.0,
                      location: "اختر عنوانًا",
                      description: '',
                      isDefault: false,
                      phone: '',
                    ),
                  ).location;
                } else if (addressState is DeleteAddressSuccess) {
                  addressText = addressState.addresses.firstWhere(
                        (CurrentAddressesModel address) => address.isDefault,
                    orElse: () => CurrentAddressesModel(
                      id: 0,
                      type: '',
                      lat: 0.0,
                      lng: 0.0,
                      location: "اختر عنوانًا",
                      description: '',
                      isDefault: false,
                      phone: '',
                    ),
                  ).location;
                } else if (addressState is UpdateAddressSuccess) {
                  addressText = addressState.addresses.firstWhere(
                        (CurrentAddressesModel address) => address.isDefault,
                    orElse: () => CurrentAddressesModel(
                      id: 0,
                      type: '',
                      lat: 0.0,
                      lng: 0.0,
                      location: "اختر عنوانًا",
                      description: '',
                      isDefault: false,
                      phone: '',
                    ),
                  ).location;
                }

                return _combinedState.isLoading
                    ? SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(AppThemes.greenColor.color),
                    ),
                  ),
                )
                    : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Cart + Delivery Place + Logo
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "سلة ثمار",
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: "Tajawal",
                                        fontWeight: FontWeight.bold,
                                        color: AppThemes.greenColor.color,
                                      ),
                                    ),
                                    Image(image: AssetImage(Assets.images.logo.path), width: 20, height: 20),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Text(
                                    "التوصيل إلى",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Tajawal",
                                      color: AppThemes.greenColor.color,
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    addressText,
                                    style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontFamily: "Tajawal",
                                      color: AppThemes.greenColor.color,
                                      fontSize: 14,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: BlocBuilder<CartCubit, CartState>(
                                builder: (context, state) {
                                  int cartItemCount = 0;
                                  if (state is CartLoaded) {
                                    cartItemCount = state.cartResponse.data.length;
                                  }
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(context, NamedRoutes.cart);
                                    },
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Stack(
                                        clipBehavior: Clip.none,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              color: AppThemes.cartGrey.color,
                                              borderRadius: BorderRadius.circular(16),
                                            ),
                                            padding: const EdgeInsets.all(8.0),
                                            child: Image.asset(Assets.images.cart.path),
                                          ),
                                          if (cartItemCount > 0)
                                            Positioned(
                                              top: -5,
                                              right: -5,
                                              child: Container(
                                                padding: const EdgeInsets.all(4),
                                                decoration: BoxDecoration(
                                                  color: AppThemes.greenColor.color,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Text(
                                                  "$cartItemCount",
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Search Bar
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppThemes.lightLightGrey.color,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: TextFormField(
                            textAlign: TextAlign.right,
                            decoration: InputDecoration(
                              hintText: "ابحث عن ما تريد؟",
                              hintStyle: TextStyle(
                                color: AppThemes.greyColor.color,
                                fontFamily: "Tajawal",
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              suffixIcon: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.asset(
                                  Assets.images.search.path,
                                  width: 24,
                                  height: 24,
                                  color: AppThemes.greyColor.color,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      // عرض رسالة الخطأ لو موجودة
                      if (_combinedState.hasError)
                        Center(
                          child: Text(
                            'خطأ: ${_combinedState.slidersError ?? _combinedState.categoriesError ?? _combinedState.productsError ?? 'حدث خطأ غير معروف'}',
                            style: TextStyle(
                              fontSize: 18,
                              fontFamily: "Tajawal",
                              color: AppThemes.greenColor.color,
                            ),
                          ),
                        )
                      else ...[
                        // Large Home Image (Sliders)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              CarouselSlider(
                                options: CarouselOptions(
                                  height: 180.0,
                                  autoPlay: true,
                                  autoPlayInterval: const Duration(seconds: 3),
                                  enlargeCenterPage: true,
                                  viewportFraction: 1.0,
                                  aspectRatio: 2.0,
                                  onPageChanged: (index, reason) {
                                    setState(() {
                                      _currentIndex = index;
                                    });
                                  },
                                ),
                                items: _combinedState.sliders!.map((slider) {
                                  return Image.network(
                                    slider.media.isNotEmpty ? slider.media : 'https://via.placeholder.com/150',
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    loadingBuilder: (context, child, loadingProgress) {
                                      if (loadingProgress == null) {
                                        return child;
                                      }
                                      return Center(
                                        child: CircularProgressIndicator(
                                          valueColor: AlwaysStoppedAnimation<Color>(AppThemes.greenColor.color),
                                        ),
                                      );
                                    },
                                    errorBuilder: (context, error, stackTrace) {
                                      print('Image error: $error, URL: ${slider.media}');
                                      return Image.asset(
                                        Assets.images.homeImage.path,
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                      );
                                    },
                                  );
                                }).toList(),
                              ),
                              if (_combinedState.sliders!.isNotEmpty)
                                Positioned(
                                  bottom: 8.0,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: List.generate(
                                      _combinedState.sliders!.length,
                                          (index) => Container(
                                        width: 8.0,
                                        height: 8.0,
                                        margin: const EdgeInsets.symmetric(horizontal: 4.0),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: _currentIndex == index ? AppThemes.greenColor.color : AppThemes.greyColor.color,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        // Categories Section
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 8,
                          ),
                          child: Row(
                            children: [
                              Text(
                                "عرض الكل",
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontFamily: "Tajawal",
                                  fontSize: 18,
                                  color: AppThemes.greenColor.color,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                "الأقسام",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Tajawal",
                                  fontSize: 20,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Row of Category Containers
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            textDirection: TextDirection.rtl,
                            children: List.generate(
                              _combinedState.categories!.length,
                                  (index) {
                                final category = _combinedState.categories![index];
                                final colors = [
                                  AppThemes.lightLightGrey.color,
                                  AppThemes.lightPink.color,
                                  AppThemes.darkPink.color,
                                  AppThemes.lightBlue.color,
                                  AppThemes.lightLightGrey.color,
                                  AppThemes.lightPink.color,
                                ];
                                final containerColor = colors[index % colors.length];
                                return BuildCategoryItem(
                                  imagePath: category.media.isNotEmpty ? category.media : 'https://via.placeholder.com/150',
                                  title: category.name,
                                  containerColor: containerColor,
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      NamedRoutes.categoryProduct,
                                      arguments: {
                                        'categoryId': category.id,
                                        'categoryName': category.name,
                                      },
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Products Section
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                "الأصناف",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: "Tajawal",
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Dynamic Products from API
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 0.64,
                            ),
                            itemCount: _combinedState.products!.length,
                            itemBuilder: (context, index) {
                              final product = _combinedState.products![index];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                    context,
                                    NamedRoutes.productDetails,
                                    arguments: {'productId': product.id},
                                  );
                                },
                                child: BuildProductCard(
                                  imagePath: product.mainImage.isNotEmpty ? product.mainImage : 'https://via.placeholder.com/150',
                                  title: product.title,
                                  price: "${product.price} ر.س",
                                  oldPrice: "${product.priceBeforeDiscount} ر.س",
                                  discount: "-${(product.discount * 100).toInt()}%",
                                  productId: product.id,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
