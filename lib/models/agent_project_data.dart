import 'package:cloud_firestore/cloud_firestore.dart';

class AgentProjectMap{
  final String agentId;
  final String agentEmail;
  final String? supervisorId;
  final String projectId;
  final String agentStatus;
  final String? approverEmail;
  final double? agentProjectActivityScore;
  final DateTime? agentLoginTime;
  final DateTime? agentProjectStartTime;
  final DateTime? agentProjectEndTime;


  AgentProjectMap({
    required this.agentId,
    required this.agentEmail, 
    this.supervisorId, 
    required this.projectId,
    required this.agentStatus,
    this.approverEmail,
    this.agentProjectActivityScore,
    this.agentLoginTime,
    this.agentProjectStartTime,
    this.agentProjectEndTime
    });

  AgentProjectMap.fromJson(Map<String, dynamic> json)
    : this(
        agentId: json['agent_id'] as String,
        agentEmail: json['agent_email'] as String,
        supervisorId: json['supervisor_id'] as String?,
        projectId: json['project_id'] as String,
        agentStatus: json['agent_status'] as String,
        approverEmail: json['approver_email'] as String?,
        agentProjectActivityScore: json['agent_project_activity_score'] as double?,
        agentLoginTime: (json['agent_login_time'] as Timestamp?)?.toDate(),
        agentProjectStartTime: (json['agent_project_start_time'] as Timestamp?)?.toDate(),
        agentProjectEndTime: (json['agent_project_end_time'] as Timestamp?)?.toDate(),
      );

  Map<String, Object?> toJson() {
    return {
      'agent_id': agentId,
      'agent_email': agentEmail,
      'supervisor_id': supervisorId,
      'project_id': projectId,
      'agent_status': agentStatus,
      'approver_email': approverEmail,
      'agent_project_activity_score': agentProjectActivityScore,
      'agent_login_time': agentLoginTime,
      'agent_project_start_time': agentProjectStartTime,
      'agent_project_end_time': agentProjectEndTime
    };
  }
}
