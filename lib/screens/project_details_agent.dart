
import 'package:flutter/material.dart';
import 'package:sabertech_proctor/models/agent_project_data.dart';
import 'package:sabertech_proctor/models/project.dart';
import 'package:sabertech_proctor/models/users.dart';
import 'package:sabertech_proctor/screens/project_agent_list.dart';
import 'package:sabertech_proctor/screens/supervisor_view/supervisor_project_agent_list.dart';
import 'package:sabertech_proctor/utils/authentication.dart';

import '../../constants.dart';
import '../../data/agent_project_data.dart';

class ProjectDetailAgent extends StatefulWidget {
  ProjectDetailAgent({required Key key, required this.projectId}) : super(key: key);
  final String projectId;

  @override
  _ProjectDetailsState createState() => _ProjectDetailsState();
}

class _ProjectDetailsState extends State<ProjectDetailAgent> {
  String meetLink = "";
  String agentLoginId = "";
  String agentLoginCode = "";
  @override
  Widget build(BuildContext context) {
    // meetLink = widget.agentProjectMap.googleMeetLink ?? "";
    // agentLoginId = widget.agentProjectMap.agentLoginId ?? "";
    // agentLoginCode = widget.agentProjectMap.agentLoginCode ?? "";
  return Column(
        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          FutureBuilder(
            future: Future.wait([getProjectById(widget.projectId), getAgentProjectData(uid??"", widget.projectId)]),
            builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot){
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
                return buildDataTable(snapshot);
              }
              else{
                return Text("Loading data");
              }
            }
          ),
        ]
    );
  }

  Widget buildDataTable(futureData) {
    final columns = ['Project Property', 'Details'];
    return DataTable(
      columns: getColumns(columns),
      rows: getRows(futureData.data[0], futureData.data[1]),
      showBottomBorder: true,
      headingRowColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 207, 222, 225)),
    );
  }

  List<DataColumn> getColumns(List<String> columns) => columns
      .map((String column) => DataColumn(
            label: Text(column),
            // onSort: onSort,
          ))
      .toList();

  List<DataRow> getRows(Project project, AgentProjectMap agentProjectMap){
    final rows = [
      ["Project Name", project.projectName],
      ["Project Description", project.projectDetails],
      ["Project Start Time", project.projectStartTime],
      ["Supervisor Contact", agentProjectMap.supMobileNumber],
      ["Supervisor Name", agentProjectMap.supervisorName],
      [googleMeetText, agentProjectMap.googleMeetLink],
      [agentLoginIdText, agentProjectMap.agentLoginId],
      [agentLoginCodeText, agentProjectMap.agentLoginCode],
    ];

    List<DataRow> dataRows = [];
    rows.forEach((element) {
      dataRows.add(DataRow(cells:getCells(element)));
    });
    // editableRows.forEach((element) {
    //   dataRows.add(DataRow(cells:getEditableCells(element)));
    // });
    return dataRows;
  }

  List<DataCell> getCells(List<dynamic> cells) {
    var cellsList = cells.map(
        (data) => DataCell(Text('$data'))
      ).toList();
    return cellsList;
  }

}