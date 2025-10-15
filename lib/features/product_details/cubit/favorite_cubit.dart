import 'package:flutter_bloc/flutter_bloc.dart';
import '../repo/favorite_service.dart';
import 'favorite_state.dart';

class FavoriteCubit extends Cubit<FavoriteState> {
  final FavoriteService favoriteService;

  FavoriteCubit(this.favoriteService) : super(FavoriteSuccess.initial()) {
    _loadInitialFavorites();
  }

  Future<void> _loadInitialFavorites() async {
    try {
      final favoriteIds = await favoriteService.getFavoriteIds();
      final updatedFavorites = Map<int, bool>.from(state is FavoriteSuccess
          ? (state as FavoriteSuccess).favorites
          : {});
      for (int id in favoriteIds) {
        updatedFavorites[id] = true;
      }
      emit(FavoriteSuccess(favorites: updatedFavorites));
    } catch (e) {
    }
  }

  Future<void> checkIfFavorite(int productId) async {
    if (state is FavoriteLoading && (state as FavoriteLoading).productId == productId) {
      return;
    }

    try {
      final isFavorite = await favoriteService.isProductFavorite(productId);
      final currentState = state is FavoriteSuccess ? state as FavoriteSuccess : FavoriteSuccess.initial();
      final updatedFavorites = Map<int, bool>.from(currentState.favorites);
      updatedFavorites[productId] = isFavorite;

      emit(FavoriteSuccess(favorites: updatedFavorites));
    } catch (e) {
    }
  }

  Future<void> toggleFavorite(int productId, bool isCurrentlyFavorite) async {
    emit(FavoriteLoading(productId));

    try {
      if (isCurrentlyFavorite) {
        await favoriteService.removeFromFavorite(productId);
        _updateFavoriteStatus(productId, false, message: 'تم إزالة المنتج من المفضلة');
      } else {
        final response = await favoriteService.addToFavorite(productId);
        _updateFavoriteStatus(productId, true, message: response.message);
      }
    } catch (e) {
      emit(FavoriteError('Failed to toggle favorite: $e'));
    }
  }

  void _updateFavoriteStatus(int productId, bool newStatus, {String? message}) {
    final currentState = state is FavoriteSuccess ? state as FavoriteSuccess : FavoriteSuccess.initial();
    final updatedFavorites = Map<int, bool>.from(currentState.favorites);
    updatedFavorites[productId] = newStatus;

    emit(FavoriteSuccess(
      message: message,
      favorites: updatedFavorites,
    ));
  }
}