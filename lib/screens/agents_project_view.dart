import 'package:flutter/material.dart';
import 'package:sabertech_proctor/data/agent_project_data.dart';
import 'package:sabertech_proctor/models/agent_project_view.dart';
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
          label: Text(column, style: TextStyle(
            fontWeight: FontWeight.w600,
            ),),
        
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
      columns = ['Project Name', 'Project Status', 'Duration', 'Status'];
    }
    return DataTable(
      columns: getColumns(columns),
      rows: getRows(projectData),
      showBottomBorder: true,
      headingRowColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 227, 242, 245)),
    );
  }

TabBar _tabBar = TabBar(
                onTap: (index) {
                // Tab index when user select it, it start from zero
                },
                tabs: [
                  Tab(icon: const Text("Upcoming Project", style: TextStyle(color: Color.fromARGB(255, 9, 73, 100)),)),
                  Tab(icon: const Text("Completed Project", style: TextStyle(color: Color.fromARGB(255, 9, 73, 100)),)),
                ],
                );

  return DefaultTabController(
  length: 2,
  child: Scaffold(
          appBar: AppBar(
            bottom: PreferredSize(
              preferredSize: _tabBar.preferredSize,
              child: ColoredBox(
                color: Colors.white,
                child: _tabBar,
                )),
            title: Text('Project Tabs', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w400), ),
            backgroundColor: Color.fromARGB(207, 204, 240, 237),
          ),
          body: TabBarView(
            children: [
              FutureBuilder(
                future: getAgentProjectView(uid ?? ""),
                builder: (BuildContext context, snapshot){
                  if(snapshot.hasData){
                    return buildDataTable(snapshot.data);
                  } else{
                    return Text("Loading data");
                  }
                },
              ),
              FutureBuilder(
                future: getAgentProjectView(uid ?? ""),
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
        ));
  }
}
