import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConstants {
  // 우선순위: 1. --dart-define, 2. .env, 3. 기본값

  // Default images
  static String get defaultDrinkImage =>
      const String.fromEnvironment('DEFAULT_DRINK_IMAGE',
          defaultValue: '') != ''
          ? const String.fromEnvironment('DEFAULT_DRINK_IMAGE')
          : (dotenv.env['DEFAULT_DRINK_IMAGE'] ?? 'https://cdn.erniea.net/ethanol.png');

  // Firebase config
  static String get firebaseApiKey =>
      const String.fromEnvironment('FIREBASE_API_KEY',
          defaultValue: '') != ''
          ? const String.fromEnvironment('FIREBASE_API_KEY')
          : (dotenv.env['FIREBASE_API_KEY'] ?? '');

  static String get firebaseAuthDomain =>
      const String.fromEnvironment('FIREBASE_AUTH_DOMAIN',
          defaultValue: '') != ''
          ? const String.fromEnvironment('FIREBASE_AUTH_DOMAIN')
          : (dotenv.env['FIREBASE_AUTH_DOMAIN'] ?? '');

  static String get firebaseProjectId =>
      const String.fromEnvironment('FIREBASE_PROJECT_ID',
          defaultValue: '') != ''
          ? const String.fromEnvironment('FIREBASE_PROJECT_ID')
          : (dotenv.env['FIREBASE_PROJECT_ID'] ?? '');

  static String get firebaseStorageBucket =>
      const String.fromEnvironment('FIREBASE_STORAGE_BUCKET',
          defaultValue: '') != ''
          ? const String.fromEnvironment('FIREBASE_STORAGE_BUCKET')
          : (dotenv.env['FIREBASE_STORAGE_BUCKET'] ?? '');

  static String get firebaseMessagingSenderId =>
      const String.fromEnvironment('FIREBASE_MESSAGING_SENDER_ID',
          defaultValue: '') != ''
          ? const String.fromEnvironment('FIREBASE_MESSAGING_SENDER_ID')
          : (dotenv.env['FIREBASE_MESSAGING_SENDER_ID'] ?? '');

  static String get firebaseAppId =>
      const String.fromEnvironment('FIREBASE_APP_ID',
          defaultValue: '') != ''
          ? const String.fromEnvironment('FIREBASE_APP_ID')
          : (dotenv.env['FIREBASE_APP_ID'] ?? '');

  static String get firebaseMeasurementId =>
      const String.fromEnvironment('FIREBASE_MEASUREMENT_ID',
          defaultValue: '') != ''
          ? const String.fromEnvironment('FIREBASE_MEASUREMENT_ID')
          : (dotenv.env['FIREBASE_MEASUREMENT_ID'] ?? '');

  static String get googleClientId =>
      const String.fromEnvironment('GOOGLE_CLIENT_ID',
          defaultValue: '') != ''
          ? const String.fromEnvironment('GOOGLE_CLIENT_ID')
          : (dotenv.env['GOOGLE_CLIENT_ID'] ?? '');
}
