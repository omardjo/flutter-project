class Project {
  String? id;
  String name;
  int? totalDuration;
  DateTime startDate;
  DateTime endDate;
  String description;
  List<String> keywords;
  String teamLeader;
  List<String> members;
  bool isComplete;


  Project({
    this.id,
    required this.name,
    this.totalDuration = 0,
    required this.startDate,
    required this.endDate,
    required this.description,
    required this.keywords,
    required this.teamLeader,
    required this.members,
    this.isComplete = false,

  });

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'totalDuration': totalDuration,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'description': description,
      'keywords': keywords,
      'teamLeader': teamLeader,
      'members': members,
      'isComplete': isComplete
    };
  }

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['_id'],
      name: json['name'],
      totalDuration: json['totalDuration'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      description: json['description'],
      keywords: List<String>.from(json['keywords']),
      teamLeader: json['teamLeader'],
      members: List<String>.from(json['members']),
      isComplete: json['isComplete'] ?? false,
    );
  }
}