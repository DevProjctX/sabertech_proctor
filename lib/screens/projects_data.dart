
import 'package:flutter/material.dart';
import 'package:sabertech_proctor/data/agent_project_data.dart';
import 'package:sabertech_proctor/models/project.dart';
import 'package:sabertech_proctor/screens/agent_project_approval.dart';
import 'package:sabertech_proctor/screens/agents_project_view.dart';
import 'package:sabertech_proctor/screens/project_details.dart';
import 'package:sabertech_proctor/utils/authentication.dart';

import '../constants.dart';

class GetProject extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
  List<DataColumn> getColumns(List<String> columns) => columns
    .map((String column) => DataColumn(
          label: Text(column),
        ))
    .toList();


  List<DataCell> getCells(List<dynamic> cells, Project project){
    var textCellData = cells.map((data) => DataCell(Text('$data'))).toList();
    if(userRole == admin || userRole == supervisor){
      textCellData.add(
        DataCell(
          ElevatedButton(
            child: Text("Approve Agents"),
            onPressed: () =>{
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context)=> AgentProjectApprovalScreen(key:UniqueKey(), id: project.projectId)))
            },
          )
        )
      );
    } else{
      // print('$agentProjectData');
      textCellData.add(
      DataCell(
        ElevatedButton(
          child: Text("Signup"),
          onPressed: () =>{
                projectSignUp(uid ?? "", project.projectId).then((value) => 
                  Navigator.of(context)
                  .pushReplacement(
                    MaterialPageRoute(
                      fullscreenDialog: true,
                      builder: (context) => GetProject(),
                    )
                  )
                )
            },)
        )
      );
    }
    textCellData.add(
        DataCell(
          ElevatedButton(
            child: Text("View Project"),
            onPressed: () =>{
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context)=> ProjectDetails(key:UniqueKey(), projectId: project.projectId)))
            },
          )
        )
      );
    return textCellData;
  }

    List<DataRow> getRows(List<Project> project) => project.map(
      (Project project) {
        final cells = [project.projectName, project.status, project.duration];
        return DataRow(cells: getCells(cells, project));
      }).toList();

  Widget buildDataTable(projectData) {
    List<String> columns = [];
    if(userRole == admin || userRole == supervisor){
      columns = ['Project Name', 'Project Status', 'Duration', 'View Agents', 'Project Details'];
    } else{
      columns = ['Project Name', 'Project Status', 'Duration', 'Status', 'Project Details'];
    }
    return DataTable(
      columns: getColumns(columns),
      rows: getRows(projectData)
    );
  }
  print(userRole);
  return (userRole == admin || userRole == supervisor) ? DefaultTabController(
  length: 2,
  child: MaterialApp(
    home: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              onTap: (index) {
              // Tab index when user select it, it start from zero
              },
              tabs: [
                Tab(icon: const Text("Upcoming Project")),
                Tab(icon: const Text("Completed Project")),
              ],
            ),
            title: Text('Project Tabs'),
          ),
          body: TabBarView(
            children: [
              FutureBuilder(
                future: getAllProjectsForToday(),
                builder: (BuildContext context, snapshot){
                  if(snapshot.hasData){
                    return buildDataTable(snapshot.data);
                  } else{
                    return Text("Loading data");
                  }
                },
              ),
              FutureBuilder(
                future: getAllActiveProjects(),
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
        ))): AgentProjectScreen(key:UniqueKey());
  }
}
