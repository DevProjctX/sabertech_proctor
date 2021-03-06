import 'package:flutter/material.dart';
import 'package:sabertech_proctor/data/agent_project_data.dart';
import 'package:sabertech_proctor/models/agent_project_data.dart';

import '../constants.dart';

class AgentProjectApprovalScreen extends StatefulWidget {

  final String id;

  const AgentProjectApprovalScreen({required Key key, required this.id}) : super(key: key);
  @override
  _AgentProjectApprovalScreenState createState() => _AgentProjectApprovalScreenState();
}

class _AgentProjectApprovalScreenState extends State<AgentProjectApprovalScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(

          title: Text('Agent Approval', style: TextStyle( fontWeight: FontWeight.w400), ),
          ),
        body: Row( // a dirty trick to make the DataTable fit width
      children: <Widget>[ 
        Expanded(
          child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: FutureBuilder(
            future: getUsersForProjectApproval(widget.id),
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
          )
        )
      ])
      );
  }
              
  Widget buildDataTable(userData) {
    final columns = ['Agent Id', 'Email', 'Status', 'Approve/Reject'];
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
        index += 1;
        return DataRow(selected: index % 2 == 0 ? true : false, cells: getCells(cells, user.agentId));
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
            SizedBox(width: 10,),
            ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Colors.redAccent),
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