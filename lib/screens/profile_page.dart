import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user_model.dart';
import '../theme/app_colors.dart';
import 'login_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserModel>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Hesabım"),
        backgroundColor: AppColors.navy,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, color: AppColors.primary, size: 34),
                ),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${user.name} ${user.surname}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      user.phone,
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          const Text(
            "Kayıtlı Adreslerim",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          for (final address in user.addresses)
            Card(
              child: ListTile(
                leading: const Icon(
                  Icons.location_on,
                  color: AppColors.primary,
                ),
                title: Text(address),
              ),
            ),

          const SizedBox(height: 14),
          const Text(
            "Eski Siparişlerim",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          for (final order in user.oldOrders)
            Card(
              child: ListTile(
                leading: const Icon(
                  Icons.receipt_long,
                  color: AppColors.primary,
                ),
                title: Text(order),
                subtitle: const Text("Teslim edildi"),
              ),
            ),

          const SizedBox(height: 20),
          OutlinedButton.icon(
            onPressed: () async {
              await user.logout();

              if (!context.mounted) return;

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginPage()),
                (route) => false,
              );
            },
            icon: const Icon(Icons.logout),
            label: const Text("Çıkış Yap"),
          ),
        ],
      ),
    );
  }
}
