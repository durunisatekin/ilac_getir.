import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

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
    return Scaffold(
      backgroundColor: AppColors.background,
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
            child: const EczaneHarita(
              lat: 41.0256,
              lng: 29.0963,
              pharmacyName: "Yakındaki eczaneler",
              address: "Örnek konum: Ümraniye",
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            "En yakın eczaneler",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          for (final pharmacy in pharmacies)
            Card(
              color: Colors.white,
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
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text(pharmacy["name"])),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          SizedBox(
            height: 330,
            child: EczaneHarita(
              lat: pharmacy["lat"],
              lng: pharmacy["lng"],
              pharmacyName: pharmacy["name"],
              address: pharmacy["address"],
            ),
          ),
          const SizedBox(height: 12),
          Card(
            color: Colors.white,
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

class EczaneHarita extends StatelessWidget {
  final double lat;
  final double lng;
  final String pharmacyName;
  final String address;

  const EczaneHarita({
    super.key,
    required this.lat,
    required this.lng,
    required this.pharmacyName,
    required this.address,
  });

  @override
  Widget build(BuildContext context) {
    final mapUrl =
        "https://staticmap.openstreetmap.de/staticmap.php?center=$lat,$lng&zoom=15&size=700x420&markers=$lat,$lng,red-pushpin";

    return Stack(
      fit: StackFit.expand,
      children: [
        Image.network(
          mapUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: const Color(0xFFE7F2EC),
              child: const Center(
                child: Icon(
                  Icons.map_outlined,
                  size: 90,
                  color: AppColors.primary,
                ),
              ),
            );
          },
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(color: Colors.black26, blurRadius: 8),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.location_on, color: AppColors.primary),
                const SizedBox(width: 8),
                Flexible(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pharmacyName,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(address, style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
