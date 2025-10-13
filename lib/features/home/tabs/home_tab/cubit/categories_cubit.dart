import 'package:flutter_bloc/flutter_bloc.dart';
import '../repo/home_service.dart';
import 'categories_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final HomeService homeService;

  HomeCubit(this.homeService) : super(HomeInitial());

  void fetchCategories() async {
    emit(HomeLoading());
    try {
      final categoryResponse = await homeService.getCategories();
      emit(HomeCategoriesLoaded(categoryResponse));
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  void fetchProductsByCategory(int categoryId) async {
    emit(HomeLoading());
    try {
      final productsResponse = await homeService.fetchProductsByCategory(categoryId);
      emit(HomeProductsLoaded(productsResponse));
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }
}