import 'package:flutter/material.dart';
import '../models/cart_model.dart';

class IlacListesi extends StatefulWidget {
  final Cart cart;
  final String kategori;

  const IlacListesi({super.key, required this.cart, required this.kategori});

  @override
  State<IlacListesi> createState() => _IlacListesiState();
}

class _IlacListesiState extends State<IlacListesi> {
  String search = "";

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
    final ilaclar = tumIlaclar.where((i) {
      return i["type"] == widget.kategori &&
          i["name"].toLowerCase().contains(search.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text("İlaçlar")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: "İlaç ara...",
                border: OutlineInputBorder(),
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
              itemCount: ilaclar.length,
              itemBuilder: (context, index) {
                final ilac = ilaclar[index];

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  child: ListTile(
                    title: Text(ilac["name"]),
                    subtitle: Text("${ilac["price"]} TL"),
                    trailing: ElevatedButton(
                      onPressed: () {
                        widget.cart.addItem(ilac["name"], ilac["price"]);

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Sepete eklendi"),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      },
                      child: const Text("Sepete Ekle"),
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
