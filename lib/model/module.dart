
class Module {
  final String module_id;
  final String module_name;
  final DateTime? moduleStartDate;
  final DateTime? moduleEndDate;
  final int? totalDuration;
  final String projectID;
  final List<String> teamM;



  Module({
    required this.module_id,
    required this.module_name,
    this.moduleStartDate,
    this.moduleEndDate,
    this.totalDuration,
    required this.projectID,
    required this.teamM,

  });

  Map<String, dynamic> toJson() {
    return {
      '_id': module_id,
      'module_name': module_name,
      'moduleStartDate': moduleStartDate?.toIso8601String(),
      'moduleEndDate': moduleEndDate?.toIso8601String(),
      'totalDuration': totalDuration,
      'projectID': projectID,
      'teamM': teamM,
    };
  }

  factory Module.fromJson(Map<String, dynamic> json) {
    return Module(
      module_id: json['_id'],
      module_name: json['module_name'],
      moduleStartDate: json['moduleStartDate'] != null ? DateTime.parse(json['moduleStartDate']) : null,
      moduleEndDate: json['moduleEndDate'] != null ? DateTime.parse(json['moduleEndDate']) : null,
      totalDuration: json['totalDuration'],
      projectID: json['projectID'],
      teamM: List<String>.from(json['teamM']),
    );
  }

}