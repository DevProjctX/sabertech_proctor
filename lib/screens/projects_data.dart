
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sabertech_proctor/data/projects.dart';
import 'package:sabertech_proctor/models/project.dart';

class GetProject extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    // Create a CollectionReference called users that references the firestore collection
    final projectRef = FirebaseFirestore.instance.collection('projects').withConverter<Project>(
      fromFirestore: (snapshot, _) => Project.fromJson(snapshot.data()!),
      toFirestore: (project, _) => project.toJson(),
    );
    Future<List<Project>> getProject() async {
      List<Project> dataDocs = [];
      (await projectRef.limit(10).get()
        .then((snapshot) => snapshot.docs.forEach((projectDoc) => {
          // print(projectDoc.data());
          dataDocs.add(projectDoc.data())
        })));
      return dataDocs;
    }

    // List<QuerySnapshot<Project>> projectData = getProject().then((doc) => doc)

    // Future<void> getProject() async{
    //   // Call the user's CollectionReference to add a new user
    //   // QuerySnapshot project = 
    //   await FirebaseFirestore.instance.collection('projects').get()
    //   .then((QuerySnapshot querySnapshot) => querySnapshot.docs.forEach((element) {
    //     projectData.add(element.data());
    //     print("Fetched data");
    //   }));
    // }

  List<DataColumn> getColumns(List<String> columns) => columns
    .map((String column) => DataColumn(
          label: Text(column),
          // onSort: onSort,
        ))
    .toList();


  List<DataCell> getCells(List<dynamic> cells) =>
      cells.map((data) => DataCell(Text('$data'))).toList();

    List<DataRow> getRows(List<Project> project) => project.map(
      (Project project) {
        final cells = [project.projectName, project.status, project.duration];
        final projectDummy = getProject();
        return DataRow(cells: getCells(cells));
      }).toList();

  Widget buildDataTable(projectData) {
    final columns = ['Project Name', 'Status', 'Duration'];
    return DataTable(
      columns: getColumns(columns),
      rows: getRows(projectData)
    );
  }

    return DefaultTabController(
  length: 2,
  child: MaterialApp(
    home: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              onTap: (index) {
              // Tab index when user select it, it start from zero
              },
              tabs: [
                Tab(icon: Text("Upcoming Project")),
                Tab(icon: Text("Completed Project")),
              ],
            ),
            title: Text('Project Tabs'),
          ),
          body: TabBarView(
            children: [
              FutureBuilder(
                future: getProject(),
                builder: (BuildContext context, snapshot){
                  if(snapshot.hasData){
                    return buildDataTable(snapshot.data);
                  } else{
                    return Text("Loading data");
                  }
                },
              ),
              FutureBuilder(
                future: getProject(),
                builder: (BuildContext context, snapshot){
                  if(snapshot.hasData){
                    return buildDataTable(snapshot.data);
                  } else{
                    return Text("Loading data");
                  }
                },
              ),
            ],
          ),
        )));
  }
}
