import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartItem {
  String name;
  double price;
  int quantity;

  CartItem({required this.name, required this.price, this.quantity = 1});
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

      if (parts.length == 3) {
        String name = parts[0];
        double price = double.tryParse(parts[1]) ?? 0;
        int quantity = int.tryParse(parts[2]) ?? 1;

        items.add(CartItem(name: name, price: price, quantity: quantity));
      }
    }

    notifyListeners();
  }

  Future<void> saveCart() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> savedItems = [];

    for (CartItem item in items) {
      savedItems.add("${item.name}|${item.price}|${item.quantity}");
    }

    await prefs.setStringList("cartItems", savedItems);
  }

  void addItem(String name, double price) {
    int index = items.indexWhere((item) => item.name == name);

    if (index != -1) {
      items[index].quantity++;
    } else {
      items.add(CartItem(name: name, price: price));
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

  int get totalItems {
    return items.fold(0, (sum, item) => sum + item.quantity);
  }
}
