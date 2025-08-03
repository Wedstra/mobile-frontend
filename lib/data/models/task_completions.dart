class TaskCompletions {
  final String? id;
  final String userId;
  final String taskId;
  final bool completed;
  final String? completedAt;

  TaskCompletions({
    this.id,
    required this.userId,
    required this.taskId,
    this.completed = false,
    this.completedAt,
  });

  // Factory constructor to create from JSON
  factory TaskCompletions.fromJson(Map<String, dynamic> json) {
    return TaskCompletions(
      id: json['_id'] ?? json['id'],
      userId: json['userId'],
      taskId: json['taskId'],
      completed: json['completed'] ?? false,
      completedAt: json['completedAt'],
    );
  }

  // Convert to JSON for sending to API
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'userId': userId,
      'taskId': taskId,
      'completed': completed,
      if (completedAt != null) 'completedAt': completedAt,
    };
  }
}
