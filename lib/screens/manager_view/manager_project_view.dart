
import 'package:flutter/material.dart';
import 'package:sabertech_proctor/data/agent_project_data.dart';
import 'package:sabertech_proctor/models/agent_project_data.dart';
import 'package:sabertech_proctor/models/project.dart';
import 'package:sabertech_proctor/screens/agent_project_approval.dart';
import 'package:sabertech_proctor/screens/projects_data.dart';
import 'package:sabertech_proctor/utils/authentication.dart';

import '../../constants.dart';


class ProjectDetailsScreen extends StatefulWidget {

  final String id;
  const ProjectDetailsScreen({required Key key, required this.id}) : super(key: key);
  @override
  _ProjectDetailsScreenState createState() => _ProjectDetailsScreenState();
}


class _ProjectDetailsScreenState extends State<ProjectDetailsScreen> {
  @override
  Widget build(BuildContext context) {
  List<DataColumn> getColumns(List<String> columns) => columns
    .map((String column) => DataColumn(
          label: Text(column),
        ))
    .toList();
  return Scaffold(
          appBar: AppBar(
            title: Text('Project Details Page'),
          ),
          body: Column(
            children: [
              FutureBuilder(
                  future: getUsersForProject(widget.id),
                  builder: (BuildContext context, snapshot){
                    if (snapshot.hasError) {
                      return Text("Something went wrong");
                    }
                    if (!snapshot.hasData) {
                      return Text("No data");
                    }

                    if (!snapshot.hasData) {
                      return Text("Document does not exist");
                    }
                    if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                      return buildDataTableUsers(snapshot.data);
                    }
                    else{
                      return Text("Loading data");
                    }
                  }
              ),
            ],
          )
        );
  }

  Widget buildDataTableUsers(userData) {
    final columns = ['Agent Id', 'Email', 'Status', 'View Agent'];
    return DataTable(
      columns: getColumns(columns),
      rows: getRows(userData),
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
  
  var index = 0;

  List<DataRow> getRows(List<AgentProjectMap> agents) => agents.map((AgentProjectMap user) {
        final cells = [user.agentId, user.agentEmail, user.agentStatus];
        index+=1;
        return DataRow(selected: index % 2 == 0 ? true : false, cells: getCells(cells, user.agentId));
      }).toList();

  List<DataCell> getCells(List<dynamic> cells, String agentId) {
    var cellsList = cells.map(
        (data) => DataCell(Text('$data'))
      ).toList();
    final ButtonStyle style = ElevatedButton.styleFrom(primary: Colors.blue);
    cellsList.add(
      DataCell(
        Row(
          children: [
            ElevatedButton(
              style: style,
              child: Text("View Agent"),
              onPressed: () =>{
                    approveAgent(agentId, widget.id),
                    setState(() {})
              },
            ),
          ],
        )
      )
    );
    return cellsList;
  }


}
