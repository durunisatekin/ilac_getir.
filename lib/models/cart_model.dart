class CartItem {
  String name;
  double price;
  int quantity;

  CartItem({required this.name, required this.price, this.quantity = 1});
}

class Cart {
  List<CartItem> items = [];

  void addItem(String name, double price) {
    int index = items.indexWhere((item) => item.name == name);

    if (index != -1) {
      items[index].quantity++;
    } else {
      items.add(CartItem(name: name, price: price));
    }
  }

  void increase(CartItem item) {
    item.quantity++;
  }

  void decrease(CartItem item) {
    if (item.quantity > 1) {
      item.quantity--;
    } else {
      items.remove(item);
    }
  }

  double get totalPrice {
    return items.fold(0, (sum, item) => sum + item.price * item.quantity);
  }

  int get totalItems {
    return items.fold(0, (sum, item) => sum + item.quantity);
  }
}
