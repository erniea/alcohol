import 'package:alcohol/core/constants/app_theme.dart';
import 'package:alcohol/core/firebase_init.dart';
import 'package:alcohol/features/admin/screens/admin_screen.dart';
import 'package:alcohol/features/drinks/screens/drinks_screen_v2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: ".env");

  // Firebase는 백그라운드에서 초기화 — 첫 화면 표시를 막지 않음
  // (평가 탭에서 완료를 기다림)
  FirebaseInit.ensureInitialized().catchError((e) {
    debugPrint('Firebase 초기화 실패: $e');
  });

  runApp(const ProviderScope(child: Alcohol()));
}

class Alcohol extends StatelessWidget {
  const Alcohol({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Alcohol',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      initialRoute: "/",
      routes: {
        "/": (context) => const DrinksScreenV2(),
        "/admin": (context) => const AdminScreen(),
      },
    );
  }
}
