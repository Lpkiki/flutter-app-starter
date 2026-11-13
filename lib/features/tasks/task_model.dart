/// Immutable API model with optimistic concurrency version.
class Task {
  const Task({
    required this.id,
    required this.title,
    required this.completed,
    required this.version,
  });
  final String id, title;
  final bool completed;
  final int version;
  factory Task.fromJson(Map<String, dynamic> json) => Task(
    id: json['id'] as String,
    title: json['title'] as String,
    completed: json['completed'] as bool,
    version: json['version'] as int,
  );
  Map<String, dynamic> update({String? title, bool? completed}) => {
    'title': title ?? this.title,
    'completed': completed ?? this.completed,
    'version': version,
  };
}
