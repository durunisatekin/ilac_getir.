import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  final List<Map<String, dynamic>> notifications = const [
    {
      "title": "Siparişin hazırlanıyor",
      "message": "Eczane ürünlerini kontrol ediyor.",
      "icon": Icons.inventory_2_outlined,
    },
    {
      "title": "Nöbetçi eczane bilgisi güncellendi",
      "message": "Yakınındaki açık eczaneleri görüntüleyebilirsin.",
      "icon": Icons.local_pharmacy_outlined,
    },
    {
      "title": "Vitamin fırsatı",
      "message": "Bugüne özel seçili vitaminlerde indirim var.",
      "icon": Icons.discount_outlined,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text("Bildirimler")),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final item = notifications[index];

          return Card(
            color: Colors.white,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: AppColors.primaryLight,
                child: Icon(item["icon"], color: AppColors.primaryDark),
              ),
              title: Text(
                item["title"],
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(item["message"]),
            ),
          );
        },
      ),
    );
  }
}
