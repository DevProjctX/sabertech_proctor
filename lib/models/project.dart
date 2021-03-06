import 'package:cloud_firestore/cloud_firestore.dart';

class Project{
  final String projectId;
  final String projectName;
  final String status;
  final int duration;
  final int? numAgents;
  final int? numStudents;
  final int? numSupervisor;
  final DateTime? projectDate;
  final String projectDetails;
  final DateTime projectStartTime;
  final DateTime projectEndTime;
  final DateTime? projectStartedTime;
  final DateTime? projectEndedTime;


  Project({
    required this.projectId,
    required this.projectName, 
    required this.status, 
    required this.duration,
    this.numAgents,
    this.numStudents,
    this.numSupervisor,
    required this.projectStartTime,
    required this.projectEndTime,
    required this.projectDetails,
    this.projectDate,
    this.projectStartedTime,
    this.projectEndedTime
  });

  Project.fromJson(Map<String, Object?> json)
    : this(
        projectId: json['project_id']! as String,
        projectName: json['project_name']! as String,
        status: json['status']! as String,
        duration: json['project_duration']! as int,
        numAgents: json['num_agents'] as int,
        numStudents: json['num_students'] as int,
        numSupervisor: json['num_supervisor'] as int,
        projectStartTime: (json['project_start_time'] as Timestamp).toDate(),
        projectEndTime: (json['project_end_time'] as Timestamp).toDate(),
        projectStartedTime: (json['project_started_time'] as Timestamp?)?.toDate(),
        projectEndedTime: (json['project_ended_time'] as Timestamp?)?.toDate(),
        projectDetails: json['project_details'] as String,
        projectDate: (json['project_date'] as Timestamp).toDate(),
      );

  Map<String, Object?> toJson() {
    return {
      'project_id': projectId,
      'project_name': projectName,
      'status': status,
      'project_duration': duration,
      'num_agents': numAgents,
      'num_students': numStudents,
      'num_supervisor': numSupervisor,
      'project_start_time': projectStartTime,
      'project_end_time': projectEndTime,
      'project_started_time': projectStartedTime,
      'project_ended_time': projectEndedTime,
      'project_details': projectDetails,
      'project_date': projectDate,
    };
  }
}
