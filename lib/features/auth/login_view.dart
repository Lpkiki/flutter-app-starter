import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'auth_controller.dart';

/// Responsive login form with localized validation.
class LoginView extends StatefulWidget {
  const LoginView({super.key});
  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final username = TextEditingController(), password = TextEditingController();
  final form = GlobalKey<FormState>();
  @override
  void dispose() {
    username.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();
    return Scaffold(
      appBar: AppBar(title: Text('appName'.tr)),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Form(
                key: form,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'welcome'.tr,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: username,
                      decoration: InputDecoration(labelText: 'username'.tr),
                      autofillHints: const [AutofillHints.username],
                      validator: (v) =>
                          v == null || v.trim().isEmpty ? 'required'.tr : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: password,
                      decoration: InputDecoration(labelText: 'password'.tr),
                      obscureText: true,
                      autofillHints: const [AutofillHints.password],
                      validator: (v) =>
                          v == null || v.isEmpty ? 'required'.tr : null,
                    ),
                    const SizedBox(height: 24),
                    Obx(
                      () => Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (controller.error.value.isNotEmpty)
                            Text(
                              controller.error.value.tr,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.error,
                              ),
                            ),
                          FilledButton(
                            onPressed: controller.busy.value
                                ? null
                                : () {
                                    if (form.currentState!.validate()) {
                                      controller.login(
                                        username.text.trim(),
                                        password.text,
                                      );
                                    }
                                  },
                            child: Text(
                              controller.busy.value ? 'loading'.tr : 'login'.tr,
                            ),
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () => Get.updateLocale(
                        Get.locale?.languageCode == 'zh'
                            ? const Locale('en')
                            : const Locale('zh'),
                      ),
                      child: Text('language'.tr),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
