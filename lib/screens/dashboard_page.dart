import 'package:flutter/material.dart';
import 'ilac_listesi.dart';
import '../models/cart_model.dart';

class DashboardPage extends StatefulWidget {
  final Cart cart;

  DashboardPage({required this.cart});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String searchText = "";

  final List<Map<String, dynamic>> kategoriler = [
    {"name": "Ağrı Kesici", "type": "agri", "color": Colors.red},
    {"name": "Vitamin", "type": "vitamin", "color": Colors.orange},
    {"name": "Soğuk Algınlığı", "type": "soguk", "color": Colors.blue},
    {"name": "Kas Gevşetici", "type": "kas", "color": Colors.pink},
    {"name": "Mide", "type": "mide", "color": Colors.green},
    {"name": "Diğer", "type": "diger", "color": Colors.purple},
  ];

  @override
  Widget build(BuildContext context) {
    final filtered = kategoriler
        .where(
          (k) => k["name"].toLowerCase().contains(searchText.toLowerCase()),
        )
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text("İlaçlar"),
        backgroundColor: Colors.purple,
        actions: [
          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () async {
                  await Navigator.pushNamed(context, "/sepet");
                  setState(() {}); // 🔥 sepetten dönünce güncelle
                },
              ),

              // 🔴 BADGE
              if (widget.cart.totalItems > 0)
                Positioned(
                  right: 6,
                  top: 6,
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      widget.cart.totalItems.toString(),
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),

      body: Column(
        children: [
          // 🔍 ARAMA ÇUBUĞU
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchText = value;
                });
              },
              decoration: InputDecoration(
                hintText: "Kategori ara...",
                prefixIcon: Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey.shade200,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // 🎨 KATEGORİ KARTLARI
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(12),
              itemCount: filtered.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemBuilder: (context, index) {
                final kategori = filtered[index];

                return GestureDetector(
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => IlacListesi(
                          cart: widget.cart,
                          kategori: kategori["type"],
                        ),
                      ),
                    );

                    setState(() {}); // 🔥 geri dönünce badge günceller
                  },

                  child: Container(
                    decoration: BoxDecoration(
                      color: kategori["color"],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(
                        kategori["name"],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
