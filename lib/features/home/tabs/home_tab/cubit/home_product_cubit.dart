import 'package:flutter_bloc/flutter_bloc.dart';
import '../repo/home_service.dart';
import 'home_product_state.dart';

class HomeProductCubit extends Cubit<HomeProductState> {
  final HomeService homeService;

  HomeProductCubit(this.homeService) : super(HomeProductInitial());

  Future<void> fetchProducts() async {
    try {
      emit(HomeProductLoading());
      final products = await homeService.getProducts();
      emit(HomeProductLoaded(products));
    } catch (e) {
      emit(HomeProductError(e.toString()));
    }
  }
}