import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:flutter_app_starter/core/api_client.dart';
import 'package:flutter_app_starter/core/translations.dart';
import 'package:flutter_app_starter/features/auth/auth_controller.dart';
import 'package:flutter_app_starter/features/auth/login_view.dart';

void main() {
  tearDown(Get.reset);
  for (final width in [320.0, 1200.0]) {
    testWidgets('login validation and layout at $width', (tester) async {
      tester.view.physicalSize = Size(width, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      Get.put(AuthController(ApiClient()));
      await tester.pumpWidget(
        GetMaterialApp(
          translations: AppTranslations(),
          locale: const Locale('en'),
          home: const LoginView(),
        ),
      );
      await tester.tap(find.text('Sign in'));
      await tester.pump();
      expect(find.text('Required'), findsNWidgets(2));
      expect(tester.takeException(), isNull);
    });
  }
}
