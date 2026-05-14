import 'package:flutter/material.dart';
import '../data/medicine_data.dart';
import 'ilac_detay_page.dart';
import 'ilac_listesi.dart';
import '../widgets/empty_state.dart';
import '../widgets/price_text.dart';

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
              ),
            ),
          ),
          Expanded(
            child: !hasResult
                ? const EmptyState(
                    icon: Icons.search_off,
                    title: "Sonuç bulunamadı",
                    message: "Farklı bir isimle aramayı deneyebilirsin.",
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
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Theme.of(context).colorScheme.primaryContainer,
          ),
          color: Theme.of(context).cardColor,
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
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  PriceText(price: (medicine["price"] as num).toDouble()),
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
    final theme = Theme.of(context);
    return Container(
      width: 58,
      height: 58,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: theme.colorScheme.primaryContainer),
      ),
      child: imagePath == null
          ? Icon(Icons.medication, color: theme.colorScheme.primary)
          : Image.asset(
              imagePath!,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Icon(Icons.medication, color: theme.colorScheme.primary);
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
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Theme.of(context).colorScheme.primaryContainer,
          ),
          color: Theme.of(context).cardColor,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(radius: 26, child: Icon(category["icon"], size: 28)),
            const SizedBox(height: 10),
            Text(
              category["name"],
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
