import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_app_starter/features/tasks/task_model.dart';

void main() {
  test('update preserves version and unchanged fields', () {
    final task = Task.fromJson({
      'id': '1',
      'title': 'test',
      'completed': false,
      'version': 3,
    });
    expect(task.update(completed: true), {
      'title': 'test',
      'completed': true,
      'version': 3,
    });
  });
}
