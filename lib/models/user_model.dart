import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Bu model kullanıcı bilgilerini uygulama içinde tutar.
// shared_preferences ile küçük bilgileri telefona kaydedebiliriz.
class UserModel extends ChangeNotifier {
  String name = "";
  String surname = "";
  String phone = "";
  String password = "";
  bool isLoggedIn = false;

  final List<String> addresses = [];
  final List<String> oldOrders = [];

  UserModel() {
    loadUser();
  }

  // Uygulama açılınca daha önce kayıtlı kullanıcı var mı diye bakar.
  Future<void> loadUser() async {
    final prefs = await SharedPreferences.getInstance();

    name = prefs.getString("name") ?? "";
    surname = prefs.getString("surname") ?? "";
    phone = prefs.getString("phone") ?? "";
    password = prefs.getString("password") ?? "";
    isLoggedIn = prefs.getBool("isLoggedIn") ?? false;

    addresses.clear();
    addresses.addAll(prefs.getStringList("addresses") ?? []);

    oldOrders.clear();
    oldOrders.addAll(prefs.getStringList("oldOrders") ?? []);

    notifyListeners();
  }

  // Kullanıcı bilgilerini telefona kaydeder.
  Future<void> saveUser() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString("name", name);
    await prefs.setString("surname", surname);
    await prefs.setString("phone", phone);
    await prefs.setString("password", password);
    await prefs.setBool("isLoggedIn", isLoggedIn);
    await prefs.setStringList("addresses", addresses);
    await prefs.setStringList("oldOrders", oldOrders);
  }

  Future<void> register({
    required String userName,
    required String userSurname,
    required String userPhone,
    required String userPassword,
  }) async {
    name = userName;
    surname = userSurname;
    phone = userPhone;
    password = userPassword;
    isLoggedIn = true;

    // Örnek veriler: profil ekranının boş görünmemesi için ekliyoruz.
    if (addresses.isEmpty) {
      addresses.add("Ev adresi - İstanbul");
    }

    if (oldOrders.isEmpty) {
      oldOrders.add("Parol, Vitamin - 350 TL");
    }

    await saveUser();

    notifyListeners();
  }

  Future<bool> login(String userPhone, String userPassword) async {
    if (phone == userPhone && password == userPassword) {
      isLoggedIn = true;
      await saveUser();
      notifyListeners();
      return true;
    }

    return false;
  }

  Future<void> logout() async {
    isLoggedIn = false;
    await saveUser();
    notifyListeners();
  }
}
