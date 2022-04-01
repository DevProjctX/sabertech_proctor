import 'package:flutter/material.dart';
import 'package:sabertech_proctor/data/agent_project_data.dart';
import 'package:sabertech_proctor/models/agent_project_data.dart';

import '../constants.dart';

class ProjectAgentListScreen extends StatefulWidget {

  final String id;

  const ProjectAgentListScreen({required Key key, required this.id}) : super(key: key);
  @override
  _ProjectAgentListScreenState createState() => _ProjectAgentListScreenState();
}

class _ProjectAgentListScreenState extends State<ProjectAgentListScreen> {
  @override
  Widget build(BuildContext context) {
    print("ProjectAgentListScreen");
    return FutureBuilder(
          future: getUsersForProject(widget.id),
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
    final columns = ['agentId', 'emailId', 'Status', 'Approve/Reject'];
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
        return DataRow(cells: getCells(cells, user.agentId));
      }).toList();

  List<DataCell> getCells(List<dynamic> cells, String agentId) {
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
              child: Text("Approve"),
              onPressed: () =>{
                    approveAgent(agentId, widget.id),
                    setState(() {})
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Colors.red),
              child: Text("Reject"),
              onPressed: () =>{
                    rejectAgent(agentId, widget.id),
                    setState((){})
              },
            )
          ],
        )
      )
    );
    return cellsList;
  }

}