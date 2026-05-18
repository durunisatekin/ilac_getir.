import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/cart_model.dart';
import '../models/favorite_model.dart';
import '../models/user_model.dart';
import '../theme/app_colors.dart';

class MedicineDetailPage extends StatelessWidget {
  final Map<String, dynamic> ilac;

  const MedicineDetailPage({super.key, required this.ilac});

  @override
  Widget build(BuildContext context) {
    final cart = context.read<Cart>();
    final favorites = context.watch<FavoriteModel>();
    final user = context.read<UserModel>();
    final userId = user.phone.isNotEmpty ? user.phone : "guest_${user.name}";
    final isFavorite = favorites.isFavorite(ilac["name"], userId);
    final price = (ilac["price"] as num).toDouble();
    final originalPrice = (ilac["originalPrice"] as num?)?.toDouble();
    final discountPercent = ilac["discountPercent"] as int?;
    final campaignLabel = ilac["campaignLabel"] as String?;
    final hasDiscount = originalPrice != null && originalPrice > price;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(ilac["name"]),
        actions: [
          IconButton(
            onPressed: () {
              favorites.toggleFavorite(ilac["name"], userId);
            },
            icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.primaryLight),
              ),
              child: ilac["image"] != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        ilac["image"],
                        height: 200,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.medication,
                            color: AppColors.primaryDark,
                            size: 90,
                          );
                        },
                      ),
                    )
                  : const Icon(
                      Icons.medication,
                      color: AppColors.primaryDark,
                      size: 90,
                    ),
            ),
            const SizedBox(height: 20),
            Text(
              ilac["name"],
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  "${price.toStringAsFixed(2)} TL",
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (hasDiscount) ...[
                  const SizedBox(width: 10),
                  Text(
                    "${originalPrice!.toStringAsFixed(2)} TL",
                    style: const TextStyle(
                      color: Colors.black45,
                      decoration: TextDecoration.lineThrough,
                      fontSize: 14,
                    ),
                  ),
                ],
              ],
            ),
            if (hasDiscount) ...[
              const SizedBox(height: 8),
              _DiscountNotice(
                discountPercent: discountPercent,
                saving: originalPrice! - price,
              ),
            ],
            const SizedBox(height: 20),
            const Text(
              "Açıklama",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(ilac["description"], style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                "Not: Bu bilgiler örnek uygulama içindir. Gerçek ilaç kullanımı için doktora veya eczacıya danışılmalıdır.",
                style: TextStyle(fontSize: 14),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(14),
                ),
                onPressed: () {
                  cart.addItem(
                    ilac["name"],
                    price,
                    originalPrice: hasDiscount ? originalPrice : null,
                    discountPercent: discountPercent,
                    campaignLabel: campaignLabel,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Sepete eklendi")),
                  );
                },
                icon: const Icon(Icons.add_shopping_cart),
                label: const Text("Sepete Ekle"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DiscountNotice extends StatelessWidget {
  final int? discountPercent;
  final double saving;

  const _DiscountNotice({required this.discountPercent, required this.saving});

  @override
  Widget build(BuildContext context) {
    final label = discountPercent == null
        ? "Kampanya uygulandı"
        : "%$discountPercent kampanya uygulandı";

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.shade100),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.local_offer_outlined, color: Colors.green, size: 16),
          const SizedBox(width: 6),
          Text(
            "$label, ${saving.toStringAsFixed(2)} TL kazanç",
            style: const TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
