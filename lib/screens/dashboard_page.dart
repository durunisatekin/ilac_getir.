import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'ilac_listesi.dart';
import 'login_page.dart';
import 'profile_page.dart';
import 'search_page.dart';
import '../models/cart_model.dart';
import '../models/user_model.dart';
import '../theme/app_colors.dart';

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
      backgroundColor: AppColors.background,
      appBar: AppBar(
        toolbarHeight: 72,
        title: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                "assets/images/dvita_logo.png",
                width: 48,
                height: 48,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 10),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Dvita",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  "İlaç kapında",
                  style: TextStyle(fontSize: 12, color: Colors.white70),
                ),
              ],
            ),
          ],
        ),
        backgroundColor: AppColors.navy,
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
              color: AppColors.navy,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Dvita ile sağlık kapında",
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
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Image.asset(
                    "assets/images/dvita_logo.png",
                    width: 58,
                    height: 58,
                    fit: BoxFit.cover,
                  ),
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
                      color: AppColors.primaryLight,
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
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.local_shipping,
                    color: AppColors.primaryDark,
                  ),
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

          // Ana sayfada kategorileri küçük tutuyoruz.
          // Böylece ekran daha çok alışveriş uygulaması vitrini gibi görünür.
          SizedBox(
            height: 112,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: kategoriler.length,
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
                    width: 105,
                    margin: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          backgroundColor: kategori["color"],
                          child: Icon(
                            kategori["icon"],
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          kategori["name"],
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.black87,
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

          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(12),
              children: [
                const Text(
                  "Öne çıkanlar",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.health_and_safety,
                          color: AppColors.primary,
                          size: 34,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Günlük sağlık ihtiyaçları",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text("En çok tercih edilen ürünlere hızlıca ulaş."),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
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
                Icon(Icons.home, color: AppColors.primary),
                SizedBox(height: 4),
                Text(
                  "Ana Sayfa",
                  style: TextStyle(color: AppColors.primary, fontSize: 12),
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
