class Task {
  final String id;
  final String title;
  final String phase;
  final String type; // 'predefined' or 'custom'
  bool completed;

  Task({
    required this.id,
    required this.title,
    required this.phase,
    required this.type,
    required this.completed,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      phase: json['phase'] ?? 'Un-categorised',
      type: json['type'] ?? 'predefined',
      completed: json['completed'] ?? false,
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
