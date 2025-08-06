class Task {
  final String id;
  final String title;
  final String phase;
  final String type; // 'predefined' or 'custom'
  final String task;
  bool completed;

  Task({
    required this.id,
    required this.title,
    required this.phase,
    required this.type,
    required this.completed,
    required this.task
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      phase: json['phase'] ?? 'Un-categorised',
      type: json['type'] ?? 'predefined',
      completed: json['completed'] ?? false,
      task: json['task'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'phase': phase,
      'type': type,
      'completed': completed,
    };
  }
}
