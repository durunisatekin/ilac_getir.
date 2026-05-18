import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderModel extends ChangeNotifier {
  final List<Map<String, dynamic>> _orders = [];

  OrderModel() {
    loadOrders();
  }

  Future<void> loadOrders() async {
    final prefs = await SharedPreferences.getInstance();
    _orders.clear();

    // Kullanıcı bazlı siparişleri yükle
    final ordersJson = prefs.getStringList("userOrders") ?? [];
    for (final orderJson in ordersJson) {
      try {
        // Format: "orderId|userId|timestamp|products|total|status"
        final parts = orderJson.split("|");
        if (parts.length >= 6) {
          _orders.add({
            "orderId": parts[0],
            "userId": parts[1],
            "timestamp": int.tryParse(parts[2]) ?? 0,
            "products": parts[3],
            "total": double.tryParse(parts[4]) ?? 0.0,
            "status": parts[5],
          });
        }
      } catch (e) {
        // Eski formatı destekle
        _orders.add({
          "orderId": "legacy_${_orders.length}",
          "userId": "legacy",
          "timestamp": 0,
          "products": orderJson,
          "total": 0.0,
          "status": "tamamlandı",
        });
      }
    }

    // Tarihe göre sırala
    _orders.sort((a, b) => b["timestamp"].compareTo(a["timestamp"]));

    notifyListeners();
  }

  Future<void> saveOrders() async {
    final prefs = await SharedPreferences.getInstance();

    // Kullanıcı bazlı siparişleri kaydet
    final ordersJson = _orders
        .map(
          (order) =>
              "${order["orderId"]}|${order["userId"]}|${order["timestamp"]}|${order["products"]}|${order["total"]}|${order["status"]}",
        )
        .toList();

    await prefs.setStringList("userOrders", ordersJson);
  }

  void addOrder({
    required String userId,
    required List<Map<String, dynamic>> products,
    required double total,
    String status = "hazırlanıyor",
  }) {
    final order = {
      "orderId": "ORD_${DateTime.now().millisecondsSinceEpoch}",
      "userId": userId,
      "timestamp": DateTime.now().millisecondsSinceEpoch,
      "products": products
          .map((p) => "${p["name"]} (${p["quantity"]})")
          .join(", "),
      "total": total,
      "status": status,
    };

    _orders.insert(0, order);
    saveOrders();
    notifyListeners();
  }

  List<Map<String, dynamic>> getUserOrders(String userId) {
    return _orders.where((order) => order["userId"] == userId).toList();
  }

  List<Map<String, dynamic>> getAllOrders() {
    return List.from(_orders);
  }

  void updateOrderStatus(String orderId, String newStatus) {
    final index = _orders.indexWhere((order) => order["orderId"] == orderId);
    if (index != -1) {
      _orders[index]["status"] = newStatus;
      saveOrders();
      notifyListeners();
    }
  }
}
