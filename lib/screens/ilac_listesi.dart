import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/medicine_data.dart';
import '../models/cart_model.dart';
import '../models/favorite_model.dart';
import '../theme/app_colors.dart';
import 'ilac_detay_page.dart';

class IlacListesi extends StatefulWidget {
  final String kategori;

  const IlacListesi({super.key, required this.kategori});

  @override
  State<IlacListesi> createState() => _IlacListesiState();
}

class _IlacListesiState extends State<IlacListesi> {
  String search = "";

  @override
  Widget build(BuildContext context) {
    final cart = context.read<Cart>();
    final favorites = context.watch<FavoriteModel>();
    final baslik = categoryTitle(widget.kategori);

    final filteredMedicines = medicines.where((medicine) {
      final sameCategory = medicine["type"] == widget.kategori;
      final matchesSearch = medicine["name"].toString().toLowerCase().contains(
        search.toLowerCase(),
      );

      return sameCategory && matchesSearch;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text("$baslik İlaçları")),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              "$baslik kategorisindeki ürünler",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: InputDecoration(
                hintText: "İlaç ara...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  search = value;
                });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredMedicines.length,
              itemBuilder: (context, index) {
                final medicine = filteredMedicines[index];
                final isFavorite = favorites.isFavorite(medicine["name"]);

                return Card(
                  color: Colors.white,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => IlacDetayPage(ilac: medicine),
                        ),
                      );
                    },
                    leading: _MedicineImage(imagePath: medicine["image"]),
                    title: Text(medicine["name"]),
                    subtitle: Text("${medicine["price"]} TL"),
                    trailing: Wrap(
                      spacing: 4,
                      children: [
                        IconButton(
                          onPressed: () {
                            favorites.toggleFavorite(medicine["name"]);
                          },
                          icon: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: isFavorite ? Colors.red : Colors.black54,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            cart.addItem(medicine["name"], medicine["price"]);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Sepete eklendi"),
                                duration: Duration(seconds: 1),
                              ),
                            );
                          },
                          icon: const Icon(Icons.add_shopping_cart),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _MedicineImage extends StatelessWidget {
  final String? imagePath;

  const _MedicineImage({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 58,
      height: 58,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.primaryLight),
      ),
      child: imagePath == null
          ? const Icon(Icons.medication, color: AppColors.primaryDark)
          : Image.asset(
              imagePath!,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(
                  Icons.medication,
                  color: AppColors.primaryDark,
                );
              },
            ),
    );
  }
}
