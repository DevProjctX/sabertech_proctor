
import 'package:flutter/material.dart';
import 'package:sabertech_proctor/models/agent_project_data.dart';
import 'package:sabertech_proctor/models/project.dart';
import 'package:sabertech_proctor/models/users.dart';
import 'package:sabertech_proctor/screens/project_agent_list.dart';
import 'package:sabertech_proctor/screens/supervisor_view/supervisor_project_agent_list.dart';
import 'package:sabertech_proctor/utils/authentication.dart';

import '../../constants.dart';
import '../../data/agent_project_data.dart';

class ProjectAgentDetailSupView extends StatefulWidget {
  ProjectAgentDetailSupView({required Key key, required this.projectId, required this.agentProjectMap}) : super(key: key);
  final String projectId;
  final AgentProjectMap agentProjectMap;

  @override
  _ProjectDetailsState createState() => _ProjectDetailsState();
}

class _ProjectDetailsState extends State<ProjectAgentDetailSupView> {
  String meetLink = "";
  String agentLoginId = "";
  String agentLoginCode = "";
  @override
  Widget build(BuildContext context) {
    meetLink = widget.agentProjectMap.googleMeetLink ?? "";
    agentLoginId = widget.agentProjectMap.agentLoginId ?? "";
    agentLoginCode = widget.agentProjectMap.agentLoginCode ?? "";
  return Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.min,
        // mainAxisAlignment: MainAxisAlignment.center,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          FutureBuilder(
            future: Future.wait([getProjectById(widget.projectId), getUserDetailsByUid(widget.agentProjectMap.supervisorId ?? "")]),
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
                print("snapshot details");
                print(snapshot);
                return buildDataTable(snapshot);
              }
              else{
                return Text("Loading data");
              }
            }
          ),
          // SizedBox(
          //   height: 40,
          // ),
          ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Colors.blue),
              child: Text("Save"),
              onPressed: () =>{
                    updateAgentProjectDetails(widget.projectId, widget.agentProjectMap, meetLink, agentLoginCode, agentLoginId),
                    Navigator.of(context).pop()
              },
            )
        ]
    );
  }

  Widget buildDataTable(userData) {
    final columns = ['Project Property', 'Details'];
    return DataTable(
      columns: getColumns(columns),
      rows: getRows(userData.data[0], userData.data[1]),
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

  List<DataRow> getRows(Project project, User supervisorDetails){
    final rows = [
      ["Project Name", project.projectName],
      ["Project Description", project.projectDetails],
      ["Project Start Time", project.projectStartTime],
      ["Supervisor Contact", supervisorDetails.mobileNumber],
      ["Supervisor Name", supervisorDetails.name]
    ];
    final editableRows = [
      [googleMeetText, widget.agentProjectMap.googleMeetLink],
      [agentLoginIdText, widget.agentProjectMap.agentLoginId],
      [agentLoginCodeText, widget.agentProjectMap.agentLoginCode],
    ];

    List<DataRow> dataRows = [];
    rows.forEach((element) {
      dataRows.add(DataRow(cells:getCells(element)));
    });
    editableRows.forEach((element) {
      dataRows.add(DataRow(cells:getEditableCells(element)));
    });
    return dataRows;
  }

  List<DataCell> getCells(List<dynamic> cells) {
    var cellsList = cells.map(
        (data) => DataCell(Text('$data'))
      ).toList();
    return cellsList;
  }

  List<DataCell> getEditableCells(List<dynamic> cells) {
    var cellsList = <DataCell>[];
    cellsList.add(DataCell(Text('${cells.first}')));
    cellsList.add(DataCell(
      TextFormField(
        initialValue: cells[1], 
        keyboardType: TextInputType.text,
        // onFieldSubmitted: (val){
        //   print('onSubmited $val');
        // },
        onChanged: (val){
          print(cells.first);
          print("$val");
            if(cells.first == googleMeetText){
              meetLink = val;
              print(meetLink);
            } else if(cells.first == agentLoginCodeText){
              agentLoginId = val;
              print(agentLoginId);
            }else if(cells.first == agentLoginIdText){
              agentLoginCode = val;
              print(agentLoginCode);
            }
          },
        ),
          showEditIcon: true
    ));
    return cellsList;
  }

}