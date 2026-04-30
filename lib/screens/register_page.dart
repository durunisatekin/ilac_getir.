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
  String smsCode = "";
  bool smsSent = false;

  bool get isPhoneValid => phone.length == 11 && phone.startsWith("0");

  void sendSmsCode() {
    if (name.trim().isEmpty || surname.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Lütfen isim ve soyisim alanlarını doldur"),
        ),
      );
      return;
    }

    if (!isPhoneValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Telefon 0 ile başlamalı ve 11 haneli olmalı"),
        ),
      );
      return;
    }

    setState(() {
      smsSent = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("$phone numarasına SMS kodu gönderildi")),
    );
  }

  Future<void> register() async {
    if (!smsSent) {
      sendSmsCode();
      return;
    }

    if (smsCode != UserModel.demoSmsCode) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("SMS kodu hatalı")));
      return;
    }

    final user = context.read<UserModel>();

    await user.register(
      userName: name.trim(),
      userSurname: surname.trim(),
      userPhone: phone,
      smsCode: smsCode,
    );

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const DashboardPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
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
                setState(() {
                  phone = value;
                  smsSent = false;
                  smsCode = "";
                });
              },
            ),
            const SizedBox(height: 12),
            if (smsSent)
              TextField(
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(4),
                ],
                decoration: const InputDecoration(
                  labelText: "SMS Kodu",
                  prefixIcon: Icon(Icons.sms_outlined),
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  smsCode = value;
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
                onPressed: smsSent ? register : sendSmsCode,
                child: Text(smsSent ? "Kaydol" : "SMS Kodu Gönder"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
