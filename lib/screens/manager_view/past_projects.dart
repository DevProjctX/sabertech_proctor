
import 'package:flutter/material.dart';
import 'package:sabertech_proctor/data/agent_project_data.dart';
import 'package:sabertech_proctor/models/project.dart';
import 'package:sabertech_proctor/screens/agent_project_approval.dart';
import 'package:sabertech_proctor/screens/agent_view/agent_past_projects.dart';
import 'package:sabertech_proctor/screens/agents_project_view.dart';
import 'package:sabertech_proctor/screens/project_details.dart';
import 'package:sabertech_proctor/utils/authentication.dart';
// import 'package:intl/intl.dart'; // for date format

import '/constants.dart';

class PastProjects extends StatelessWidget{
  const PastProjects({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("PastProjects");
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
                projectSignUp(uid ?? "", project.projectId, null).then((value) => 
                  Navigator.of(context)
                  .pushReplacement(
                    MaterialPageRoute(
                      fullscreenDialog: true,
                      builder: (context) => PastProjects(),
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
    var index = 0;
    List<DataRow> getRows(List<Project> project) => project.map(
      (Project project) {
        index += 1; 
        final cells = [project.projectName, project.status, project.projectDate?.toIso8601String().split('T').first];
        return DataRow(selected: index % 2 == 0 ? true : false, cells: getCells(cells, project));
      }).toList();

  Widget buildDataTable(projectData) {
    List<String> columns = [];
    if(userRole == admin || userRole == supervisor){
      columns = ['Project Name', 'Project Status', 'Project Date', 'View Agents', 'Project Details'];
    } else{
      columns = ['Project Name', 'Project Status', 'Project Date', 'Status', 'Project Details'];
    }
    return DataTable(
      columns: getColumns(columns),
      rows: getRows(projectData),
      showBottomBorder: true,
      headingRowColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 207, 222, 225)),
    );
  }
  print(userRole);
  return (userRole == admin || userRole == supervisor) ? DefaultTabController(
  length: 2,
  child: Scaffold(
          appBar: AppBar(
            // backgroundColor:
            //       Theme.of(context).bottomAppBarColor.withOpacity(_opacity),
            // title: TopBarContents(_opacity),
            title: Text('Past project Tabs'),
          ),
          body: Center(
            child: FutureBuilder(
                future: getAllEndedProjects(),
                builder: (BuildContext context, snapshot){
                  if(snapshot.hasData){
                    return buildDataTable(snapshot.data);
                  } else{
                    return Text("Loading data");
                  }
                },
              ),
          )
        )): AgentPastProjectScreen(key:UniqueKey());
  }
}
