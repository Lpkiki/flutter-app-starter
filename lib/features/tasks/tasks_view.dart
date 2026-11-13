import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../auth/auth_controller.dart';
import 'task_model.dart';
import 'tasks_controller.dart';

/// Task list demonstrating loading, empty, failure and CRUD states.
class TasksView extends GetView<TasksController> {
  const TasksView({super.key});
  Future<void> edit(Task? task) async {
    final value = await Get.dialog<String>(
      _TaskDialog(initial: task?.title ?? ''),
    );
    if (value == null) return;
    if (task == null) {
      await controller.create(value);
    } else {
      await controller.updateTask(task, title: value);
    }
  }

  Future<void> remove(Task task) async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: Text('deleteConfirm'.tr),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text('cancel'.tr),
          ),
          FilledButton(
            onPressed: () => Get.back(result: true),
            child: Text('delete'.tr),
          ),
        ],
      ),
    );
    if (confirmed == true) await controller.remove(task);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text('tasks'.tr),
      actions: [
        IconButton(
          tooltip: 'refresh'.tr,
          onPressed: controller.load,
          icon: const Icon(Icons.refresh),
        ),
        IconButton(
          tooltip: 'logout'.tr,
          onPressed: Get.find<AuthController>().logout,
          icon: const Icon(Icons.logout),
        ),
      ],
    ),
    body: SafeArea(
      child: Obx(
        () => Column(
          children: [
            if (controller.busy.value) const LinearProgressIndicator(),
            if (controller.error.value.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  controller.error.value.tr,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
            Expanded(
              child: controller.items.isEmpty
                  ? Center(child: Text('empty'.tr))
                  : RefreshIndicator(
                      onRefresh: controller.load,
                      child: ListView.builder(
                        itemCount: controller.items.length,
                        itemBuilder: (context, index) {
                          final task = controller.items[index];
                          return ListTile(
                            leading: Checkbox(
                              value: task.completed,
                              onChanged: controller.busy.value
                                  ? null
                                  : (value) => controller.updateTask(
                                      task,
                                      completed: value,
                                    ),
                            ),
                            title: Text(task.title),
                            onTap: controller.busy.value
                                ? null
                                : () => edit(task),
                            trailing: IconButton(
                              tooltip: 'delete'.tr,
                              onPressed: controller.busy.value
                                  ? null
                                  : () => remove(task),
                              icon: const Icon(Icons.delete_outline),
                            ),
                          );
                        },
                      ),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    tooltip: 'previous'.tr,
                    onPressed:
                        controller.page.value > 1 && !controller.busy.value
                        ? () => controller.move(-1)
                        : null,
                    icon: const Icon(Icons.chevron_left),
                  ),
                  Text('${controller.page.value}'),
                  IconButton(
                    tooltip: 'next'.tr,
                    onPressed:
                        controller.page.value * 20 < controller.total.value &&
                            !controller.busy.value
                        ? () => controller.move(1)
                        : null,
                    icon: const Icon(Icons.chevron_right),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
    floatingActionButton: Obx(
      () => FloatingActionButton(
        tooltip: 'add'.tr,
        onPressed: controller.busy.value ? null : () => edit(null),
        child: const Icon(Icons.add),
      ),
    ),
  );
}

class _TaskDialog extends StatefulWidget {
  const _TaskDialog({required this.initial});
  final String initial;
  @override
  State<_TaskDialog> createState() => _TaskDialogState();
}

class _TaskDialogState extends State<_TaskDialog> {
  late final input = TextEditingController(text: widget.initial);
  final form = GlobalKey<FormState>();
  @override
  void dispose() {
    input.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text('taskTitle'.tr),
    content: Form(
      key: form,
      child: TextFormField(
        controller: input,
        autofocus: true,
        maxLength: 160,
        decoration: InputDecoration(labelText: 'taskTitle'.tr),
        validator: (v) => v == null || v.trim().isEmpty ? 'required'.tr : null,
      ),
    ),
    actions: [
      TextButton(onPressed: () => Get.back(), child: Text('cancel'.tr)),
      FilledButton(
        onPressed: () {
          if (form.currentState!.validate()) {
            Get.back(result: input.text.trim());
          }
        },
        child: Text('save'.tr),
      ),
    ],
  );
}
