import 'package:get/get.dart';

import '../../core/api_client.dart';
import 'task_model.dart';

/// Task operations and pagination shared by the page.
class TasksController extends GetxController {
  TasksController(this.api);
  final ApiClient api;
  final items = <Task>[].obs,
      busy = false.obs,
      error = ''.obs,
      total = 0.obs,
      page = 1.obs;
  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> fetch() async {
    final data = await api.request('GET', '/tasks?page=${page.value}&size=20');
    items.assignAll(
      (data['items'] as List).map(
        (e) => Task.fromJson(Map<String, dynamic>.from(e)),
      ),
    );
    total.value = data['total'] as int;
  }

  Future<void> run(Future<void> Function() action) async {
    if (busy.value) return;
    busy.value = true;
    error.value = '';
    try {
      await action();
      await fetch();
    } catch (_) {
      error.value = 'requestError';
    } finally {
      busy.value = false;
    }
  }

  Future<void> load() => run(() async {});
  Future<void> create(String title) => run(() async {
    await api.request('POST', '/tasks', data: {'title': title});
  });
  Future<void> updateTask(Task task, {String? title, bool? completed}) =>
      run(() async {
        await api.request(
          'PUT',
          '/tasks/${task.id}',
          data: task.update(title: title, completed: completed),
        );
      });
  Future<void> remove(Task task) => run(() async {
    await api.request('DELETE', '/tasks/${task.id}');
  });
  Future<void> move(int delta) async {
    if (busy.value) return;
    page.value += delta;
    await load();
  }
}
