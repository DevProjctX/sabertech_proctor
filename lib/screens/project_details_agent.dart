
import 'package:flutter/material.dart';
import 'package:sabertech_proctor/models/project.dart';

import '../data/agent_project_data.dart';

class ProjectDetailsAgentView extends StatefulWidget {
  ProjectDetailsAgentView({required Key key, required this.projectId}) : super(key: key);
  final String projectId;

  @override
  _ProjectDetailsState createState() => _ProjectDetailsState();
}

class _ProjectDetailsState extends State<ProjectDetailsAgentView> {
  
  @override
  Widget build(BuildContext context) {

    return Container(
      child: FutureBuilder(
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
    );
  }

  Widget buildDataTable(userData) {
    final columns = ['Project Property', 'Details'];
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

  List<DataRow> getRows(Project project){
    final rows = [
      ["Project Name", project.projectName],
      ["Project Description", project.projectDetails],
      ["Project Start Time", project.projectStartTime],
      ["Google Meet Link", "meet.google.com"],
      ["Agent Login Id", "abc123"],
      ["Supervisor Contact", "9897491821"],
      ["Supervisor Name", "Raj"]
    ];
    List<DataRow> dataRows = [];
    rows.forEach((element) {
      dataRows.add(DataRow(cells:getCells(element)));
    });
    return dataRows;
  }

  List<DataCell> getCells(List<dynamic> cells) {
    var cellsList = cells.map(
        (data) => DataCell(Text('$data'))
      ).toList();
    return cellsList;
  }

}