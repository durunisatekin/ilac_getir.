import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteModel extends ChangeNotifier {
  final List<Map<String, dynamic>> _favorites = [];

  FavoriteModel() {
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    _favorites.clear();
    
    // Kullanıcı bazlı favorileri yükle
    final favoritesJson = prefs.getStringList("userFavorites") ?? [];
    for (final favJson in favoritesJson) {
      try {
        // Basit format: "productName|userId|timestamp"
        final parts = favJson.split("|");
        if (parts.length >= 3) {
          _favorites.add({
            "productName": parts[0],
            "userId": parts[1],
            "timestamp": int.tryParse(parts[2]) ?? 0,
          });
        }
      } catch (e) {
        // Eski formatı destekle (sadece ürün adı)
        _favorites.add({
          "productName": favJson,
          "userId": "legacy",
          "timestamp": 0,
        });
      }
    }
    
    notifyListeners();
  }

  Future<void> saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Kullanıcı bazlı favorileri kaydet
    final favoritesJson = _favorites.map((fav) => 
      "${fav["productName"]}|${fav["userId"]}|${fav["timestamp"]}"
    ).toList();
    
    await prefs.setStringList("userFavorites", favoritesJson);
  }

  bool isFavorite(String name, String userId) {
    return _favorites.any((fav) => 
      fav["productName"] == name && fav["userId"] == userId
    );
  }

  void toggleFavorite(String name, String userId) {
    final existingIndex = _favorites.indexWhere((fav) => 
      fav["productName"] == name && fav["userId"] == userId
    );

    if (existingIndex != -1) {
      _favorites.removeAt(existingIndex);
    } else {
      _favorites.add({
        "productName": name,
        "userId": userId,
        "timestamp": DateTime.now().millisecondsSinceEpoch,
      });
    }

    saveFavorites();
    notifyListeners();
  }

  List<Map<String, dynamic>> getUserFavorites(String userId) {
    return _favorites.where((fav) => fav["userId"] == userId).toList();
  }

  List<Map<String, dynamic>> getAllFavorites() {
    return List.from(_favorites);
  }

  // Veri yenileme metodu
  Future<void> refreshData() async {
    await loadFavorites();
  }
}
