import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/cart_model.dart';
import '../models/favorite_model.dart';
import '../theme/app_colors.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final favorites = context.watch<FavoriteModel>();
    final cart = context.read<Cart>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text("Favorilerim")),
      body: favorites.favoriteNames.isEmpty
          ? const Center(
              child: Text(
                "Henüz favori ürün eklenmedi",
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: favorites.favoriteNames.length,
              itemBuilder: (context, index) {
                final name = favorites.favoriteNames[index];

                return Card(
                  color: Colors.white,
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: AppColors.primaryLight,
                      child: Icon(Icons.favorite, color: Colors.red),
                    ),
                    title: Text(name),
                    subtitle: const Text("Favori ürün"),
                    trailing: ElevatedButton(
                      onPressed: () {
                        cart.addItem(name, 100);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Sepete eklendi")),
                        );
                      },
                      child: const Text("Ekle"),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
