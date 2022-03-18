
import 'package:flutter/material.dart';
import 'package:sabertech_proctor/data/agent_project_data.dart';
import 'package:sabertech_proctor/models/agent_project_data.dart';
import 'package:sabertech_proctor/models/project.dart';
import 'package:sabertech_proctor/screens/agent_project_approval.dart';
import 'package:sabertech_proctor/screens/projects_data.dart';
import 'package:sabertech_proctor/utils/authentication.dart';

import '../constants.dart';


class ProjectDetailsScreen extends StatefulWidget {

  final String id;
  const ProjectDetailsScreen({required Key key, required this.id}) : super(key: key);
  @override
  _ProjectDetailsScreenState createState() => _ProjectDetailsScreenState();
}


class _ProjectDetailsScreenState extends State<ProjectDetailsScreen> {
  @override
  Widget build(BuildContext context) {
  List<DataColumn> getColumns(List<String> columns) => columns
    .map((String column) => DataColumn(
          label: Text(column),
        ))
    .toList();


  List<DataCell> getCells(List<dynamic> cells, Project project){
    var textCellData = cells.map((data) => DataCell(Text('$data'))).toList();
    // if(userRole == admin || userRole == supervisor){
    //   textCellData.add(
    //   DataCell(
    //     ElevatedButton(
    //       child: Text("Approve Agents"),
    //       onPressed: () =>{
    //             Navigator.of(context).push(
    //               MaterialPageRoute(
    //                 builder: (context)=> AgentProjectApprovalScreen(key:UniqueKey(), id: project.projectId)))
    //         },)
    //     )
    //   );
    // } else{
    //   // print('$agentProjectData');
    //   textCellData.add(
    //   DataCell(
    //     ElevatedButton(
    //       child: Text("Signup"),
    //       onPressed: () =>{
    //             projectSignUp(uid ?? "", project.projectId).then((value) => 
    //               Navigator.of(context)
    //               .pushReplacement(
    //                 MaterialPageRoute(
    //                   fullscreenDialog: true,
    //                   builder: (context) => GetProject(),
    //                 )
    //               )
    //             )
    //         },)
    //     )
    //   );
    // }
    return textCellData;
  }

    List<DataRow> getRows(List<Project> project) => project.map(
      (Project project) {
        final cells = [project.projectName, project.status, project.duration];
        return DataRow(cells: getCells(cells, project));
      }).toList();

  Widget buildDataTable(projectData) {
    List<String> columns = ['Project Name', 'Project Status', 'Duration'];
    // columns = ['Project Name', 'Project Status', 'Duration', 'View Agents'];
    // if(userRole == admin || userRole == supervisor){
    //   columns = ['Project Name', 'Project Status', 'Duration', 'View Agents'];
    // } else{
    //   columns = ['Project Name', 'Project Status', 'Duration', 'Status'];
    // }
    return DataTable(
      columns: getColumns(columns),
      rows: getRows([projectData])
    );
  }
  print(userRole);
  return MaterialApp(
    home: Scaffold(
          appBar: AppBar(
            title: Text('Project Details Page'),
          ),
          body: Column(
            children: [
              FutureBuilder(
                future: getProjectById(widget.id),
                builder: (BuildContext context, snapshot){
                  if(snapshot.hasData){
                    return buildDataTable(snapshot.data);
                  } else{
                    return Text("Loading data");
                  }
                },
              ),
              FutureBuilder(
                  future: getUsersForProject(widget.id),
                  builder: (BuildContext context, snapshot){
                    if (snapshot.hasError) {
                      print(snapshot.error);
                      return Text("Something went wrong");
                    }
                    if (!snapshot.hasData) {
                      return Text("No data");
                    }

                    if (!snapshot.hasData) {
                      return Text("Document does not exist");
                    }
                    if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                      return buildDataTableUsers(snapshot.data);
                    }
                    else{
                      return Text("Loading data");
                    }
                  }
              ),
            ],
          )
        ));
  }

  Widget buildDataTableUsers(userData) {
    final columns = ['agentId', 'emailId', 'Status', 'View Agent'];
    return DataTable(
      columns: getColumns(columns),
      rows: getRows(userData)
    );
  }

  List<DataColumn> getColumns(List<String> columns) => columns
      .map((String column) => DataColumn(
            label: Text(column),
            // onSort: onSort,
          ))
      .toList();

  List<DataRow> getRows(List<AgentProjectMap> agents) => agents.map((AgentProjectMap user) {
        final cells = [user.agentId, user.agentEmail, user.agentStatus];
        print(cells);
        return DataRow(cells: getCells(cells, user.agentId));
      }).toList();

  List<DataCell> getCells(List<dynamic> cells, String agentId) {
    var cellsList = cells.map(
        (data) => DataCell(Text('$data'))
      ).toList();
    final ButtonStyle style = ElevatedButton.styleFrom(primary: Colors.blue);
    cellsList.add(
      DataCell(
        Row(
          children: [
            ElevatedButton(
              style: style,
              child: Text("View Agent"),
              onPressed: () =>{
                    approveAgent(agentId, widget.id),
                    setState(() {})
              },
            ),
          ],
        )
      )
    );
    return cellsList;
  }


}
