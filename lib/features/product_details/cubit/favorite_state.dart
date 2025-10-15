abstract class FavoriteState {}

class FavoriteInitial extends FavoriteState {}

class FavoriteLoading extends FavoriteState {
  final int productId;

  FavoriteLoading(this.productId);
}

class FavoriteSuccess extends FavoriteState {
  final String? message;
  final Map<int, bool> favorites;

  FavoriteSuccess({
    this.message,
    required this.favorites,
  });

  FavoriteSuccess.initial() : message = null, favorites = {};

  FavoriteSuccess copyWith({
    String? message,
    Map<int, bool>? favorites,
  }) {
    return FavoriteSuccess(
      message: message ?? this.message,
      favorites: favorites ?? this.favorites,
    );
  }
}

class FavoriteError extends FavoriteState {
  final String message;

  FavoriteError(this.message);
}