
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sabertech_proctor/constants.dart';
import 'package:sabertech_proctor/models/agent_project_data.dart';
import 'package:sabertech_proctor/models/agent_project_view.dart';
import 'package:sabertech_proctor/models/project.dart';
import 'package:sabertech_proctor/utils/authentication.dart';

Future<List<AgentProjectMap>> getAgentAllProjects(String uid) async{
  final userProjectRef = FirebaseFirestore.instance.collection('agent-project-map').withConverter<AgentProjectMap>(
    fromFirestore: (snapshot, _) => AgentProjectMap.fromJson(snapshot.data()!),
    toFirestore: (agentProjectData, _) => agentProjectData.toJson(),
  );
  List<AgentProjectMap> dataDocs = [];
  userProjectRef.where('agent_id', isEqualTo:uid).get()
  .then(
    (snapshot) => snapshot.docs.forEach(
      (userProjectData) => {
          // print(projectDoc.data());
      dataDocs.add(userProjectData.data())
      }
    ));
  return dataDocs;
}

Future<AgentProjectMap?> getAgentProjectData(String uid, String projectId) async{
  final userProjectRef = FirebaseFirestore.instance.collection('agent-project-map').withConverter<AgentProjectMap>(
    fromFirestore: (snapshot, _) => AgentProjectMap.fromJson(snapshot.data()!),
    toFirestore: (agentProjectData, _) => agentProjectData.toJson(),
  );
  print('getAgentProjectData uid projectId $uid, $projectId');
  List<AgentProjectMap> dataDocs = [];
  await userProjectRef.where('agent_id', isEqualTo:uid).where('project_id', isEqualTo: projectId).get()
  .then(
    (snapshot) => snapshot.docs.forEach(
      (userProjectData) => {
        // print('getAgentProjectData ${userProjectData.data().agentStatus}'),
        dataDocs.add(userProjectData.data())
      }
    ));
  print('getAgentProjectData dataDocs ${dataDocs}');
  if(dataDocs.isNotEmpty){
    return dataDocs.first;
  } else{
    return null;
  }
}

String createUidProjectHash(String uid, String projectId) {
   return "$uid.$projectId";
}

List<String> decodeProjectHash(String hashString){
  return hashString.split('.');
}

Future<void> projectSignUp(String uid, String projectId) async{
  final userProjectRef = FirebaseFirestore.instance.collection('agent-project-map');
  List<AgentProjectMap> dataDocs = [];
  var projectAgentHash = createUidProjectHash(uid, projectId);
  var projectAgentMap = AgentProjectMap(
    agentId: uid,
    agentEmail: userEmail ?? "",
    projectId: projectId,
    agentStatus: waiting
  );
  return await userProjectRef.doc(projectAgentHash).set(projectAgentMap.toJson());
}

Future<List<AgentProjectMap>> getUsersForProjectApproval(String projectId) async {
  final userProjectRef = FirebaseFirestore.instance.collection('agent-project-map').withConverter<AgentProjectMap>(
    fromFirestore: (snapshot, _) => AgentProjectMap.fromJson(snapshot.data()!),
    toFirestore: (agentProjectData, _) => agentProjectData.toJson(),
  );
  List<AgentProjectMap> dataDocs = [];
  await userProjectRef.where('project_id', isEqualTo:projectId).where('agent_status', isEqualTo: waiting).get()
  .then(
    (snapshot) => {
      // print('${snapshot.docs}')
      snapshot.docs.forEach(
        (userProjectData) => {
        dataDocs.add(userProjectData.data())
      })
    });
  return dataDocs;
}

Future<List<AgentProjectMap>> getUsersForProject(String projectId) async {
  final userProjectRef = FirebaseFirestore.instance.collection('agent-project-map').withConverter<AgentProjectMap>(
    fromFirestore: (snapshot, _) => AgentProjectMap.fromJson(snapshot.data()!),
    toFirestore: (agentProjectData, _) => agentProjectData.toJson(),
  );
  List<AgentProjectMap> dataDocs = [];
  await userProjectRef.where('project_id', isEqualTo:projectId).get()
  .then(
    (snapshot) => {
      // print('${snapshot.docs}')
      snapshot.docs.forEach(
        (userProjectData) => {
        dataDocs.add(userProjectData.data())
      })
    });
  return dataDocs;
}

