import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/user_model.dart';
import '../theme/app_colors.dart';
import 'dashboard_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String name = "";
  String surname = "";
  String phone = "";
  String password = "";

  @override
  Widget build(BuildContext context) {
    final user = context.read<UserModel>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Üye Ol"),
        backgroundColor: AppColors.navy,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Icon(Icons.person_add, color: AppColors.primary, size: 70),
            const SizedBox(height: 20),

            TextField(
              decoration: const InputDecoration(
                labelText: "İsim",
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                name = value;
              },
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: const InputDecoration(
                labelText: "Soyisim",
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                surname = value;
              },
            ),
            const SizedBox(height: 12),
            TextField(
              keyboardType: TextInputType.phone,
              // Sadece rakam yazılmasına izin verir.
              // 11 haneden fazlasını yazdırmaz.
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(11),
              ],
              decoration: const InputDecoration(
                labelText: "Telefon",
                hintText: "05xxxxxxxxx",
                helperText: "Telefon numarası 0 ile başlamalıdır",
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                phone = value;
              },
            ),
            const SizedBox(height: 12),
            TextField(
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Şifre",
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                password = value;
              },
            ),
            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(14),
                ),
                onPressed: () async {
                  if (name.isEmpty ||
                      surname.isEmpty ||
                      phone.isEmpty ||
                      password.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Lütfen tüm alanları doldur"),
                      ),
                    );
                    return;
                  }

                  if (phone.length != 11 || !phone.startsWith("0")) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Telefon 0 ile başlamalı ve 11 haneli olmalı",
                        ),
                      ),
                    );
                    return;
                  }

                  await user.register(
                    userName: name,
                    userSurname: surname,
                    userPhone: phone,
                    userPassword: password,
                  );

                  if (!context.mounted) return;

                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const DashboardPage()),
                    (route) => false,
                  );
                },
                child: const Text("Kaydol"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
