import 'package:get/get.dart';

import '../../core/api_client.dart';

/// Owns authentication and navigation; views never handle tokens.
class AuthController extends GetxController {
  AuthController(this.api);
  final ApiClient api;
  final busy = false.obs, error = ''.obs, username = ''.obs;
  Future<void> login(String name, String password) async {
    if (busy.value) return;
    busy.value = true;
    error.value = '';
    try {
      final result = await api.request(
        'POST',
        '/auth/login',
        data: {'username': name, 'password': password},
      );
      api.token = result['token'] as String;
      username.value = result['user']['username'] as String;
      Get.offAllNamed('/tasks');
    } catch (_) {
      error.value = 'loginError';
    } finally {
      busy.value = false;
    }
  }

  Future<void> logout() async {
    try {
      await api.request('POST', '/auth/logout');
    } catch (_) {
      /* Local logout must remain available offline. */
    } finally {
      api.token = null;
      username.value = '';
      Get.offAllNamed('/login');
    }
  }
}
