
import 'package:flutter/material.dart';
import 'package:sabertech_proctor/constants.dart';
import 'package:sabertech_proctor/models/project.dart';
import 'package:sabertech_proctor/screens/manager_view/live_project_agent_list.dart';
import 'package:sabertech_proctor/screens/project_agent_list.dart';
import 'package:sabertech_proctor/screens/user_online_status.dart';

import '../../data/agent_project_data.dart';

class ProjectDetailsAdminView extends StatefulWidget {
  ProjectDetailsAdminView({required Key key, required this.projectId}) : super(key: key);
  final String projectId;

  @override
  _ProjectDetailsState createState() => _ProjectDetailsState();
}

class _ProjectDetailsState extends State<ProjectDetailsAdminView> {
  
  @override
  Widget build(BuildContext context) {
  return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        // mainAxisAlignment: MainAxisAlignment.center,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          FutureBuilder(
            future: getProjectById(widget.projectId),
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
                return buildDataTable(snapshot.data);
              }
              else{
                return Text("Loading data");
              }
            }
          ),
          SizedBox(
            height: 40,
          ),
          ProjectAgentListScreen(key: UniqueKey(), id: widget.projectId,),
        ]
    );
  }

  Widget buildDataTable(projectData) {
    final ButtonStyle styleBlue = ElevatedButton.styleFrom(primary: Colors.blueAccent);
    final ButtonStyle styleRed = ElevatedButton.styleFrom(primary: Colors.redAccent);
    final columns = ['Project Property', 'Details'];
    var projectDataCast = projectData as Project;
    return Column(
      children: [
        DataTable(
          columns: getColumns(columns),
          rows: getRows(projectData),
          showBottomBorder: true,
          headingRowColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 207, 222, 225))
        ),
        SizedBox(height: 10,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children:[
            projectDataCast.status != projectStatusLive ? 
            ElevatedButton(
              style: styleBlue,
              child: Text("Start Project"),
              onPressed: () =>{
                startProject(widget.projectId),
                setState(() {})
              },
            ):ElevatedButton(
              style: styleRed,
              child: Text("End Project"),
              onPressed: () =>{
                endProject(widget.projectId),
                setState(() {})
              },
            ),
            SizedBox(width: 10,),
            ElevatedButton(
              style: styleBlue,
              child: Text("View Agents"),
              onPressed: () => {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context)=> LiveProjectAgentList(key:UniqueKey(), projectId:widget.projectId)
                  ))
              },
            ),
          ]
        )
      ],
    );
  }

  List<DataColumn> getColumns(List<String> columns) => columns
      .map((String column) => DataColumn(
            label: Text(column),
            // onSort: onSort,
          ))
      .toList();

  List<DataRow> getRows(Project project){
    final rows = [
      ["Project Id", project.projectId],
      ["Project Name", project.projectName],
      ["Project Description", project.projectDetails],
      ["Project Start Time", project.projectStartTime]
    ];
    var index = 0;
    List<DataRow> dataRows = [];
    rows.forEach((element) {
      index += 1;
      dataRows.add(DataRow(selected: index % 2 == 0 ? true : false, cells:getCells(element)));
    });
    return dataRows;
  }

  List<DataCell> getCells(List<dynamic> cells) {
    var cellsList = cells.map(
        (data) => DataCell(SelectableText('$data'))
      ).toList();
    return cellsList;
  }

}