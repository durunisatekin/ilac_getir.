import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../theme/app_colors.dart';
import '../widgets/section_header.dart';

class PharmacyMapPage extends StatelessWidget {
  const PharmacyMapPage({super.key});

  final List<Map<String, dynamic>> pharmacies = const [
    {
      "name": "Dvita Merkez Eczanesi",
      "distance": "450 m",
      "address": "İstiklal Mahallesi, Ümraniye",
      "status": "Açık",
      "lat": 41.0256,
      "lng": 29.0963,
    },
    {
      "name": "Şifa Eczanesi",
      "distance": "900 m",
      "address": "Mimar Sinan Mahallesi, Üsküdar",
      "status": "Açık",
      "lat": 41.0214,
      "lng": 29.0157,
    },
    {
      "name": "Hayat Eczanesi",
      "distance": "1.4 km",
      "address": "Caferağa Mahallesi, Kadıköy",
      "status": "Yoğun",
      "lat": 40.9909,
      "lng": 29.0270,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final first = pharmacies.first;
    final center = LatLng(first["lat"], first["lng"]);

    return Scaffold(
      appBar: AppBar(title: const Text("Yakındaki Eczaneler")),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          Container(
            height: 230,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.primaryLight),
            ),
            clipBehavior: Clip.antiAlias,
            child: _PharmacyMap(
              center: center,
              pharmacies: pharmacies,
            ),
          ),
          const SectionHeader(
            title: "En yakın eczaneler",
            padding: EdgeInsets.fromLTRB(0, 14, 0, 8),
          ),
          for (final pharmacy in pharmacies)
            Card(
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: AppColors.primaryLight,
                  child: Icon(Icons.local_pharmacy, color: AppColors.primary),
                ),
                title: Text(pharmacy["name"]),
                subtitle: Text("${pharmacy["address"]} • ${pharmacy["distance"]}"),
                trailing: Text(
                  pharmacy["status"],
                  style: const TextStyle(
                    color: AppColors.primaryDark,
                    fontWeight: FontWeight.bold,
                  ),
                ),
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

class EczaneHaritaPage extends StatelessWidget {
  final Map<String, dynamic> pharmacy;

  const EczaneHaritaPage({super.key, required this.pharmacy});

  @override
  Widget build(BuildContext context) {
    final center = LatLng(pharmacy["lat"], pharmacy["lng"]);
    return Scaffold(
      appBar: AppBar(title: Text(pharmacy["name"])),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          SizedBox(
            height: 330,
            child: _PharmacyMap(
              center: center,
              pharmacies: [pharmacy],
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: const Icon(Icons.local_pharmacy, color: AppColors.primary),
              title: Text(pharmacy["name"]),
              subtitle: Text(pharmacy["address"]),
            ),
          ),
        ],
      ),
    );
  }
}

class _PharmacyMap extends StatelessWidget {
  final LatLng center;
  final List<Map<String, dynamic>> pharmacies;

  const _PharmacyMap({
    required this.center,
    required this.pharmacies,
  });

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        initialCenter: center,
        initialZoom: 14.5,
      ),
      children: [
        TileLayer(
          urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
          userAgentPackageName: "com.example.ilac_getir",
        ),
        MarkerLayer(
          markers: pharmacies.map((pharmacy) {
            final pos = LatLng(pharmacy["lat"], pharmacy["lng"]);
            return Marker(
              point: pos,
              width: 48,
              height: 48,
              child: GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(pharmacy["name"])),
                  );
                },
                child: const Icon(
                  Icons.location_on,
                  color: AppColors.primary,
                  size: 42,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
