import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/medicine_data.dart';
import '../models/cart_model.dart';
import '../models/favorite_model.dart';
import '../models/user_model.dart';
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
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "$baslik",
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () {
              showSearch(
                context: context,
                delegate: MedicineSearchDelegate(filteredMedicines),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Arama çubuğu
          Container(
            margin: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: "$baslik ürünlerinde ara...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onChanged: (value) {
                setState(() {
                  search = value;
                });
              },
            ),
          ),
          // Grid liste
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.65,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: filteredMedicines.length,
                itemBuilder: (context, index) {
                  final medicine = filteredMedicines[index];
                  final user = context.read<UserModel>();
                  final userId = user.phone.isNotEmpty ? user.phone : "guest_${user.name}";
                  final isFavorite = favorites.isFavorite(medicine["name"] as String, userId);

                  return ProductCard(
                    medicine: medicine,
                    isFavorite: isFavorite,
                    onFavorite: () {
                      favorites.toggleFavorite(medicine["name"] as String, userId);
                    },
                    onAddToCart: () {
                      cart.addItem(medicine["name"], medicine["price"]);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("${medicine["name"]} sepete eklendi"),
                          duration: const Duration(seconds: 2),
                          backgroundColor: Colors.green,
                        ),
                      );
                    },
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => IlacDetayPage(ilac: medicine),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Map<String, dynamic> medicine;
  final bool isFavorite;
  final VoidCallback onFavorite;
  final VoidCallback onAddToCart;
  final VoidCallback onTap;

  const ProductCard({
    super.key,
    required this.medicine,
    required this.isFavorite,
    required this.onFavorite,
    required this.onAddToCart,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.white.withAlpha(51),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Etiketler
            if (medicine["tag"] != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getTagColor(medicine["tag"]),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: Text(
                  medicine["tag"],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            // Ürün resmi
            Expanded(
              flex: 3,
              child: Container(
                padding: const EdgeInsets.all(16),
                child: medicine["image"] != null
                    ? Image.asset(
                        medicine["image"],
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[100],
                            child: const Icon(
                              Icons.medication,
                              size: 48,
                              color: Colors.grey,
                            ),
                          );
                        },
                      )
                    : Container(
                        color: Colors.grey[100],
                        child: const Icon(
                          Icons.medication,
                          size: 48,
                          color: Colors.grey,
                        ),
                      ),
              ),
            ),
            // Ürün bilgileri
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      medicine["name"],
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "${medicine["price"]} TL",
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                    const Spacer(),
                    // Butonlar
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: onAddToCart,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                              minimumSize: Size.zero,
                            ),
                            child: const Text(
                              "Ekle",
                              style: TextStyle(fontSize: 9),
                            ),
                          ),
                        ),
                        const SizedBox(width: 2),
                        IconButton(
                          onPressed: onFavorite,
                          icon: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: isFavorite ? Colors.red : Colors.grey[600],
                            size: 18,
                          ),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(
                            minWidth: 28,
                            minHeight: 28,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getTagColor(String tag) {
    switch (tag) {
      case "En Çok Satan":
        return Colors.red;
      case "Uygun Fiyat":
        return Colors.green;
      case "Doğal İçerik":
        return const Color(0xFF4CAF50);
      case "Premium":
        return const Color(0xFF9C27B0);
      case "2'si 1 Arada":
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}

class MedicineSearchDelegate extends SearchDelegate<String> {
  final List<Map<String, dynamic>> medicines;

  MedicineSearchDelegate(this.medicines);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = medicines.where((medicine) {
      return medicine["name"].toString().toLowerCase().contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final medicine = results[index];
        return ListTile(
          title: Text(medicine["name"]),
          subtitle: Text("${medicine["price"]} TL"),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => IlacDetayPage(ilac: medicine),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = medicines.where((medicine) {
      return medicine["name"].toString().toLowerCase().contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final medicine = suggestions[index];
        return ListTile(
          title: Text(medicine["name"]),
          subtitle: Text("${medicine["price"]} TL"),
          onTap: () {
            query = medicine["name"];
            buildResults(context);
          },
        );
      },
    );
  }
}
