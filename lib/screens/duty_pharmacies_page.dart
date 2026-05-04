import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'pharmacy_map_page.dart';

class DutyPharmaciesPage extends StatelessWidget {
  const DutyPharmaciesPage({super.key});

  final String kullaniciKonumu = "Ümraniye - İstiklal Mahallesi";

  final List<Map<String, dynamic>> dutyPharmacies = const [
    {
      "name": "Gece Şifa Eczanesi",
      "district": "Ümraniye",
      "address": "İstiklal Mahallesi, Ümraniye",
      "time": "18:00 - 08:30",
      "phone": "0216 000 00 01",
      "lat": 41.0256,
      "lng": 29.0963,
    },
    {
      "name": "Merkez Nöbetçi Eczanesi",
      "district": "Üsküdar",
      "address": "Mimar Sinan Mahallesi, Üsküdar",
      "time": "18:00 - 08:30",
      "phone": "0216 000 00 02",
      "lat": 41.0214,
      "lng": 29.0157,
    },
    {
      "name": "Sağlık Nöbetçi Eczanesi",
      "district": "Kadıköy",
      "address": "Caferağa Mahallesi, Kadıköy",
      "time": "18:00 - 08:30",
      "phone": "0216 000 00 03",
      "lat": 40.9909,
      "lng": 29.0270,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text("Nöbetçi Eczaneler")),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.navy,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Row(
              children: [
                Icon(Icons.nightlight_round, color: Colors.white, size: 34),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    "Konumuna göre örnek nöbetçi eczaneler",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Konum: $kullaniciKonumu",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          for (final pharmacy in dutyPharmacies)
            Card(
              color: Colors.white,
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: AppColors.primaryLight,
                  child: Icon(Icons.local_pharmacy, color: AppColors.primary),
                ),
                title: Text(pharmacy["name"]),
                subtitle: Text(
                  "${pharmacy["district"]} • ${pharmacy["time"]}\n${pharmacy["phone"]}",
                ),
                isThreeLine: true,
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EczaneHaritaPage(pharmacy: pharmacy),
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
