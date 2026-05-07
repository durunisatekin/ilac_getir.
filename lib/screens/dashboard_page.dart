import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/cart_model.dart';
import '../models/user_model.dart';
import '../theme/app_colors.dart';
import 'favorites_page.dart';
import 'ilac_listesi.dart';
import 'login_page.dart';
import 'notifications_page.dart';
import 'profile_page.dart';
import 'search_page.dart';
import 'siparis_durum_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final PageController campaignController = PageController();
  int selectedCampaign = 0;

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

  final List<Map<String, dynamic>> campaigns = [
    {
      "title": "Dvita ile sağlık kapında",
      "text": "İhtiyacın olan ürünleri hızlıca bul.",
      "icon": Icons.health_and_safety,
      "color": AppColors.navy,
    },
    {
      "title": "Nöbetçi eczaneleri gör",
      "text": "Gece açık eczaneleri tek ekranda incele.",
      "icon": Icons.nightlight_round,
      "color": AppColors.primaryDark,
    },
    {
      "title": "Yakındaki eczaneler",
      "text": "Harita görünümüyle yakın noktaları keşfet.",
      "icon": Icons.map_outlined,
      "color": Colors.deepOrange,
    },
  ];

  @override
  void dispose() {
    campaignController.dispose();
    super.dispose();
  }

  void openPage(Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  @override
  Widget build(BuildContext context) {
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
        actions: [
          IconButton(
            onPressed: () => openPage(const NotificationsPage()),
            icon: const Icon(Icons.notifications_none),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 16),
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: () => openPage(const SearchPage()),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 13,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.primaryLight),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.search, color: AppColors.primaryDark),
                    SizedBox(width: 10),
                    Text("İlaç, vitamin veya kategori ara"),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 170,
            child: PageView.builder(
              controller: campaignController,
              itemCount: campaigns.length,
              onPageChanged: (value) {
                setState(() {
                  selectedCampaign = value;
                });
              },
              itemBuilder: (context, index) {
                final campaign = campaigns[index];

                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: campaign["color"],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              campaign["title"],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              campaign["text"],
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 15,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(campaign["icon"], color: Colors.white, size: 70),
                    ],
                  ),
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(campaigns.length, (index) {
              return Container(
                width: selectedCampaign == index ? 18 : 8,
                height: 8,
                margin: const EdgeInsets.only(top: 8, right: 5),
                decoration: BoxDecoration(
                  color: selectedCampaign == index
                      ? AppColors.primary
                      : Colors.black26,
                  borderRadius: BorderRadius.circular(20),
                ),
              );
            }),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 2.45,
              children: [
                _QuickAction(
                  icon: Icons.map_outlined,
                  title: "Yakındaki Eczaneler",
                  onTap: () =>
                      Navigator.pushNamed(context, "/yakindaki-eczaneler"),
                ),
                _QuickAction(
                  icon: Icons.nightlight_round,
                  title: "Nöbetçi Eczaneler",
                  onTap: () =>
                      Navigator.pushNamed(context, "/nobetci-eczaneler"),
                ),
                _QuickAction(
                  icon: Icons.favorite_border,
                  title: "Favorilerim",
                  onTap: () => openPage(const FavoritesPage()),
                ),
                _QuickAction(
                  icon: Icons.local_shipping_outlined,
                  title: "Sipariş Durumu",
                  onTap: () => openPage(const SiparisDurumPage()),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(12, 8, 12, 4),
            child: Text(
              "Kategoriler",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 112,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: kategoriler.length,
              itemBuilder: (context, index) {
                final kategori = kategoriler[index];

                return GestureDetector(
                  onTap: () =>
                      openPage(IlacListesi(kategori: kategori["type"])),
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
          const Padding(
            padding: EdgeInsets.fromLTRB(12, 16, 12, 8),
            child: Text(
              "Öne çıkanlar",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          const _FeaturedCard(),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const _BottomItem(
              icon: Icons.home,
              title: "Ana Sayfa",
              active: true,
            ),
            _BottomItem(
              icon: Icons.search_outlined,
              title: "Arama",
              onTap: () => openPage(const SearchPage()),
            ),
            _BottomItem(
              icon: Icons.shopping_cart_outlined,
              title: "Sepet",
              badgeCount: cart.totalItems,
              onTap: () => Navigator.pushNamed(context, "/sepet"),
            ),
            _BottomItem(
              icon: Icons.person_outline,
              title: "Hesabım",
              onTap: () {
                final user = context.read<UserModel>();
                openPage(
                  user.isLoggedIn ? const ProfilePage() : const LoginPage(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _QuickAction({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.primaryLight),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primaryDark),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeaturedCard extends StatelessWidget {
  const _FeaturedCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: AppColors.primaryLight,
            child: Icon(
              Icons.health_and_safety,
              color: AppColors.primary,
              size: 34,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Günlük sağlık ihtiyaçları",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text("En çok tercih edilen ürünlere hızlıca ulaş."),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool active;
  final int badgeCount;
  final VoidCallback? onTap;

  const _BottomItem({
    required this.icon,
    required this.title,
    this.active = false,
    this.badgeCount = 0,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = active ? AppColors.primary : Colors.black87;

    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(icon, color: color),
              if (badgeCount > 0)
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
                      badgeCount.toString(),
                      style: const TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(title, style: TextStyle(color: color, fontSize: 12)),
        ],
      ),
    );
  }
}
