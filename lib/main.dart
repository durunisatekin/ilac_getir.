import 'package:flutter/material.dart';
import 'package:ilac_getir/models/cart_model.dart';
import 'package:ilac_getir/models/favorite_model.dart';
import 'package:ilac_getir/models/order_model.dart';
import 'package:ilac_getir/models/user_model.dart';
import 'package:ilac_getir/theme/app_theme.dart';
import 'package:provider/provider.dart';
import 'screens/pharmacy_map_page.dart';
import 'screens/payment_page.dart';
import 'screens/cart_page.dart';
import 'screens/order_history_page.dart';
import 'screens/splash_page.dart';
import 'services/product_service.dart';

void main() {
  ProductService().fetchProducts();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MultiProvider birden fazla Provider kullanmak içindir.
    // Cart sepeti, UserModel kullanıcıyı, FavoriteModel favorileri tutar.
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Cart()),
        ChangeNotifierProvider(create: (_) => UserModel()),
        ChangeNotifierProvider(create: (_) => FavoriteModel()),
        ChangeNotifierProvider(create: (_) => OrderModel()),
      ],
      child: MaterialApp(
        title: "Dvita",
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        home: const SplashPage(),
        routes: {
          "/sepet": (_) => const CartPage(),
          "/odeme": (_) => const PaymentPage(),
          "/siparis-gecmisi": (_) => const OrderHistoryPage(),
          "/yakindaki-eczaneler": (_) => const PharmacyMapPage(onlyDuty: false),
          "/nobetci-eczaneler": (_) => const PharmacyMapPage(onlyDuty: true),
        },
      ),
    );
  }
}
