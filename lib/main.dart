import 'package:alcohol/core/constants/app_constants.dart';
import 'package:alcohol/core/constants/app_theme.dart';
import 'package:alcohol/features/admin/screens/admin_screen.dart';
import 'package:alcohol/features/drinks/screens/drinks_screen_v2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: ".env");

  await Firebase.initializeApp(
    options: FirebaseOptions(
        apiKey: AppConstants.firebaseApiKey,
        authDomain: AppConstants.firebaseAuthDomain,
        projectId: AppConstants.firebaseProjectId,
        storageBucket: AppConstants.firebaseStorageBucket,
        messagingSenderId: AppConstants.firebaseMessagingSenderId,
        appId: AppConstants.firebaseAppId,
        measurementId: AppConstants.firebaseMeasurementId),
  );

  // Firebase UI Auth providers 초기화
  try {
    FirebaseUIAuth.configureProviders([
      GoogleProvider(
        clientId: AppConstants.googleClientId,
      ),
    ]);
  } catch (e) {
    print('Google Sign-In 초기화 실패 (웹 환경일 수 있음): $e');
    // 웹에서는 Google Sign-In이 없어도 앱이 실행되도록 함
  }

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
