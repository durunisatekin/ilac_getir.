import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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

  void odemeyiTamamla() {
    String girilenKart = kartController.text.replaceAll(" ", "");
    String girilenTarih = tarihController.text;
    String girilenCvv = cvvController.text;

    if (seciliOdeme == "kart" &&
        (girilenKart != "2424242424242424" ||
            girilenTarih != "05/30" ||
            girilenCvv != "244")) {
      setState(() {
        hataMesaji = "Kart bilgilerini kontrol ediniz";
      });
    } else {
      setState(() {
        hataMesaji = "";
      });

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
                    decoration: const InputDecoration(
                      labelText: "Kart Numarası",
                      hintText: "Kart numaranızı giriniz",
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
                          decoration: const InputDecoration(
                            labelText: "Tarih",
                            hintText: "AA/YY",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: cvvController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: "CVV",
                            hintText: "CVV",
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
