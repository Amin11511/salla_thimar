import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/services/server_gate.dart';
import '../../../models/user_model.dart';
import '../model/favorite_model.dart';

class FavoriteService {
  final Logger _logger = Logger();

  Future<FavoriteResponse> addToFavorite(int productId) async {
    try {
      final response = await ServerGate.i.sendToServer(
        url: 'client/products/$productId/add_to_favorite',
      );

      if (response.success) {
        final prefs = await SharedPreferences.getInstance();
        final favoriteIds = prefs.getStringList('favorite_ids') ?? [];
        if (!favoriteIds.contains(productId.toString())) {
          favoriteIds.add(productId.toString());
          await prefs.setStringList('favorite_ids', favoriteIds);
        }

        _logger.d('Added product $productId to favorites');
        return FavoriteResponse.fromJson(response.data);
      } else {
        throw Exception('Failed to add to favorite: ${response.msg}');
      }
    } catch (e) {
      _logger.e('Failed to add to favorite: $e');
      throw Exception('Failed to add to favorite: $e');
    }
  }

  Future<void> removeFromFavorite(int productId) async {
    try {
      final response = await ServerGate.i.sendToServer(
        url: 'client/products/$productId/remove_from_favorite',
      );

      if (response.success) {
        final prefs = await SharedPreferences.getInstance();
        final favoriteIds = prefs.getStringList('favorite_ids') ?? [];
        favoriteIds.remove(productId.toString());
        await prefs.setStringList('favorite_ids', favoriteIds);

        _logger.d('Removed product $productId from favorites');
      } else {
        throw Exception('Failed to remove from favorite: ${response.msg}');
      }
    } catch (e) {
      _logger.e('Failed to remove from favorite: $e');
      throw Exception('Failed to remove from favorite: $e');
    }
  }

  Future<bool> isProductFavorite(int productId) async {
    try {
      if (!UserModel.i.isAuth) {
        _logger.w('No token found, checking local favorites');
        final prefs = await SharedPreferences.getInstance();
        final favoriteIds = prefs.getStringList('favorite_ids') ?? [];
        return favoriteIds.contains(productId.toString());
      }

      final response = await ServerGate.i.getFromServer(
        url: '/client/products/favorites',
      );

      if (response.success) {
        _logger.d('Favorites API response: ${response.data}');
        final favoriteIds = (response.data['data'] as List<dynamic>)
            .map((item) => item['id'] as int)
            .toList();
        return favoriteIds.contains(productId);
      } else {
        throw Exception('Failed to check favorite status: ${response.msg}');
      }
    } catch (e) {
      _logger.e('Failed to check favorite status: $e');
      final prefs = await SharedPreferences.getInstance();
      final favoriteIds = prefs.getStringList('favorite_ids') ?? [];
      return favoriteIds.contains(productId.toString());
    }
  }

  Future<List<int>> getFavoriteIds() async {
    try {
      if (!UserModel.i.isAuth) {
        _logger.w('No token found, returning local favorites');
        final prefs = await SharedPreferences.getInstance();
        final favoriteIds = prefs.getStringList('favorite_ids') ?? [];
        return favoriteIds.map((id) => int.parse(id)).toList();
      }

      final response = await ServerGate.i.getFromServer(
        url: '/client/products/favorites',
      );

      if (response.success) {
        _logger.d('Favorites API response: ${response.data}');
        final favoriteIds = (response.data['data'] as List<dynamic>)
            .map((item) => item['id'] as int)
            .toList();
        return favoriteIds;
      } else {
        throw Exception('Failed to fetch favorite IDs: ${response.msg}');
      }
    } catch (e) {
      _logger.e('Failed to fetch favorite IDs: $e');
      final prefs = await SharedPreferences.getInstance();
      final favoriteIds = prefs.getStringList('favorite_ids') ?? [];
      return favoriteIds.map((id) => int.parse(id)).toList();
    }
  }
}