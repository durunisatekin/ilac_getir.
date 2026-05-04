import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteModel extends ChangeNotifier {
  final List<String> favoriteNames = [];

  FavoriteModel() {
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    favoriteNames.clear();
    favoriteNames.addAll(prefs.getStringList("favoriteNames") ?? []);
    notifyListeners();
  }

  Future<void> saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList("favoriteNames", favoriteNames);
  }

  bool isFavorite(String name) {
    return favoriteNames.contains(name);
  }

  void toggleFavorite(String name) {
    if (favoriteNames.contains(name)) {
      favoriteNames.remove(name);
    } else {
      favoriteNames.add(name);
    }

    saveFavorites();
    notifyListeners();
  }
}
