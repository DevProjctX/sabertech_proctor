import 'package:flutter/material.dart';
import 'package:sabertech_proctor/data/agent_project_data.dart';
import 'package:sabertech_proctor/models/agent_project_view.dart';
import 'package:sabertech_proctor/screens/project_details.dart';
import 'package:sabertech_proctor/utils/authentication.dart';

import '../constants.dart';

class AgentProjectScreen extends StatefulWidget{
  // var id;

  const AgentProjectScreen({required Key key}) : super(key: key);
  @override
  _AgentProjectScreenState createState() => _AgentProjectScreenState();
}
class _AgentProjectScreenState extends State<AgentProjectScreen> {
  @override
  Widget build(BuildContext context) {
  List<DataColumn> getColumns(List<String> columns) => columns
    .map((String column) => DataColumn(
          label: Text(column),
          // onSort: onSort,
        ))
    .toList();


  List<DataCell> getCells(List<dynamic> cells, AgentProjectView project){
    var textCellData = cells.map((data) => DataCell(Text('$data'))).toList();
      textCellData.add(
      DataCell(
        project.agentStatus == notRegistered ?
          ElevatedButton(
            child: Text("Signup"),
            onPressed: () =>{
                  projectSignUp(uid ?? "", project.projectId).then((value) => 
                    setState(()=>{})
                  )
              },): Text(project.agentStatus)
      )
    );
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

    List<DataRow> getRows(List<AgentProjectView> project) => project.map(
      (AgentProjectView project) {
        final cells = [project.projectName, project.projectStatus, project.duration];
        return DataRow(cells: getCells(cells, project));
      }).toList();

  Widget buildDataTable(projectData) {
    List<String> columns = [];
    if(userRole == admin || userRole == supervisor){
      columns = ['Project Name', 'Project Status', 'Duration', 'View Agents'];
    } else{
      columns = ['Project Name', 'Project Status', 'Duration', 'Status', 'View Project'];
    }
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
                Tab(icon: const Text("Siigned Up Project")),
                Tab(icon: const Text("Floated Project")),
              ],
            ),
            title: Text('Project Tabs'),
          ),
          body: TabBarView(
            children: [
              FutureBuilder(
                future: getAgentSignedUpProjectView(uid ?? ""),
                builder: (BuildContext context, snapshot){
                  if(snapshot.hasData){
                    return buildDataTable(snapshot.data);
                  } else{
                    return Text("Loading data");
                  }
                },
              ),
              FutureBuilder(
                future: getUnsignedUpcomingProjectAgent(uid ?? ""),
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
