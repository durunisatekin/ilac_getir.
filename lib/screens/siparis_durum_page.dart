import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class SiparisDurumPage extends StatelessWidget {
  const SiparisDurumPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Sipariş Durumu"),
        backgroundColor: AppColors.navy,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.primaryLight),
            ),
            child: const Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.primaryLight,
                  child: Icon(
                    Icons.inventory_2_outlined,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Siparişiniz hazırlanıyor",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text("Tahmini teslimat: 30-45 dakika"),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          siparisAdimi(
            icon: Icons.receipt_long,
            title: "Sipariş alındı",
            detail: "Ödeme ve sipariş bilgileri kaydedildi.",
            active: true,
          ),
          siparisAdimi(
            icon: Icons.inventory_2_outlined,
            title: "Sipariş hazırlanıyor",
            detail: "Ürünlerin eczane tarafından hazırlanıyor.",
            active: true,
          ),
          siparisAdimi(
            icon: Icons.local_shipping_outlined,
            title: "Sipariş yolda",
            detail: "Kurye paketi teslim aldığında bu adım aktif olur.",
            active: false,
          ),
          siparisAdimi(
            icon: Icons.home_outlined,
            title: "Sipariş teslim edildi",
            detail: "Paket adresine ulaştığında sipariş tamamlanır.",
            active: false,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              child: const Text("Ana Sayfaya Dön"),
            ),
          ),
        ],
      ),
    );
  }

  static Widget siparisAdimi({
    required IconData icon,
    required String title,
    required String detail,
    required bool active,
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
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: active ? FontWeight.bold : FontWeight.normal,
                    color: active ? Colors.black : Colors.black54,
                  ),
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
