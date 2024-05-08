class Task {
  final String taskId;
  final String moduleId;
  final String projectID;
  final String taskDescription;
  final List<String> team;
  final bool completed;
  final int? Duration;
  final DateTime? startDate;
  final DateTime? endDate;


  Task({
    required this.taskId,
    required this.moduleId,
    required this.projectID,
    required this.taskDescription,
    required this.team,
    required this.completed,
    this.Duration,
    this.startDate,
    this.endDate,
  });

  Map<String, dynamic> toJson() {
    return {
      '_id': taskId,
      'module_id': moduleId,
      'projectID': projectID,
      'task_description': taskDescription,
      'team': team,
      'completed': completed,
      'Duration': Duration,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
    };
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      taskId: json['_id'],
      moduleId: json['module_id'],
      projectID: json['projectID'],
      taskDescription: json['task_description'],
      team: List<String>.from(json['team']),
      completed: json['completed'],
      Duration: json['Duration'],
      startDate: json['startDate'] != null ? DateTime.parse(json['startDate']) : null,
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
    );
  }

}