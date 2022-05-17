
import 'package:flutter/material.dart';
import 'package:sabertech_proctor/data/agent_project_data.dart';
import 'package:sabertech_proctor/models/project.dart';
import 'package:sabertech_proctor/screens/agent_project_approval.dart';
import 'package:sabertech_proctor/screens/agents_project_view.dart';
import 'package:sabertech_proctor/screens/project_details.dart';
import 'package:sabertech_proctor/utils/authentication.dart';
// import 'package:intl/intl.dart'; // for date format

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
    // var textCellData = cells.map((data) => DataCell(Text('$data'))).toList();
    var textCellData = cells.map((data) => 
      DataCell(
        data.toString() == projectStatusLive ?
          Text('$data', style: TextStyle(color:Colors.redAccent, fontWeight: FontWeight.w800 ))
        : data.toString() == projectStatusEnded ?
          Text('$data', style: TextStyle(color:Colors.redAccent.shade100, fontWeight: FontWeight.w400 ))
        : Text('$data')
      )
    ).toList();
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
  var index = 1;

    List<DataRow> getRows(List<Project> project) => project.map(
      (Project project) {
        final cells = [project.projectName, project.status, project.projectDate?.toIso8601String().split('T').first];
        index+=1;
        return DataRow(selected: index % 2 == 0 ? true : false,cells: getCells(cells, project));
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
  TabBar _tabBar = TabBar(
                // physics: ScrollPhysics(),
                indicatorColor: Colors.black45,
                labelStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.w400),
                unselectedLabelStyle: TextStyle(color: Colors.black26, fontWeight: FontWeight.w200),
                labelColor: Colors.black,
                unselectedLabelColor: Colors.black26,
                onTap: (index) {
                // Tab index when user select it, it start from zero
                },
                tabs: [
                  Tab(icon: const Text("Recent Upcoming Projects", )),
                  Tab(icon: const Text("All Projects")),
                ],
                );
  return (userRole == admin || userRole == supervisor) ? DefaultTabController(
  length: 2,
  child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.lightBlue.shade500,
            bottom: PreferredSize(
              preferredSize: _tabBar.preferredSize,
              child: ColoredBox(
                color: Color.fromARGB(255, 237, 237, 237),
                child: _tabBar,
            )),
            title: Text('Project Tabs', style: TextStyle(fontWeight: FontWeight.w400), ),
            // backgroundColor: Color.fromARGB(207, 204, 240, 237),,
            // backgroundColor:
            //       Theme.of(context).bottomAppBarColor.withOpacity(_opacity),
            // title: TopBarContents(_opacity),
            shadowColor: Color.fromARGB(255, 0, 0, 0),
            // title: Text('Project Tabs'),
          ),
          body: TabBarView(
            children: [
              SingleChildScrollView(
                child:FutureBuilder(
                  future: getAllProjectsForToday(),
                  builder: (BuildContext context, snapshot){
                    if(snapshot.hasData){
                      return buildDataTable(snapshot.data);
                    } else{
                      return Text("Loading data");
                    }
                  },
                ),
              ),
              SingleChildScrollView(
                child: FutureBuilder(
                  future: getAllProjects(),
                  builder: (BuildContext context, snapshot){
                    if(snapshot.hasData){
                      return buildDataTable(snapshot.data);
                    } else{
                      return Text("Loading data");
                    }
                  },
                ),
              )
            ],
          ),
        )): AgentProjectScreen(key:UniqueKey());
  }
}
