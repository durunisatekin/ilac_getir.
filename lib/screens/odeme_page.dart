import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/cart_model.dart';
import '../theme/app_colors.dart';
import 'siparis_durum_page.dart';

class OdemePage extends StatefulWidget {
  const OdemePage({super.key});

  @override
  State<OdemePage> createState() => _OdemePageState();
}

class _OdemePageState extends State<OdemePage> {
  final TextEditingController kartController = TextEditingController();
  final TextEditingController tarihController = TextEditingController();
  final TextEditingController cvvController = TextEditingController();

  String seciliOdeme = "kart";
  String hataMesaji = "";

  Future<void> odemeyiTamamla() async {
    final cart = context.read<Cart>();

    if (cart.items.isEmpty) {
      setState(() {
        hataMesaji = "Sepetiniz boş";
      });
      return;
    }

    String girilenKart = kartController.text.replaceAll(" ", "");
    String girilenTarih = tarihController.text;
    String girilenCvv = cvvController.text;

    if (seciliOdeme == "kart" &&
        (girilenKart != "5858585858585858" ||
            girilenTarih != "05/20" ||
            girilenCvv != "588")) {
      setState(() {
        hataMesaji = "Kart bilgilerini kontrol ediniz";
      });
    } else {
      setState(() {
        hataMesaji = "";
      });

      final prefs = await SharedPreferences.getInstance();
      final siparisNo = DateTime.now().millisecondsSinceEpoch.toString();
      List<String> siparisUrunleri = [];

      for (final item in cart.items) {
        siparisUrunleri.add("${item.name} x${item.quantity}");
      }

      await prefs.setString("siparisNo", siparisNo);
      await prefs.setInt("siparisZamani", DateTime.now().millisecondsSinceEpoch);
      await prefs.setStringList("siparisUrunleri", siparisUrunleri);
      await prefs.setDouble("siparisToplam", cart.totalPrice);

      cart.clear();

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const SiparisDurumPage()),
      );
    }
  }

  @override
  void dispose() {
    kartController.dispose();
    tarihController.dispose();
    cvvController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<Cart>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text("Ödeme")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const Text(
              "Aldıkların",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(12),
              color: Colors.white,
              child: Column(
                children: cart.items.map((item) {
                  return ListTile(
                    title: Text(item.name),
                    subtitle: Text("Adet: ${item.quantity}"),
                    trailing: Text(
                      "${(item.price * item.quantity).toStringAsFixed(2)} TL",
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              "Ödeme Yöntemi",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        seciliOdeme = "kart";
                        hataMesaji = "";
                      });
                    },
                    icon: const Icon(Icons.credit_card),
                    label: const Text("Kredi Kartı"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: seciliOdeme == "kart"
                          ? AppColors.primary
                          : Colors.grey,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        seciliOdeme = "nakit";
                        hataMesaji = "";
                      });
                    },
                    icon: const Icon(Icons.payments_outlined),
                    label: const Text("Nakit"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: seciliOdeme == "nakit"
                          ? AppColors.primary
                          : Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (seciliOdeme == "kart")
              Column(
                children: [
                  TextField(
                    controller: kartController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(16),
                      KartNumarasiFormatter(),
                    ],
                    decoration: const InputDecoration(
                      labelText: "Kart Numarası",
                      hintText: "5858 5858 5858 5858",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: tarihController,
                          keyboardType: TextInputType.datetime,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(4),
                            TarihFormatter(),
                          ],
                          decoration: const InputDecoration(
                            labelText: "Tarih",
                            hintText: "05/20",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: cvvController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(3),
                          ],
                          decoration: const InputDecoration(
                            labelText: "CVV",
                            hintText: "588",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (hataMesaji != "")
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        hataMesaji,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                ],
              ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Toplam Tutar",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "${cart.totalPrice.toStringAsFixed(2)} TL",
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: odemeyiTamamla,
                child: const Text("Ödemeyi Tamamla"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class KartNumarasiFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String rakamlar = newValue.text.replaceAll(" ", "");
    String yeniYazi = "";

    for (int i = 0; i < rakamlar.length; i++) {
      if (i != 0 && i % 4 == 0) {
        yeniYazi += " ";
      }

      yeniYazi += rakamlar[i];
    }

    return TextEditingValue(
      text: yeniYazi,
      selection: TextSelection.collapsed(offset: yeniYazi.length),
    );
  }
}

class TarihFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String rakamlar = newValue.text.replaceAll("/", "");

    if (rakamlar.length > 2) {
      rakamlar = "${rakamlar.substring(0, 2)}/${rakamlar.substring(2)}";
    }

    return TextEditingValue(
      text: rakamlar,
      selection: TextSelection.collapsed(offset: rakamlar.length),
    );
  }
}
