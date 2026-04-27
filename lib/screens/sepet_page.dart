import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/cart_model.dart';
import '../theme/app_colors.dart';

class SepetPage extends StatelessWidget {
  const SepetPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Sepet ekranı, sepetteki ürünleri ve toplam fiyatı gösterir.
    // Bu yüzden Cart değişince ekranın yenilenmesi gerekir: watch kullanıyoruz.
    final cart = context.watch<Cart>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Sepetim"),
        backgroundColor: AppColors.navy,
        foregroundColor: Colors.white,
      ),

      body: cart.items.isEmpty
          ? const Center(
              child: Text(
                "Sepetin boş",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: cart.items.length,
              itemBuilder: (context, index) {
                final item = cart.items[index];

                return Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: AppColors.primary,
                      child: Icon(Icons.shopping_bag, color: Colors.white),
                    ),
                    title: Text(item.name),
                    subtitle: Text("${item.price} TL"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            cart.decrease(item);
                          },
                          icon: const Icon(Icons.remove_circle_outline),
                        ),
                        Text(
                          item.quantity.toString(),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          onPressed: () {
                            cart.increase(item);
                          },
                          icon: const Icon(Icons.add_circle_outline),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Ürün: ${cart.totalItems}",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text("Toplam"),
                Text(
                  "${cart.totalPrice} TL",
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
