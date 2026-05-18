import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartItem {
  String name;
  double price;
  int quantity;
  double? originalPrice;
  int? discountPercent;
  String? campaignLabel;

  CartItem({
    required this.name,
    required this.price,
    this.quantity = 1,
    this.originalPrice,
    this.discountPercent,
    this.campaignLabel,
  });

  bool get hasDiscount =>
      originalPrice != null &&
      originalPrice! > price &&
      discountPercent != null;

  double get discountTotal {
    if (!hasDiscount) return 0;
    return (originalPrice! - price) * quantity;
  }
}

class Cart extends ChangeNotifier {
  final List<CartItem> items = [];

  Cart() {
    loadCart();
  }

  Future<void> loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    final savedItems = prefs.getStringList("cartItems") ?? [];

    items.clear();

    for (String savedItem in savedItems) {
      List<String> parts = savedItem.split("|");

      if (parts.length >= 3) {
        String name = parts[0];
        double price = double.tryParse(parts[1]) ?? 0;
        int quantity = int.tryParse(parts[2]) ?? 1;
        double? originalPrice = parts.length > 3 && parts[3].isNotEmpty
            ? double.tryParse(parts[3])
            : null;
        int? discountPercent = parts.length > 4 && parts[4].isNotEmpty
            ? int.tryParse(parts[4])
            : null;
        String? campaignLabel = parts.length > 5 && parts[5].isNotEmpty
            ? parts[5]
            : null;

        items.add(
          CartItem(
            name: name,
            price: price,
            quantity: quantity,
            originalPrice: originalPrice,
            discountPercent: discountPercent,
            campaignLabel: campaignLabel,
          ),
        );
      }
    }

    notifyListeners();
  }

  Future<void> saveCart() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> savedItems = [];

    for (CartItem item in items) {
      savedItems.add(
        [
          item.name,
          item.price.toString(),
          item.quantity.toString(),
          item.originalPrice?.toString() ?? "",
          item.discountPercent?.toString() ?? "",
          item.campaignLabel ?? "",
        ].join("|"),
      );
    }

    await prefs.setStringList("cartItems", savedItems);
  }

  void addItem(
    String name,
    double price, {
    double? originalPrice,
    int? discountPercent,
    String? campaignLabel,
  }) {
    int index = items.indexWhere((item) => item.name == name);

    if (index != -1) {
      items[index].quantity++;
      if (originalPrice != null) {
        items[index].price = price;
        items[index].originalPrice = originalPrice;
        items[index].discountPercent = discountPercent;
        items[index].campaignLabel = campaignLabel;
      }
    } else {
      items.add(
        CartItem(
          name: name,
          price: price,
          originalPrice: originalPrice,
          discountPercent: discountPercent,
          campaignLabel: campaignLabel,
        ),
      );
    }

    saveCart();
    notifyListeners();
  }

  void increase(CartItem item) {
    item.quantity++;
    saveCart();
    notifyListeners();
  }

  void decrease(CartItem item) {
    if (item.quantity > 1) {
      item.quantity--;
    } else {
      items.remove(item);
    }

    saveCart();
    notifyListeners();
  }

  void clear() {
    items.clear();
    saveCart();
    notifyListeners();
  }

  double get totalPrice {
    return items.fold(0, (sum, item) => sum + item.price * item.quantity);
  }

  double get totalDiscount {
    return items.fold(0, (sum, item) => sum + item.discountTotal);
  }

  int get totalItems {
    return items.fold(0, (sum, item) => sum + item.quantity);
  }
}
