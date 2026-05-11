import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/medicine_data.dart';
import '../models/cart_model.dart';
import '../models/favorite_model.dart';
import '../widgets/empty_state.dart';
import '../widgets/pill_badge.dart';
import '../widgets/price_text.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final favorites = context.watch<FavoriteModel>();
    final cart = context.read<Cart>();
    final favoriteMedicines = medicines
        .where((medicine) => favorites.isFavorite(medicine["name"] as String))
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text("Favorilerim")),
      body: favoriteMedicines.isEmpty
          ? const EmptyState(
              icon: Icons.favorite_border,
              title: "Henüz favorin yok",
              message: "Beğendiğin ürünleri favorilere ekleyerek burada hızlıca bulabilirsin.",
            )
          : ListView(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 24),
              children: [
                _FavoritesHeader(count: favoriteMedicines.length),
                const SizedBox(height: 14),
                ...favoriteMedicines.map(
                  (medicine) => _FavoriteMedicineCard(
                    medicine: medicine,
                    onAddToCart: () {
                      cart.addItem(
                        medicine["name"] as String,
                        (medicine["price"] as num).toDouble(),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("${medicine["name"]} sepete eklendi"),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                    onRemove: () {
                      favorites.toggleFavorite(medicine["name"] as String);
                    },
                  ),
                ),
              ],
            ),
    );
  }
}

class _FavoritesHeader extends StatelessWidget {
  final int count;

  const _FavoritesHeader({required this.count});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.16),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.favorite, color: Colors.white),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "$count favori ürün",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  "Sık baktığın ilaçlara buradan hızlıca ulaşabilirsin.",
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FavoriteMedicineCard extends StatelessWidget {
  final Map<String, dynamic> medicine;
  final VoidCallback onAddToCart;
  final VoidCallback onRemove;

  const _FavoriteMedicineCard({
    required this.medicine,
    required this.onAddToCart,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final name = medicine["name"] as String;
    final type = medicine["type"] as String;
    final price = (medicine["price"] as num).toDouble();
    final image = medicine["image"] as String?;
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: theme.colorScheme.primaryContainer),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 82,
              height: 82,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFF9FBFC),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade100),
              ),
              child: image == null
                  ? Icon(Icons.medication, color: theme.colorScheme.primary)
                  : Image.asset(
                      image,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(Icons.medication, color: theme.colorScheme.primary);
                      },
                    ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          name,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: onRemove,
                        child: Container(
                          width: 34,
                          height: 34,
                          decoration: const BoxDecoration(
                            color: Color(0xFFFFEEF0),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.favorite,
                            color: Colors.redAccent,
                            size: 19,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  PillBadge(text: categoryTitle(type)),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: PriceText(price: price),
                      ),
                      SizedBox(
                        height: 38,
                        child: ElevatedButton.icon(
                          onPressed: onAddToCart,
                          icon: const Icon(Icons.add_shopping_cart, size: 18),
                          label: const Text("Sepete ekle"),
                          style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 12)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
