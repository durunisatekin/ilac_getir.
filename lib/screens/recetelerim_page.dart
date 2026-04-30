import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';

class RecetelerimPage extends StatefulWidget {
  const RecetelerimPage({super.key});

  @override
  State<RecetelerimPage> createState() => _RecetelerimPageState();
}

class _RecetelerimPageState extends State<RecetelerimPage> {
  static const String _kayitliTc = "11111111111";
  static const String _kayitliReceteKodu = "A0X24";

  String tc = "";
  String receteKodu = "";
  bool receteGoster = false;

  void receteSorgula() {
    if (tc.length != 11) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("TC kimlik numarası 11 haneli olmalı")),
      );
      return;
    }

    if (receteKodu.length != 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Reçete kodu 5 karakterli olmalı")),
      );
      return;
    }

    if (tc == _kayitliTc && receteKodu.toUpperCase() == _kayitliReceteKodu) {
      setState(() {
        receteGoster = true;
      });
    } else {
      setState(() {
        receteGoster = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Bu bilgilerle reçete bulunamadı")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Reçetelerim"),
        backgroundColor: AppColors.navy,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(11),
            ],
            decoration: const InputDecoration(
              labelText: "TC Kimlik Numarası",
              hintText: "TC kimlik numaranızı giriniz",
              helperText: "TC kimlik numarası 11 haneli olmalı",
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              tc = value;
            },
          ),
          const SizedBox(height: 14),
          TextField(
            textCapitalization: TextCapitalization.characters,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp("[a-zA-Z0-9]")),
              LengthLimitingTextInputFormatter(5),
            ],
            decoration: const InputDecoration(
              labelText: "Reçete Kodu",
              helperText: "Reçete kodu 5 karakterli olmalı",
              border: OutlineInputBorder(),
            ),
            onChanged: (value) {
              receteKodu = value;
            },
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: receteSorgula,
              child: const Text("Reçeteyi Göster"),
            ),
          ),
          const SizedBox(height: 20),
          if (receteGoster)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Reçetendeki İlaçlar",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Card(
                  child: ListTile(
                    leading: const Icon(
                      Icons.medication,
                      color: AppColors.primary,
                    ),
                    title: const Text("Augmentin"),
                    subtitle: const Text("Antibiyotik - 1 kutu"),
                    trailing: const Text("Reçeteli"),
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: const Icon(
                      Icons.medication,
                      color: AppColors.primary,
                    ),
                    title: const Text("Parol"),
                    subtitle: const Text("Ağrı kesici - 1 kutu"),
                    trailing: const Text("Reçetede var"),
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: const Icon(
                      Icons.medication,
                      color: AppColors.primary,
                    ),
                    title: const Text("Coldaway"),
                    subtitle: const Text("Soğuk algınlığı - 1 kutu"),
                    trailing: const Text("Reçetede var"),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
