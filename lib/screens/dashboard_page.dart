import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'ilac_listesi.dart';
import 'login_page.dart';
import 'profile_page.dart';
import 'search_page.dart';
import '../models/cart_model.dart';
import '../models/user_model.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final List<Map<String, dynamic>> kategoriler = [
    {
      "name": "Ağrı Kesici",
      "type": "agri",
      "color": Colors.red,
      "icon": Icons.healing,
    },
    {
      "name": "Vitamin",
      "type": "vitamin",
      "color": Colors.orange,
      "icon": Icons.local_pharmacy,
    },
    {
      "name": "Soğuk Algınlığı",
      "type": "soguk",
      "color": Colors.blue,
      "icon": Icons.ac_unit,
    },
    {
      "name": "Kas Gevşetici",
      "type": "kas",
      "color": Colors.pink,
      "icon": Icons.accessibility_new,
    },
    {
      "name": "Mide",
      "type": "mide",
      "color": Colors.green,
      "icon": Icons.medication,
    },
    {
      "name": "Diğer",
      "type": "diger",
      "color": Colors.purple,
      "icon": Icons.more_horiz,
    },
  ];

  @override
  Widget build(BuildContext context) {
    // context.watch<Cart>(), Provider'daki Cart nesnesini okur ve dinler.
    // Cart değişirse bu build metodu yeniden çalışır; rozet sayısı güncellenir.
    final cart = context.watch<Cart>();

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("İlaç Getir"),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),

      body: Column(
        children: [
          // Bu alan ana sayfanın vitrini gibi çalışır.
          // Kampanya ve mesaj alanları kullanıcıya uygulamanın amacını gösterir.
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.teal,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Sağlık ürünleri kapında",
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
                SizedBox(height: 6),
                Text(
                  "İhtiyacın olan ürünleri hızlıca bul",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  "Vitamin, mide, soğuk algınlığı ve daha fazlası.",
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      "Bugüne özel vitamin ürünlerinde fırsatlar",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.local_shipping, color: Colors.green),
                ),
              ],
            ),
          ),

          const Padding(
            padding: EdgeInsets.fromLTRB(12, 16, 12, 4),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Kategoriler",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          // Kategori kartları: GridView ekranda 2 sütunlu kartlar oluşturur.
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: kategoriler.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemBuilder: (context, index) {
                final kategori = kategoriler[index];

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => IlacListesi(kategori: kategori["type"]),
                      ),
                    );
                  },

                  child: Container(
                    decoration: BoxDecoration(
                      color: kategori["color"],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(kategori["icon"], color: Colors.white, size: 36),
                        const SizedBox(height: 10),
                        Text(
                          kategori["name"],
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 17,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
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

      // bottomNavigationBar ekranın altında sabit duran menüdür.
      // Burada Trendyol gibi Ana Sayfa / Sepet / Hesabım alanı yapıyoruz.
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.home, color: Colors.teal),
                SizedBox(height: 4),
                Text(
                  "Ana Sayfa",
                  style: TextStyle(color: Colors.teal, fontSize: 12),
                ),
              ],
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SearchPage()),
                );
              },
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.search_outlined),
                  SizedBox(height: 4),
                  Text("Arama", style: TextStyle(fontSize: 12)),
                ],
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, "/sepet");
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      const Icon(Icons.shopping_cart_outlined),

                      // Sepette ürün varsa ikonun üstünde küçük sayı gösteriyoruz.
                      if (cart.totalItems > 0)
                        Positioned(
                          right: -8,
                          top: -8,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              cart.totalItems.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text("Sepet", style: TextStyle(fontSize: 12)),
                ],
              ),
            ),
            InkWell(
              onTap: () {
                final user = context.read<UserModel>();

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => user.isLoggedIn
                        ? const ProfilePage()
                        : const LoginPage(),
                  ),
                );
              },
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.person_outline),
                  SizedBox(height: 4),
                  Text("Hesabım", style: TextStyle(fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
