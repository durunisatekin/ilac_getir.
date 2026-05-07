import 'package:flutter/material.dart';
import '../data/medicine_data.dart';
import '../theme/app_colors.dart';
import 'ilac_detay_page.dart';
import 'ilac_listesi.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String searchText = "";

  @override
  Widget build(BuildContext context) {
    final filteredCategories = medicineCategories
        .where(
          (category) => category["name"].toString().toLowerCase().contains(
            searchText.toLowerCase(),
          ),
        )
        .toList();

    final filteredMedicines = medicines
        .where(
          (medicine) => medicine["name"].toString().toLowerCase().contains(
            searchText.toLowerCase(),
          ),
        )
        .toList();

    final hasSearch = searchText.isNotEmpty;
    final hasResult =
        filteredCategories.isNotEmpty || filteredMedicines.isNotEmpty;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text("Arama")),
      body: Column(
        children: [
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
                        final medicine = filteredMedicines[index];

                        return _MedicineResult(medicine: medicine);
                      }

                      final categoryIndex = hasSearch
                          ? index - filteredMedicines.length
                          : index;
                      final category = filteredCategories[categoryIndex];

                      return _CategoryResult(category: category);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _MedicineResult extends StatelessWidget {
  final Map<String, dynamic> medicine;

  const _MedicineResult({required this.medicine});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => IlacDetayPage(ilac: medicine)),
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
            _MedicineImage(imagePath: medicine["image"]),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    medicine["name"],
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.navy,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text("${medicine["price"]} TL"),
                ],
              ),
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}

class _MedicineImage extends StatelessWidget {
  final String? imagePath;

  const _MedicineImage({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 58,
      height: 58,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.primaryLight),
      ),
      child: imagePath == null
          ? const Icon(Icons.medication, color: AppColors.primaryDark)
          : Image.asset(
              imagePath!,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(
                  Icons.medication,
                  color: AppColors.primaryDark,
                );
              },
            ),
    );
  }
}

class _CategoryResult extends StatelessWidget {
  final Map<String, dynamic> category;

  const _CategoryResult({required this.category});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => IlacListesi(kategori: category["type"]),
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
                category["icon"],
                color: AppColors.primaryDark,
                size: 28,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              category["name"],
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
  }
}
