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
  String smsCode = "";
  bool smsSent = false;

  bool get isPhoneValid => phone.length == 11 && phone.startsWith("0");

  void sendSmsCode() {
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

  Future<void> login() async {
    if (!smsSent) {
      sendSmsCode();
      return;
    }

    final user = context.read<UserModel>();
    final success = await user.loginWithSms(phone, smsCode);

    if (!mounted) return;

    if (success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const DashboardPage()),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("SMS kodu hatalı")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
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
                "İlaç kapında, telefonunla giriş yap",
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 30),
              TextField(
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(11),
                ],
                decoration: const InputDecoration(
                  labelText: "Telefon",
                  hintText: "05xxxxxxxxx",
                  prefixIcon: Icon(Icons.phone),
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
              const SizedBox(height: 14),
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
                  onPressed: smsSent ? login : sendSmsCode,
                  child: Text(smsSent ? "Giriş Yap" : "SMS Kodu Gönder"),
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
