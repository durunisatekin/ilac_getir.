import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/medicine_data.dart';
import '../models/cart_model.dart';
import '../theme/app_colors.dart';
import 'siparis_durum_page.dart';

class OdemePage extends StatefulWidget {
  const OdemePage({super.key});

  @override
  State<OdemePage> createState() => _OdemePageState();
}

class _OdemePageState extends State<OdemePage> {
  final _formKey = GlobalKey<FormState>();
  final kartController = TextEditingController();
  final tarihController = TextEditingController();
  final cvvController = TextEditingController();
  final isimSoyisimController = TextEditingController();
  final adresAdiController = TextEditingController();
  final adresTarifiController = TextEditingController();

  String seciliOdeme = "kart";
  String hataMesaji = "";

  @override
  void initState() {
    super.initState();
    _loadAddressInfo();
  }

  Future<void> _loadAddressInfo() async {
    final prefs = await SharedPreferences.getInstance();
    isimSoyisimController.text = prefs.getString("teslimatIsimSoyisim") ?? "";
    adresAdiController.text = prefs.getString("teslimatAdresAdi") ?? "";
    adresTarifiController.text = prefs.getString("teslimatAdresTarifi") ?? "";
  }

  Future<void> _saveAddressInfo() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("teslimatIsimSoyisim", isimSoyisimController.text.trim());
    await prefs.setString("teslimatAdresAdi", adresAdiController.text.trim());
    await prefs.setString("teslimatAdresTarifi", adresTarifiController.text.trim());
  }

  Future<void> odemeyiTamamla() async {
    final cart = context.read<Cart>();

    if (cart.items.isEmpty) {
      setState(() => hataMesaji = "Sepetiniz boş");
      return;
    }

    if (!_formKey.currentState!.validate()) {
      return;
    }

    final girilenKart = kartController.text.replaceAll(" ", "");
    final girilenTarih = tarihController.text;
    final girilenCvv = cvvController.text;

    if (seciliOdeme == "kart" &&
        (girilenKart != "5858585858585858" ||
            girilenTarih != "05/20" ||
            girilenCvv != "588")) {
      setState(() => hataMesaji = "Kart bilgilerini kontrol ediniz");
      return;
    }

    setState(() => hataMesaji = "");

    final prefs = await SharedPreferences.getInstance();
    final siparisNo = DateTime.now().millisecondsSinceEpoch.toString();
    final siparisUrunleri = cart.items
        .map((item) => "${item.name} x${item.quantity}")
        .toList();

    await _saveAddressInfo();
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

  @override
  void dispose() {
    kartController.dispose();
    tarihController.dispose();
    cvvController.dispose();
    isimSoyisimController.dispose();
    adresAdiController.dispose();
    adresTarifiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<Cart>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Ödeme"),
        backgroundColor: AppColors.navy,
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          children: [
            const Text(
              "Aldıkların",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ...cart.items.map((item) => _PaymentItemCard(item: item)),
            const SizedBox(height: 22),
            const Text(
              "Teslimat Bilgileri",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _AddressForm(
              isimSoyisimController: isimSoyisimController,
              adresAdiController: adresAdiController,
              adresTarifiController: adresTarifiController,
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
            if (seciliOdeme == "kart") _CardPaymentForm(
              kartController: kartController,
              tarihController: tarihController,
              cvvController: cvvController,
            ),
            if (hataMesaji.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  hataMesaji,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            const SizedBox(height: 24),
            _TotalCard(total: cart.totalPrice),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: odemeyiTamamla,
                icon: const Icon(Icons.check_circle_outline),
                label: const Text("Ödemeyi Tamamla"),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PaymentItemCard extends StatelessWidget {
  final CartItem item;

  const _PaymentItemCard({required this.item});

  Map<String, dynamic>? get medicine {
    try {
      return medicines.firstWhere((medicine) => medicine["name"] == item.name);
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final image = medicine?["image"] as String?;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FBFC),
              borderRadius: BorderRadius.circular(14),
            ),
            child: image == null
                ? const Icon(Icons.medication, color: AppColors.primaryDark)
                : Image.asset(
                    image,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.medication, color: AppColors.primaryDark);
                    },
                  ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  "Adet: ${item.quantity}",
                  style: const TextStyle(color: Colors.black54),
                ),
              ],
            ),
          ),
          Text(
            "${(item.price * item.quantity).toStringAsFixed(2)} TL",
            style: const TextStyle(
              color: AppColors.primaryDark,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _AddressForm extends StatelessWidget {
  final TextEditingController isimSoyisimController;
  final TextEditingController adresAdiController;
  final TextEditingController adresTarifiController;

  const _AddressForm({
    required this.isimSoyisimController,
    required this.adresAdiController,
    required this.adresTarifiController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          _AddressTextField(
            controller: isimSoyisimController,
            label: "İsim Soyisim",
            hint: "Duru Tekin",
            icon: Icons.person_outline,
          ),
          const SizedBox(height: 12),
          _AddressTextField(
            controller: adresAdiController,
            label: "Adres Adı",
            hint: "Ev, okul, iş",
            icon: Icons.bookmark_border,
          ),
          const SizedBox(height: 12),
          _AddressTextField(
            controller: adresTarifiController,
            label: "Adres Tarifi",
            hint: "Mahalle, sokak, bina no, kat ve daire",
            icon: Icons.home_outlined,
            maxLines: 3,
          ),
        ],
      ),
    );
  }
}

class _AddressTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final int maxLines;

  const _AddressTextField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "$label boş bırakılamaz";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: const Color(0xFFF9FBFC),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
      ),
    );
  }
}

class _CardPaymentForm extends StatelessWidget {
  final TextEditingController kartController;
  final TextEditingController tarihController;
  final TextEditingController cvvController;

  const _CardPaymentForm({
    required this.kartController,
    required this.tarihController,
    required this.cvvController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          controller: kartController,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(16),
            KartNumarasiFormatter(),
          ],
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return "Kart numarası boş bırakılamaz";
            }
            return null;
          },
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
              child: TextFormField(
                controller: tarihController,
                keyboardType: TextInputType.datetime,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(4),
                  TarihFormatter(),
                ],
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Tarih gerekli";
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: "Tarih",
                  hintText: "05/20",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextFormField(
                controller: cvvController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(3),
                ],
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "CVV gerekli";
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: "CVV",
                  hintText: "588",
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _TotalCard extends StatelessWidget {
  final double total;

  const _TotalCard({required this.total});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Toplam Tutar",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(
            "${total.toStringAsFixed(2)} TL",
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
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
    final rakamlar = newValue.text.replaceAll(" ", "");
    var yeniYazi = "";

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
    var rakamlar = newValue.text.replaceAll("/", "");

    if (rakamlar.length > 2) {
      rakamlar = "${rakamlar.substring(0, 2)}/${rakamlar.substring(2)}";
    }

    return TextEditingValue(
      text: rakamlar,
      selection: TextSelection.collapsed(offset: rakamlar.length),
    );
  }
}
