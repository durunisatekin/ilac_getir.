import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'ilac_detay_page.dart';
import '../models/cart_model.dart';

class IlacListesi extends StatefulWidget {
  final String kategori;

  const IlacListesi({super.key, required this.kategori});

  @override
  State<IlacListesi> createState() => _IlacListesiState();
}

class _IlacListesiState extends State<IlacListesi> {
  String search = "";

  // Bu fonksiyon kategori kodunu kullanıcıya görünen başlığa çevirir.
  // Örnek: "agri" kodu ekranda "Ağrı Kesici" olarak görünür.
  String kategoriBasligi() {
    if (widget.kategori == "agri") {
      return "Ağrı Kesici";
    } else if (widget.kategori == "vitamin") {
      return "Vitamin";
    } else if (widget.kategori == "soguk") {
      return "Soğuk Algınlığı";
    } else if (widget.kategori == "kas") {
      return "Kas Gevşetici";
    } else if (widget.kategori == "mide") {
      return "Mide";
    } else {
      return "Diğer";
    }
  }

  final List<Map<String, dynamic>> tumIlaclar = [
    {
      "name": "Parol",
      "price": 50.0,
      "type": "agri",
      "description": "Ağrı kesici kategorisinde örnek bir üründür.",
    },
    {
      "name": "Dolven",
      "price": 60.0,
      "type": "agri",
      "description": "Ağrı kesici kategorisinde örnek bir üründür.",
    },
    {
      "name": "Arveles",
      "price": 80.0,
      "type": "agri",
      "description": "Ağrı kesici kategorisinde örnek bir üründür.",
    },
    {
      "name": "Majezik",
      "price": 70.0,
      "type": "agri",
      "description": "Ağrı kesici kategorisinde örnek bir üründür.",
    },
    {
      "name": "Ocean",
      "price": 70.0,
      "type": "vitamin",
      "description": "Vitamin kategorisinde örnek bir üründür.",
    },
    {
      "name": "Solgar B12",
      "price": 200.0,
      "type": "vitamin",
      "description": "Vitamin kategorisinde örnek bir üründür.",
    },
    {
      "name": "Supradyn",
      "price": 300.0,
      "type": "vitamin",
      "description": "Vitamin kategorisinde örnek bir üründür.",
    },
    {
      "name": "Kiperin",
      "price": 500.0,
      "type": "vitamin",
      "description": "Vitamin kategorisinde örnek bir üründür.",
    },
    {
      "name": "Rennie",
      "price": 150.0,
      "type": "mide",
      "description": "Mide kategorisinde örnek bir üründür.",
    },
    {
      "name": "Gaviscon",
      "price": 180.0,
      "type": "mide",
      "description": "Mide kategorisinde örnek bir üründür.",
    },
    {
      "name": "Lansor",
      "price": 220.0,
      "type": "mide",
      "description": "Mide kategorisinde örnek bir üründür.",
    },
    {
      "name": "Omeprol",
      "price": 240.0,
      "type": "mide",
      "description": "Mide kategorisinde örnek bir üründür.",
    },
    {
      "name": "Parafon",
      "price": 90.0,
      "type": "kas",
      "description": "Kas gevşetici kategorisinde örnek bir üründür.",
    },
    {
      "name": "Cabral",
      "price": 240.0,
      "type": "kas",
      "description": "Kas gevşetici kategorisinde örnek bir üründür.",
    },
    {
      "name": "Lioresal",
      "price": 240.0,
      "type": "kas",
      "description": "Kas gevşetici kategorisinde örnek bir üründür.",
    },
    {
      "name": "Tizanidin",
      "price": 240.0,
      "type": "kas",
      "description": "Kas gevşetici kategorisinde örnek bir üründür.",
    },
    {
      "name": "Aferin",
      "price": 170.0,
      "type": "soguk",
      "description": "Soğuk algınlığı kategorisinde örnek bir üründür.",
    },
    {
      "name": "Tylol Hot",
      "price": 40.0,
      "type": "soguk",
      "description": "Soğuk algınlığı kategorisinde örnek bir üründür.",
    },
    {
      "name": "Gripin",
      "price": 60.0,
      "type": "soguk",
      "description": "Soğuk algınlığı kategorisinde örnek bir üründür.",
    },
    {
      "name": "İbuCold",
      "price": 130.0,
      "type": "soguk",
      "description": "Soğuk algınlığı kategorisinde örnek bir üründür.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    // Burada watch yerine read kullanıyoruz.
    // Bu ekran sepet sayısını göstermiyor, sadece butona basınca sepete ekliyor.
    final cart = context.read<Cart>();

    final ilaclar = tumIlaclar.where((i) {
      return i["type"] == widget.kategori &&
          i["name"].toLowerCase().contains(search.toLowerCase());
    }).toList();

    final baslik = kategoriBasligi();

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text("$baslik İlaçları"),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
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
              "$baslik kategorisindeki ilaçlar",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),

          // TextField arama kutusudur.
          // onChanged her harf yazıldığında çalışır ve listeyi filtreler.
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
            // ListView.builder, uzun listelerde sadece görünen satırları üretir.
            // Bu yüzden performanslı bir liste oluşturma yöntemidir.
            child: ListView.builder(
              itemCount: ilaclar.length,
              itemBuilder: (context, index) {
                final ilac = ilaclar[index];

                return Card(
                  color: Colors.white,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    onTap: () {
                      // Navigator.push ile yeni bir sayfaya geçiyoruz.
                      // ilac bilgisini detay sayfasına gönderiyoruz.
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => IlacDetayPage(ilac: ilac),
                        ),
                      );
                    },
                    leading: const CircleAvatar(
                      backgroundColor: Colors.teal,
                      child: Icon(Icons.medication, color: Colors.white),
                    ),
                    title: Text(ilac["name"]),
                    subtitle: Text("${ilac["price"]} TL"),
                    trailing: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        cart.addItem(ilac["name"], ilac["price"]);

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
