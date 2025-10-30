import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app/routes/app_pages.dart';
import 'app/theme/app_theme.dart';
import 'app/theme/app_colors.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load env from bundled assets (see pubspec assets)
  await dotenv.load(fileName: 'assets/env/.env');

  final url = dotenv.env['SUPABASE_URL'];
  final anonKey = dotenv.env['SUPABASE_ANON_KEY'];

  if (url == null || url.isEmpty || anonKey == null || anonKey.isEmpty) {
    throw Exception(
      'SUPABASE_URL atau SUPABASE_ANON_KEY belum terkonfigurasi di .env',
    );
  }

  await Supabase.initialize(url: url, anonKey: anonKey);

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
