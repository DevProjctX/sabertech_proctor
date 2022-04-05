import 'package:flutter/material.dart';
import 'package:sabertech_proctor/data/agent_project_data.dart';
import 'package:sabertech_proctor/models/agent_project_data.dart';
import 'package:sabertech_proctor/models/agent_project_view.dart';
import 'package:sabertech_proctor/screens/supervisor_view/agent_project_details.dart';

import '../../constants.dart';

class ProjectAgentListSupView extends StatefulWidget {

  final String id;

  const ProjectAgentListSupView({required Key key, required this.id}) : super(key: key);
  @override
  _ProjectAgentListSupViewState createState() => _ProjectAgentListSupViewState();
}

class _ProjectAgentListSupViewState extends State<ProjectAgentListSupView> {
  var projectAgentMap;
  @override
  Widget build(BuildContext context) {
    print("ProjectAgentListSupView");
    return FutureBuilder(
          future: getUsersForProjectForSup(widget.id),
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
        );
  }
              
  Widget buildDataTable(userData) {
    final columns = ['agentId', 'emailId', 'Status', 'Edit Details'];
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
        return DataRow(cells: getCells(cells, user.agentId, user));
      }).toList();

  List<DataCell> getCells(List<dynamic> cells, String agentId, AgentProjectMap agentProjectMap) {
    var cellsList = cells.map(
        (data) => DataCell(Text('$data'))
      ).toList();
    final ButtonStyle style = ElevatedButton.styleFrom(primary: Colors.lightGreen);
    cellsList.add(
      DataCell(
        Row(
          children: [
            ElevatedButton(
              style: style,
              child: Text("Edit Details"),
              onPressed: () =>{
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context)=> ProjectAgentDetailSupView(key:UniqueKey(), projectId: widget.id, agentProjectMap: agentProjectMap)
                      )
                    )
              },
            ),
          ],
        )
      )
    );
    return cellsList;
  }

}