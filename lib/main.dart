import 'package:flutter/material.dart';
import 'package:ilac_getir/models/cart_model.dart';
import 'package:ilac_getir/models/user_model.dart';
import 'package:ilac_getir/theme/app_colors.dart';
import 'package:provider/provider.dart';
import 'screens/dashboard_page.dart';
import 'screens/sepet_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MultiProvider birden fazla Provider kullanmak içindir.
    // Cart sepeti, UserModel ise kullanıcı bilgilerini tutar.
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Cart()),
        ChangeNotifierProvider(create: (_) => UserModel()),
      ],
      child: MaterialApp(
        title: "Dvita",
        debugShowCheckedModeBanner: false,
        // ThemeData uygulamanın genel renk ve buton tarzını belirler.
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
        home: const DashboardPage(),
        routes: {"/sepet": (_) => const SepetPage()},
      ),
    );
  }
}