Future<void> approveAgent(String uid, String projectId) async{
  final userProjectRef = FirebaseFirestore.instance.collection('agent-project-map');
  var projectAgentHash = createUidProjectHash(uid, projectId);
  return await userProjectRef.doc(projectAgentHash).update({'agent_status': approved, 'approver_email': userEmail});
}

Future<void> rejectAgent(String uid, String projectId) async{
  final userProjectRef = FirebaseFirestore.instance.collection('agent-project-map');
  var projectAgentHash = createUidProjectHash(uid, projectId);
  return await userProjectRef.doc(projectAgentHash).update({'agent_status': rejected, 'approver_email': userEmail});
}

Future<List<AgentProjectView>> getAgentProjectView(String uid) async{
  List<AgentProjectView> agentProjectView = [];
  await getAllActiveProjects().then(
    (project) async => {
      await Future.wait( project.map(
        (element) async { 
          AgentProjectView singleProjectView;
          await getAgentProjectData(uid, element.projectId).then(
            (agentProject) => {
              singleProjectView = AgentProjectView(
                projectName: element.projectName, 
                projectId: element.projectId, 
                agentStatus: agentProject?.agentStatus ?? notRegistered, 
                projectStartTime: element.projectStartTime, 
                projectStatus: element.status, 
                duration: element.duration, 
                projectDetails: element.projectDetails
              ),
              agentProjectView.add(singleProjectView)
            });
        }
      )
      )}
  );
  return agentProjectView;
}

Future<List<Project>> getAllActiveProjects() async {
      final projectRef = FirebaseFirestore.instance.collection('projects').withConverter<Project>(
        fromFirestore: (snapshot, _) => Project.fromJson(snapshot.data()!),
        toFirestore: (project, _) => project.toJson(),
      );
      List<Project> dataDocs = [];
      (await projectRef.limit(10).get()
        .then((snapshot) => snapshot.docs.forEach((projectDoc) => {
          // print(projectDoc.data());
          dataDocs.add(projectDoc.data())
        })));
      return dataDocs;
    }

Future<List<Project>> getAllEndedProjects() async {
      final projectRef = FirebaseFirestore.instance.collection('projects').withConverter<Project>(
        fromFirestore: (snapshot, _) => Project.fromJson(snapshot.data()!),
        toFirestore: (project, _) => project.toJson(),
      );
      List<Project> dataDocs = [];
      (await projectRef.limit(10).get()
        .then((snapshot) => snapshot.docs.forEach((projectDoc) => {
          // print(projectDoc.data());
          dataDocs.add(projectDoc.data())
        })));
      return dataDocs;
    }

Future<List<Project>> getAllProjectsForToday() async {
      final projectRef = FirebaseFirestore.instance.collection('projects').withConverter<Project>(
        fromFirestore: (snapshot, _) => Project.fromJson(snapshot.data()!),
        toFirestore: (project, _) => project.toJson(),
      );
      List<Project> dataDocs = [];
      (await projectRef.limit(10).get()
        .then((snapshot) => snapshot.docs.forEach((projectDoc) => {
          print(projectDoc.data()),
          dataDocs.add(projectDoc.data())
        })));
      return dataDocs;
    }


Future<Project?> getProjectById(String id) async {
      final projectRef = FirebaseFirestore.instance.collection('projects').withConverter<Project>(
        fromFirestore: (snapshot, _) => Project.fromJson(snapshot.data()!),
        toFirestore: (project, _) => project.toJson(),
      );
      Project? dataDocs;
      (await projectRef.doc(id).get()
        .then((snapshot) => 
          dataDocs = snapshot.data()
        ));
      return dataDocs;
    }


// Future<void> uploadAgentSupervisorDetails(List<String> header, List<List<String>> csvData) async{
//   final userProjectRef = FirebaseFirestore.instance.collection('agent-project-map');
//   var projectAgentHash = createUidProjectHash(uid, projectId);
//   return await userProjectRef.doc(projectAgentHash).update({'agent_status': approved, 'approver_email': userEmail});
// }