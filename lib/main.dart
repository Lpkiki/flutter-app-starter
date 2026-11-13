import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';

import 'core/api_client.dart';
import 'core/translations.dart';
import 'features/auth/auth_controller.dart';
import 'features/auth/login_view.dart';
import 'features/tasks/tasks_controller.dart';
import 'features/tasks/tasks_view.dart';

void main() {
  final api = Get.put(ApiClient(), permanent: true);
  Get.put(AuthController(api), permanent: true);
  api.onUnauthorized = () => Get.offAllNamed('/login');
  runApp(const StarterApp());
}

/// Application root with centralized routes, theme and localization.
class StarterApp extends StatelessWidget {
  const StarterApp({super.key});
  @override
  Widget build(BuildContext context) => GetMaterialApp(
    debugShowCheckedModeBanner: false,
    translations: AppTranslations(),
    locale: const Locale('zh'),
    fallbackLocale: const Locale('en'),
    supportedLocales: const [Locale('zh'), Locale('en')],
    localizationsDelegates: GlobalMaterialLocalizations.delegates,
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff315db5)),
      useMaterial3: true,
    ),
    darkTheme: ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xff315db5),
        brightness: Brightness.dark,
      ),
      useMaterial3: true,
    ),
    themeMode: ThemeMode.system,
    initialRoute: '/login',
    getPages: [
      GetPage(name: '/login', page: () => const LoginView()),
      GetPage(
        name: '/tasks',
        page: () => const TasksView(),
        middlewares: [_AuthGuard()],
        binding: BindingsBuilder(
          () => Get.lazyPut(() => TasksController(Get.find<ApiClient>())),
        ),
      ),
    ],
  );
}

class _AuthGuard extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) => Get.find<ApiClient>().token == null
      ? const RouteSettings(name: '/login')
      : null;
}
