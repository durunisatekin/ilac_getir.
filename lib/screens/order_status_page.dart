import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_model.dart';
import '../theme/app_colors.dart';
import '../widgets/empty_state.dart';

class OrderStatusPage extends StatefulWidget {
  const OrderStatusPage({super.key});

  @override
  State<OrderStatusPage> createState() => _OrderStatusPageState();
}

class _OrderStatusPageState extends State<OrderStatusPage> {
  Timer? timer;
  bool yukleniyor = true;
  bool siparisKaydedildi = false;

  String siparisNo = "";
  DateTime? siparisZamani;
  List<String> siparisUrunleri = [];
  double siparisToplam = 0;

  final List<Map<String, dynamic>> adimlar = [
    {
      "icon": Icons.receipt_long,
      "title": "Sipariş alındı",
      "detail": "Ödeme ve sipariş bilgileri kaydedildi.",
    },
    {
      "icon": Icons.inventory_2_outlined,
      "title": "Sipariş hazırlanıyor",
      "detail": "Ürünler eczane tarafından hazırlanıyor.",
    },
    {
      "icon": Icons.assignment_turned_in_outlined,
      "title": "Sipariş kargoya teslim edildi",
      "detail": "Paket kuryeye teslim edildi.",
    },
    {
      "icon": Icons.local_shipping_outlined,
      "title": "Sipariş yola çıktı",
      "detail": "Kurye adresinize doğru ilerliyor.",
    },
    {
      "icon": Icons.home_outlined,
      "title": "Sipariş teslim edildi",
      "detail": "Paket adresinize ulaştı.",
    },
  ];

  @override
  void initState() {
    super.initState();
    siparisiGetir();

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted &&
          aktifAdimBul() == 4 &&
          !siparisKaydedildi &&
          siparisNo.isNotEmpty) {
        _siparisTamamla();
      }
      setState(() {});
    });
  }

  Future<void> siparisiGetir() async {
    final prefs = await SharedPreferences.getInstance();
    final kayitliZaman = prefs.getInt("siparisZamani");

    setState(() {
      siparisNo = prefs.getString("siparisNo") ?? "";
      siparisUrunleri = prefs.getStringList("siparisUrunleri") ?? [];
      siparisToplam = prefs.getDouble("siparisToplam") ?? 0;

      if (kayitliZaman != null) {
        siparisZamani = DateTime.fromMillisecondsSinceEpoch(kayitliZaman);
      }

      yukleniyor = false;
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void _siparisTamamla() {
    final user = context.read<UserModel>();
    String ozet =
        "${siparisUrunleri.join(", ")} - ${siparisToplam.toStringAsFixed(2)} TL";
    user.addOldOrder(ozet);
    siparisKaydedildi = true;
  }

  int aktifAdimBul() {
    if (siparisZamani == null) return 0;

    int gecenDakika = DateTime.now().difference(siparisZamani!).inMinutes;

    if (gecenDakika <= 0) {
      return 0;
    } else if (gecenDakika == 1) {
      return 1;
    } else if (gecenDakika == 2) {
      return 2;
    } else if (gecenDakika == 3) {
      return 3;
    } else {
      return 4;
    }
  }

  @override
  Widget build(BuildContext context) {
    int aktifAdim = aktifAdimBul();
    Map<String, dynamic> simdikiAdim = adimlar[aktifAdim];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Sipariş Durumu"),
        backgroundColor: AppColors.navy,
        foregroundColor: Colors.white,
      ),
      body: yukleniyor
          ? const Center(child: CircularProgressIndicator())
          : siparisZamani == null
          ? _bosSiparis()
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.primaryLight),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: AppColors.primaryLight,
                        child: Icon(
                          simdikiAdim["icon"],
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              simdikiAdim["title"],
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(siparisUrunleri.join(", ")),
                            const SizedBox(height: 4),
                            Text(
                              "Sipariş No: $siparisNo",
                              style: const TextStyle(color: Colors.black54),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _siparisOzeti(),
                const SizedBox(height: 24),
                for (int i = 0; i < adimlar.length; i++)
                  siparisAdimi(
                    icon: adimlar[i]["icon"],
                    title: adimlar[i]["title"],
                    detail: adimlar[i]["detail"],
                    active: i <= aktifAdim,
                    current: i == aktifAdim,
                  ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: anaSayfayaDon,
                    child: const Text("Ana Sayfaya Dön"),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _siparisOzeti() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Sipariş İçeriği",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          for (final urun in siparisUrunleri)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text(urun),
            ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Toplam",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                "${siparisToplam.toStringAsFixed(2)} TL",
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _bosSiparis() {
    return EmptyState(
      icon: Icons.local_shipping_outlined,
      title: "Aktif sipariş bulunamadı",
      message: "Ödeme tamamlandığında siparişin burada takip edilebilir.",
      action: ElevatedButton(
        onPressed: anaSayfayaDon,
        child: const Text("Ana sayfaya dön"),
      ),
    );
  }

  void anaSayfayaDon() {
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  static Widget siparisAdimi({
    required IconData icon,
    required String title,
    required String detail,
    required bool active,
    required bool current,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: active ? AppColors.primaryLight : Colors.grey.shade200,
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: active ? AppColors.primary : Colors.grey,
            child: Icon(icon, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: active
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: active ? Colors.black : Colors.black54,
                        ),
                      ),
                    ),
                    if (current)
                      const Icon(
                        Icons.radio_button_checked,
                        color: AppColors.primary,
                        size: 18,
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(detail, style: const TextStyle(color: Colors.black54)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
