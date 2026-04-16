import 'package:flutter/material.dart';
import 'package:ilac_getir/models/cart_model.dart';
import 'screens/dashboard_page.dart';
import 'screens/sepet_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Cart cart = Cart();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DashboardPage(cart: cart),
      routes: {"/sepet": (_) => SepetPage(cart: cart)},
    );
  }
}
