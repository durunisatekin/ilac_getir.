import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/cart_model.dart';

class IlacDetayPage extends StatelessWidget {
  final Map<String, dynamic> ilac;

  const IlacDetayPage({super.key, required this.ilac});

  @override
  Widget build(BuildContext context) {
    // read kullanıyoruz çünkü burada sadece butona basınca sepete ekleme yapacağız.
    final cart = context.read<Cart>();

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text(ilac["name"]),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
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
                color: Colors.teal,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.medication,
                color: Colors.white,
                size: 90,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              ilac["name"],
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "${ilac["price"]} TL",
              style: const TextStyle(
                color: Colors.teal,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
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
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(14),
                ),
                onPressed: () {
                  cart.addItem(ilac["name"], ilac["price"]);

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
