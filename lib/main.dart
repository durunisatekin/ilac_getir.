import 'package:flutter/material.dart';
import 'package:ilac_getir/models/cart_model.dart';
import 'package:ilac_getir/models/favorite_model.dart';
import 'package:ilac_getir/models/user_model.dart';
import 'package:ilac_getir/theme/app_colors.dart';
import 'package:provider/provider.dart';
import 'screens/eczane_harita_page.dart';
import 'screens/odeme_page.dart';
import 'screens/sepet_page.dart';
import 'screens/splash_page.dart';

void main() {
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
      ],
      child: MaterialApp(
        title: "Dvita",
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: AppColors.background,
          primaryColor: AppColors.primary,
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.primary,
            primary: AppColors.primary,
            secondary: AppColors.accent,
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: AppColors.navy,
            foregroundColor: Colors.white,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
          ),
        ),
        home: const SplashPage(),
        routes: {
          "/sepet": (_) => const SepetPage(),
          "/odeme": (_) => const OdemePage(),
          "/yakindaki-eczaneler": (_) =>
              const EczaneHaritaPage(sadeceNobetci: false),
          "/nobetci-eczaneler": (_) =>
              const EczaneHaritaPage(sadeceNobetci: true),
        },
      ),
    );
  }
}
