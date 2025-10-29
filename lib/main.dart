import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app/routes/app_pages.dart';
import 'app/theme/app_theme.dart';
import 'app/theme/app_colors.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const WasteWiseApp());
}

class WasteWiseApp extends StatelessWidget {
  const WasteWiseApp({super.key});

  @override
  Widget build(BuildContext context) {
    final base = AppTheme.light();

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WasteWise',
      theme: base.copyWith(
        // NOTE: jangan pakai fontFamily: 'Roboto' di copyWith (ga ada di versi lo)
        textTheme: base.textTheme.apply(
          fontFamily: 'Roboto', // <- ini cukup buat set global font
          bodyColor: AppColors.textPrimary,
          displayColor: AppColors.textPrimary,
        ),
      ),
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    );
  }
}
