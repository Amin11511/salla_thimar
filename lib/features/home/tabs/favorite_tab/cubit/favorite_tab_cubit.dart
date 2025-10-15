import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skydive/features/home/tabs/home_tab/model/product_response.dart';
import '../repo/favorite_tab_service.dart';
import 'favorite_tab_state.dart';

class FavoriteTabCubit extends Cubit<FavoriteTabState> {
  final FavoriteTabService favoriteTabService;

  FavoriteTabCubit(this.favoriteTabService) : super(FavoriteTabInitial());

  Future<void> fetchFavoriteProducts() async {
    emit(FavoriteTabLoading());
    try {
      final response = await favoriteTabService.getFavoriteProducts();
      emit(FavoriteTabSuccess(response.data.cast<Product>()));
    } catch (e) {
      emit(FavoriteTabError(e.toString()));
    }
  }
}