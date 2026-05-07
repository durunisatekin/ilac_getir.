import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserModel extends ChangeNotifier {
  static const String demoSmsCode = "5858";

  String name = "";
  String surname = "";
  String phone = "";
  bool isLoggedIn = false;

  final List<String> addresses = [];
  final List<String> oldOrders = [];

  UserModel() {
    loadUser();
  }

  Future<void> loadUser() async {
    final prefs = await SharedPreferences.getInstance();

    name = prefs.getString("name") ?? "";
    surname = prefs.getString("surname") ?? "";
    phone = prefs.getString("phone") ?? "";
    isLoggedIn = prefs.getBool("isLoggedIn") ?? false;

    addresses.clear();
    addresses.addAll(prefs.getStringList("addresses") ?? []);

    oldOrders.clear();
    oldOrders.addAll(prefs.getStringList("oldOrders") ?? []);

    notifyListeners();
  }

  Future<void> saveUser() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString("name", name);
    await prefs.setString("surname", surname);
    await prefs.setString("phone", phone);
    await prefs.setBool("isLoggedIn", isLoggedIn);
    await prefs.setStringList("addresses", addresses);
    await prefs.setStringList("oldOrders", oldOrders);
  }

  Future<void> register({
    required String userName,
    required String userSurname,
    required String userPhone,
    required String smsCode,
  }) async {
    if (smsCode != demoSmsCode) {
      throw Exception("SMS kodu hatalı");
    }

    name = userName;
    surname = userSurname;
    phone = userPhone;
    isLoggedIn = true;

    _fillDemoProfileData();

    await saveUser();
    notifyListeners();
  }

  Future<bool> loginWithSms(String userPhone, String smsCode) async {
    if (smsCode != demoSmsCode) {
      throw Exception("Hatalı SMS kodu");
    }

    // Eğer sistemdeki telefon girilenle eşleşmiyorsa veya isim henüz kaydedilmemişse üye değildir
    if (phone != userPhone || name.isEmpty) {
      return false;
    }

    isLoggedIn = true;

    _fillDemoProfileData();

    await saveUser();
    notifyListeners();
    return true;
  }

  Future<void> logout() async {
    isLoggedIn = false;
    await saveUser();
    notifyListeners();
  }

  Future<void> addOldOrder(String orderSummary) async {
    oldOrders.add(orderSummary);
    await saveUser();
    notifyListeners();
  }

  void _fillDemoProfileData() {
    if (addresses.isEmpty) {
      addresses.add("Ev adresi - İstanbul");
    }

    if (oldOrders.isEmpty) {
      oldOrders.add("Parol, Vitamin - 350 TL");
    }
  }
}
