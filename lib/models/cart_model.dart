import 'package:flutter/material.dart';

class CartItem {
  String name;
  double price;
  int quantity; // quantity= adet(miktar)

  CartItem({required this.name, required this.price, this.quantity = 1});
} // sepetteki tek bir ürünü temsil ediyor

// ChangeNotifier, Provider ile beraber kullanılır.
// Sepette bir değişiklik olduğunda notifyListeners() çağırırız.
// Böylece bu modeli dinleyen ekranlar otomatik olarak güncellenir.
class Cart extends ChangeNotifier {
  final List<CartItem> items =
      []; // sepetin kendisi içinde bir sürü CartItem var

  void addItem(String name, double price) {
    int index = items.indexWhere((item) => item.name == name);
    // sepette bu ürün var mı bakıyor
    if (index != -1) {
      items[index].quantity++;
    } else {
      items.add(CartItem(name: name, price: price));
    }

    // Sepet değişti. Provider'a "beni dinleyen widget'ları yenile" diyoruz.
    notifyListeners();
  }

  void increase(CartItem item) {
    item.quantity++; // sepetteki + butonu sadece sayıyı arttırır
    notifyListeners();
  }

  void decrease(CartItem item) {
    if (item.quantity > 1) {
      item.quantity--;
    } else {
      items.remove(item);
    } // eğer 1'den büyükse azalt , eğer 1 ise tamamen sil.

    notifyListeners();
  }

  double get totalPrice {
    return items.fold(0, (sum, item) => sum + item.price * item.quantity);
  } // fold= toplama işlemi

  int get totalItems {
    return items.fold(0, (sum, item) => sum + item.quantity);
  } // toplam kaç ürün var (adet olarak)
}

// default = varsayılan değer
