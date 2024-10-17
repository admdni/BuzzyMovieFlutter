// lib/services/storage_service.dart

import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _favoriteKey = 'favorites';
  static const String _watchListKey = 'watchList';

  static Future<void> saveFavorite(int movieId) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList(_favoriteKey) ?? [];

    if (!favorites.contains(movieId.toString())) {
      favorites.add(movieId.toString());
      await prefs.setStringList(_favoriteKey, favorites);
    }
  }

  static Future<void> saveToWatchList(int movieId) async {
    final prefs = await SharedPreferences.getInstance();
    final watchList = prefs.getStringList(_watchListKey) ?? [];

    if (!watchList.contains(movieId.toString())) {
      watchList.add(movieId.toString());
      await prefs.setStringList(_watchListKey, watchList);
    }
  }

  static Future<List<int>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList(_favoriteKey) ?? [];
    return favorites.map((id) => int.parse(id)).toList();
  }

  static Future<List<int>> getWatchList() async {
    final prefs = await SharedPreferences.getInstance();
    final watchList = prefs.getStringList(_watchListKey) ?? [];
    return watchList.map((id) => int.parse(id)).toList();
  }

  static Future<void> removeFavorite(int movieId) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList(_favoriteKey) ?? [];
    favorites.remove(movieId.toString());
    await prefs.setStringList(_favoriteKey, favorites);
  }

  static Future<void> removeFromWatchList(int movieId) async {
    final prefs = await SharedPreferences.getInstance();
    final watchList = prefs.getStringList(_watchListKey) ?? [];
    watchList.remove(movieId.toString());
    await prefs.setStringList(_watchListKey, watchList);
  }
}
