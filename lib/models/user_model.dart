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

    // Eğer farklı telefon ile giriş yapılıyorsa, eski veriyi taşı
    final oldUserId = getCurrentUserId();
    final newUserId = userPhone.isNotEmpty ? userPhone : "guest_${userPhone}_$name";
    
    if (oldUserId != newUserId && oldUserId != "guest_$name") {
      await transferUserData(oldUserId, newUserId);
    }

    isLoggedIn = true;
    phone = userPhone;

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

  // Kullanıcı değişiminde veri taşıma metodları
  Future<void> transferUserData(String oldUserId, String newUserId) async {
    final prefs = await SharedPreferences.getInstance();
    
    // Favorileri taşı
    final favoritesJson = prefs.getStringList("userFavorites") ?? [];
    final updatedFavorites = <String>[];
    
    for (final favJson in favoritesJson) {
      try {
        final parts = favJson.split("|");
        if (parts.length >= 3 && parts[1] == oldUserId) {
          // Eski kullanıcı ID'sini yeni ID ile değiştir
          updatedFavorites.add("${parts[0]}|$newUserId|${parts[2]}");
        } else {
          // Diğer favorileri aynen kopyala
          updatedFavorites.add(favJson);
        }
      } catch (e) {
        updatedFavorites.add(favJson);
      }
    }
    
    await prefs.setStringList("userFavorites", updatedFavorites);
    
    // Siparişleri taşı
    final ordersJson = prefs.getStringList("userOrders") ?? [];
    final updatedOrders = <String>[];
    
    for (final orderJson in ordersJson) {
      try {
        final parts = orderJson.split("|");
        if (parts.length >= 6 && parts[1] == oldUserId) {
          // Eski kullanıcı ID'sini yeni ID ile değiştir
          updatedOrders.add("${parts[0]}|$newUserId|${parts[2]}|${parts[3]}|${parts[4]}|${parts[5]}");
        } else {
          // Diğer siparişleri aynen kopyala
          updatedOrders.add(orderJson);
        }
      } catch (e) {
        updatedOrders.add(orderJson);
      }
    }
    
    await prefs.setStringList("userOrders", updatedOrders);
    
    // Provider'ları yenile
    notifyListeners();
  }

  // Mevcut kullanıcı ID'sini al
  String getCurrentUserId() {
    return phone.isNotEmpty ? phone : "guest_$name";
  }

  // Kullanıcı adını güncelleme
  Future<void> updateUserName(String newName) async {
    name = newName;
    await saveUser();
    notifyListeners();
  }

  // Telefon numarasını güncelleme
  Future<void> updateUserPhone(String newPhone) async {
    phone = newPhone;
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
