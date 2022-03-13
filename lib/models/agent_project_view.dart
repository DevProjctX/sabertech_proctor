
class AgentProjectView{
  final String projectName;
  final String projectId;
  final String? supervisorId;
  final String agentStatus;
  final String? approverEmail;
  final DateTime projectStartTime;
  final String projectStatus;
  final int duration;
  final String projectDetails;

  AgentProjectView({
    required this.projectName,
    required this.projectId, 
    this.supervisorId, 
    required this.agentStatus,
    this.approverEmail,
    required this.projectStartTime,
    required this.projectStatus,
    required this.duration,
    required this.projectDetails
    });
}
