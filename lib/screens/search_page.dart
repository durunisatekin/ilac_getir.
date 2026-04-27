import 'package:flutter/material.dart';
import 'ilac_detay_page.dart';
import 'ilac_listesi.dart';
import '../theme/app_colors.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String searchText = "";

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
    final filteredCategories = kategoriler
        .where(
          (k) => k["name"].toLowerCase().contains(searchText.toLowerCase()),
        )
        .toList();

    final filteredMedicines = tumIlaclar
        .where(
          (i) => i["name"].toLowerCase().contains(searchText.toLowerCase()),
        )
        .toList();

    final hasSearch = searchText.isNotEmpty;
    final hasResult =
        filteredCategories.isNotEmpty || filteredMedicines.isNotEmpty;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Arama"),
        backgroundColor: AppColors.navy,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Arama kutusu ayrı bir sayfada duruyor.
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              autofocus: true,
              onChanged: (value) {
                setState(() {
                  searchText = value;
                });
              },
              decoration: InputDecoration(
                hintText: "İlaç veya kategori ara...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          Expanded(
            child: !hasResult
                ? const Center(
                    child: Text(
                      "Sonuç bulunamadı",
                      style: TextStyle(fontSize: 18),
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: hasSearch
                        ? filteredMedicines.length + filteredCategories.length
                        : filteredCategories.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: hasSearch ? 1 : 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      mainAxisExtent: hasSearch ? 86 : 160,
                    ),
                    itemBuilder: (context, index) {
                      if (hasSearch && index < filteredMedicines.length) {
                        final ilac = filteredMedicines[index];

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => IlacDetayPage(ilac: ilac),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.card,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: AppColors.primaryLight),
                            ),
                            child: Row(
                              children: [
                                const CircleAvatar(
                                  backgroundColor: AppColors.primaryLight,
                                  child: Icon(
                                    Icons.medication,
                                    color: AppColors.primaryDark,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        ilac["name"],
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: AppColors.navy,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text("${ilac["price"]} TL"),
                                    ],
                                  ),
                                ),
                                const Icon(Icons.chevron_right),
                              ],
                            ),
                          ),
                        );
                      }

                      final categoryIndex = hasSearch
                          ? index - filteredMedicines.length
                          : index;
                      final kategori = filteredCategories[categoryIndex];

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  IlacListesi(kategori: kategori["type"]),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.card,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.primaryLight),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: 26,
                                backgroundColor: AppColors.primaryLight,
                                child: Icon(
                                  kategori["icon"],
                                  color: AppColors.primaryDark,
                                  size: 28,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                kategori["name"],
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 17,
                                  color: AppColors.navy,
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
    );
  }
}
