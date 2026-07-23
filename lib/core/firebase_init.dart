import 'package:alcohol/core/constants/app_constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';

/// Firebase 초기화를 지연 실행하는 헬퍼
///
/// 앱 시작 시 초기화 완료를 기다리지 않고 첫 화면을 먼저 띄운 뒤,
/// 로그인이 필요한 화면(평가 탭)에서만 완료를 기다린다.
class FirebaseInit {
  FirebaseInit._();

  static Future<void>? _ready;

  static Future<void> ensureInitialized() => _ready ??= _initialize();

  static Future<void> _initialize() async {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: AppConstants.firebaseApiKey,
        authDomain: AppConstants.firebaseAuthDomain,
        projectId: AppConstants.firebaseProjectId,
        storageBucket: AppConstants.firebaseStorageBucket,
        messagingSenderId: AppConstants.firebaseMessagingSenderId,
        appId: AppConstants.firebaseAppId,
        measurementId: AppConstants.firebaseMeasurementId,
      ),
    );

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
  }
}
