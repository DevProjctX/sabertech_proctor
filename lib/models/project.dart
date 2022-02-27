class Project{
  final String projectName;
  final String status;
  final int duration;

  Project({required this.projectName, required this.status, required this.duration});

  Project.fromJson(Map<String, Object?> json)
    : this(
        projectName: json['project_name']! as String,
        status: json['status']! as String,
        duration: json['project_duration']! as int
      );

  Map<String, Object?> toJson() {
    return {
      'project_name': projectName,
      'status': status,
      'project_duration': duration
    };
  }
}
