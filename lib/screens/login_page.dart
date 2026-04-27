import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/user_model.dart';
import '../theme/app_colors.dart';
import 'dashboard_page.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String phone = "";
  String password = "";

  @override
  Widget build(BuildContext context) {
    final user = context.read<UserModel>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              const Text(
                "Dvita",
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "İlaç kapında, hesabına giriş yap",
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 30),

              // TextField kullanıcıdan yazı almak için kullanılır.
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
                  prefixIcon: Icon(Icons.phone),
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  phone = value;
                },
              ),
              const SizedBox(height: 14),
              TextField(
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Şifre",
                  prefixIcon: Icon(Icons.lock),
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

                    final success = await user.login(phone, password);

                    if (success) {
                      if (!context.mounted) return;

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const DashboardPage(),
                        ),
                      );
                    } else {
                      if (!context.mounted) return;

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Telefon veya şifre hatalı"),
                        ),
                      );
                    }
                  },
                  child: const Text("Giriş Yap"),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const RegisterPage()),
                    );
                  },
                  child: const Text("Üye Ol"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
