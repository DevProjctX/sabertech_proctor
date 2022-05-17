import 'package:flutter/material.dart';
import 'package:sabertech_proctor/data/agent_project_data.dart';
import 'package:sabertech_proctor/models/agent_project_view.dart';
import 'package:sabertech_proctor/models/project_timeline_view.dart';
import 'package:sabertech_proctor/screens/project_details.dart';
import 'package:sabertech_proctor/utils/authentication.dart';

import '/constants.dart';

class AgentProjectTimelineScreen extends StatefulWidget{
  // var id;
  final String agentEmail;
  final String projectId;
  const AgentProjectTimelineScreen({required Key key, required this.agentEmail, required this.projectId}) : super(key: key);
  @override
  _AgentProjectScreenState createState() => _AgentProjectScreenState();
}
class _AgentProjectScreenState extends State<AgentProjectTimelineScreen> {
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


  List<DataCell> getCells(List<dynamic> cells){
    return cells.map((data) => DataCell(Text('$data'))).toList();
  }

    List<DataRow> getRows(TimelineView timelineView){
      List<DataRow> resultTimeline = [];
      timelineView.percentSpent.forEach((key, element) {
        final cells = [key, element.round()];
        resultTimeline.add(DataRow(cells: getCells(cells)));
      });
      return resultTimeline;
    }

  Widget buildDataTable(projectData) {
    List<String> columns = [];
    if(userRole == admin || userRole == supervisor){
      columns = ['Website', 'Timespent'];
    }
    return DataTable(
      columns: getColumns(columns),
      rows: getRows(projectData),
      showBottomBorder: true,
      headingRowColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 207, 222, 225)),
    );
  }

TabBar _tabBar = TabBar(
                onTap: (index) {
                // Tab index when user select it, it start from zero
                },
                tabs: [
                  Tab(icon: const Text("Agent project timeline", style: TextStyle(color: Color.fromARGB(255, 9, 73, 100)),))
                  // Tab(icon: const Text("Floated Project", style: TextStyle(color: Color.fromARGB(255, 9, 73, 100)),)),
                ],
                );

  return DefaultTabController(
  length: 1,
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
              Row(children: [
                Container(
                  alignment: Alignment.topCenter,
                  width: MediaQuery.of(context).size.width / 2,
                  child:FutureBuilder(
                    future: getLast10MinsData(widget.agentEmail, widget.projectId),
                    builder: (BuildContext context, snapshot){
                      if(snapshot.hasData){
                        return buildDataTable(snapshot.data);
                      } else{
                        return Text("Loading data");
                      }
                    },
                  ),
                ),
              Container(
                  alignment: Alignment.topCenter,
                  width: MediaQuery.of(context).size.width / 2,
                  child: SingleChildScrollView(
                    child:
                    FutureBuilder(
                      future: getOverallTimelineData(widget.agentEmail, widget.projectId),
                      builder: (BuildContext context, snapshot){
                        if(snapshot.hasData){
                          return buildDataTable(snapshot.data);
                        } else{
                          return Text("Loading data");
                        }
                      },
                    )
                  ), 
                ),
              ],)
            ],
          ),
        ));
  }
}
