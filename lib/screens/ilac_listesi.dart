import 'package:flutter/material.dart';
import '../models/cart_model.dart';

class IlacListesi extends StatelessWidget {
  final Cart cart;
  final String kategori;

  IlacListesi({required this.cart, required this.kategori});

  final List<Map<String, dynamic>> tumIlaclar = [
    {"name": "Parol", "price": 50.0, "type": "agri"},
    {"name": "Dolven", "price": 60.0, "type": "agri"},
    {"name": "Arveles", "price": 80.0, "type": "agri"},
    {"name": "Majezik", "price": 70.0, "type": "agri"},
    {"name": "Ocean", "price": 70.0, "type": "vitamin"},
    {"name": "Solgar B12", "price": 200.0, "type": "vitamin"},
    {"name": "Supradyn", "price": 300.0, "type": "vitamin"},
    {"name": "Kiperin", "price": 500.0, "type": "vitamin"},
    {"name": "Rennie", "price": 150.0, "type": "mide"},
    {"name": "Gaviscon", "price": 180.0, "type": "mide"},
    {"name": "Lansor", "price": 220.0, "type": "mide"},
    {"name": "Omeprol", "price": 240.0, "type": "mide"},
    {"name": "Parafon", "price": 90.0, "type": "kas"},
    {"name": "Cabral", "price": 240.0, "type": "kas"},
    {"name": "Lioresal", "price": 240.0, "type": "kas"},
    {"name": "Tizanidin", "price": 240.0, "type": "kas"},
    {"name": "Aferin", "price": 170.0, "type": "soguk"},
    {"name": "Tylol Hot", "price": 40.0, "type": "soguk"},
    {"name": "Gripin", "price": 60.0, "type": "soguk"},
    {"name": "İbuCold", "price": 130.0, "type": "soguk"},
  ];

  @override
  Widget build(BuildContext context) {
    final ilaclar = tumIlaclar.where((i) => i["type"] == kategori).toList();

    return Scaffold(
      appBar: AppBar(title: Text("İlaçlar")),
      body: ListView.builder(
        itemCount: ilaclar.length,
        itemBuilder: (context, index) {
          final ilac = ilaclar[index];

          return ListTile(
            title: Text(ilac["name"]),
            subtitle: Text("${ilac["price"]} TL"),
            trailing: ElevatedButton(
              onPressed: () {
                cart.addItem(ilac["name"], ilac["price"]);

                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text("Sepete eklendi")));
              },
              child: Text("Sepete Ekle"),
            ),
          );
        },
      ),
    );
  }
}
