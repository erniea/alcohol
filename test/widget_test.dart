import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:alcohol/main.dart';

void main() {
  testWidgets('메인 화면이 렌더링된다', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: Alcohol()));

    // 네트워크 요청 실패(테스트 환경) 처리까지 프레임 진행
    await tester.pump(const Duration(seconds: 1));

    // 하단 네비게이션과 칵테일 탭이 표시되는지 확인
    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.text('칵테일'), findsWidgets);
    expect(find.text('평가'), findsWidgets);
  });
}
