import 'package:flutter/material.dart';
import '../models/cart_model.dart';

class SepetPage extends StatefulWidget {
  final Cart cart;

  SepetPage({required this.cart});

  @override
  State<SepetPage> createState() => _SepetPageState();
}

class _SepetPageState extends State<SepetPage> {
  @override
  Widget build(BuildContext context) {
    final cart = widget.cart;

    return Scaffold(
      appBar: AppBar(title: Text("Sepetim")),

      body: ListView.builder(
        itemCount: cart.items.length,
        itemBuilder: (context, index) {
          final item = cart.items[index];

          return ListTile(
            title: Text(item.name),
            subtitle: Text("${item.price} TL"),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      cart.decrease(item);
                    });
                  },
                  icon: Icon(Icons.remove),
                ),
                Text(item.quantity.toString()),
                IconButton(
                  onPressed: () {
                    setState(() {
                      cart.increase(item);
                    });
                  },
                  icon: Icon(Icons.add),
                ),
              ],
            ),
          );
        },
      ),

      bottomNavigationBar: Container(
        padding: EdgeInsets.all(16),
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Ürün: ${cart.totalItems}"),
            Text("Toplam: ${cart.totalPrice} TL"),
          ],
        ),
      ),
    );
  }
}
