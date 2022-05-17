import 'dart:async';
import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sabertech_proctor/data/agent_project_data.dart';
import 'package:sabertech_proctor/models/agent_project_data.dart';
import 'package:sabertech_proctor/models/project_timeline_view.dart';
import 'package:sabertech_proctor/screens/agent_view/agent_project_timeline.dart';
import 'package:sabertech_proctor/utils/authentication.dart';

class LiveProjectAgentList extends StatefulWidget {
  const LiveProjectAgentList({required Key key, required this.projectId}) : super(key: key);
  final String projectId;
  @override
    _UserInformationState createState() => _UserInformationState();
}

class _UserInformationState extends State<LiveProjectAgentList> {
  
  Widget buildStream(documents) {
    final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance.collection('user-online').where('project_id', isEqualTo: widget.projectId).snapshots();
    Timer.periodic(const Duration(hours: 0, minutes: 1, seconds: 0), (Timer t) => setState((){}));
    return StreamBuilder<QuerySnapshot>(
                stream: _usersStream,
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Text("Loading");
                  }
                  return buildDataTable(
                    snapshot.data!.docs,
                    documents
                  );
                },
              );
  }

  Widget buildDataTable(List<QueryDocumentSnapshot> userStream, List<AgentProjectMap> userList){
    print("dataTable");
    List<String> columns = ['projectId', 'Email', 'Online Status', 'Status'];
    Map<String, bool> userStatusMap = {};
    bool userOnline = false;
    userStream.forEach((document){
      print("inside map");
      var userStream = document.data()! as Map<String, dynamic>;
      var timeStamp = userStream['time_stamp'] as Timestamp;
      var currentTimeStamp = DateTime.now().millisecondsSinceEpoch;
      var userOnlineStatus;
      if(currentTimeStamp - timeStamp.millisecondsSinceEpoch > 60000){
        userOnline = false;
        userOnlineStatus = Container(
                              width: 5,
                              height: 5,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.red,
                              ),
                            );
      } else{
        userOnline = true;
        userOnlineStatus = Container(
                              width: 5,
                              height: 5,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.red,
                              ),
                            );
      }
      userStatusMap[userStream['user_email']!] = userOnline;
    });
    return DataTable(
      columns: getColumns(columns),
      rows: getRows(userStatusMap, userList),
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

  List<DataRow> getRows(Map<String, bool> userStatusMap, List<AgentProjectMap> agentMap){
    List<DataRow> dataRow = [];
    var indexR = 0;
    agentMap.forEach((agentProjectData) {
      var cells = [agentProjectData.projectId, agentProjectData.supervisorId];
      var userOnline = false;
      if(userStatusMap.containsKey(agentProjectData.agentEmail)){
        userOnline = userStatusMap[agentProjectData.agentEmail]!;
      }
      dataRow.add(DataRow(selected: indexR % 2 == 0 ? true : false, cells: getCells(cells, userOnline, agentProjectData.agentEmail)));
    });
    return dataRow;
  }

  List<DataCell> getCells(List<dynamic> cells, bool userOnline, String userEmail) {
    var cellsList = cells.map(
        (data) => DataCell(Text('$data'))
      ).toList();
    if (userOnline){
      cellsList.add(
        DataCell(Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.green,
          ),
        )));
    } else{
      cellsList.add(
        DataCell(Container(
          width: 10,
          height: 10,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.red,
          ),
        )));
    }
    cellsList.add(
      DataCell(
        ElevatedButton(
        style: ElevatedButton.styleFrom(
                primary: userOnline ? Colors.green : Colors.red,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                textStyle: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold)),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
                  builder: (context)=> AgentProjectTimelineScreen(key: UniqueKey(), agentEmail: userEmail, projectId: widget.projectId))
          );
          // showDialog(
          //   context: context,
          //   builder: (context) {
          //     return Dialog(
          //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          //       elevation: 16,
          //       child: Container(
          //         width: 500,
          //         child: SingleChildScrollView(
          //           child: ListView(
          //             shrinkWrap: true,
          //             children: <Widget>[
          //               SizedBox(height: 20),
          //               Center(
          //                 child: Text(
          //                   'Last 10 Mins details', 
          //                   style: TextStyle(
          //                     fontSize: 20,
          //                     fontWeight: FontWeight.bold
          //                   ),
          //                 ),
          //               ),
          //               SizedBox(height: 10),
          //               Center(child:Text('User email: ${userEmail}')),
          //               SizedBox(height: 20),
          //               buildDataTableDialog(userEmail),
          //             ],
          //           ),
          //         )
          //       ),
          //     );
          //   },
          // );
        },
        child: Text('Show Detail'),
      ),
    ));
    // cellsList.add(
    //   DataCell(
    //     ElevatedButton(
    //     style: ElevatedButton.styleFrom(
    //             primary: userOnline ? Colors.green : Colors.red,
    //             padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
    //             textStyle: TextStyle(
    //             fontSize: 10,
    //             fontWeight: FontWeight.bold)),
    //     onPressed: () async {
    //       await showDialog(
    //         context: context,
    //         builder: (context) {
    //           return Dialog(
    //             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    //             elevation: 16,
    //             child: Container(
    //               width: 500,
    //               child: SingleChildScrollView(
    //                 child: ListView(
    //                   shrinkWrap: true,
    //                   children: <Widget>[
    //                     SizedBox(height: 20),
    //                     Center(
    //                       child: Text(
    //                         'Overall details', 
    //                         style: TextStyle(
    //                           fontSize: 20,
    //                           fontWeight: FontWeight.bold
    //                         ),
    //                       ),
    //                     ),
    //                     SizedBox(height: 10),
    //                     Center(child:Text('User Mobile: ${userEmail}')),
    //                     SizedBox(height: 20),
    //                     buildDataTableDialog(userEmail),
    //                   ],
    //                 ),
    //               )
    //             ),
    //           );
    //         },
    //       );
    //     },
    //     child: Text('Show Detail'),
    //   ),
    // ));
    return cellsList;
  }
  List<DataCell> getCellsDialog(List<dynamic> cells) {
    return cells.map(
        (data) => DataCell(Text('$data'))
      ).toList();
    }
  List<DataRow> getRowsDialog(TimelineView timelineView){
    print("cells XXXXXXXXXXXXXs");
    print(timelineView.userId);
    var data = [['google.com', '10%', '1min'],
            ['facebook.com', '20%', '2min'],
            ['meet.com', '20%', '2min'],
            ['proctor.com', '20%', '2min'],
            ['youtube.com', '30%', '3min']];
    List<DataRow> dataRow = [];
    var index = 0;
   data.forEach((e) => {
      index += 1,
      dataRow.add(DataRow(selected: index % 2 == 0 ? true : false, cells: getCellsDialog(e)))
    });
    return dataRow;
  }

  Widget buildDataTableDialog(String agentEmail) {
    return FutureBuilder(
        future: getLast10MinsData(agentEmail, widget.projectId),
        builder: (context, snapshot) {
          if(snapshot.hasData){
            List<String> columns = ['Url', 'Percentage Spent', 'Time Spend'];
          return DataTable(
            columns: getColumns(columns),
            rows: getRowsDialog(snapshot.data! as TimelineView),
            showBottomBorder: true,
            headingRowColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 207, 222, 225)),
          );
          }
          else{
            return Text("Loading data");  
          }
        },
      );
  }

  Widget _buildRow(String imageAsset, String name, String score) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20.0),
    child: Column(
      children: <Widget>[
        SizedBox(height: 12),
        Container(height: 2, color: Colors.redAccent),
        SizedBox(height: 12),
        Row(
          children: <Widget>[
            // CircleAvatar(backgroundImage: AssetImage(imageAsset)),
            Text(imageAsset),
            SizedBox(width: 50),
            Text(name),
            Spacer(),
            Text(name),
          ],
        ),
      ],
    ),
  );
}


  @override
  Widget build(BuildContext context) {
    TabBar _tabBar = TabBar(
                onTap: (index) {
                // Tab index when user select it, it start from zero
                },
                tabs: [
                  Tab(icon: const Text("Project Users", style: TextStyle(color: Color.fromARGB(255, 9, 73, 100)),)),
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
                )
            ),
            title: Text('Users Status', style: TextStyle(fontWeight: FontWeight.w400), ),
            backgroundColor: Colors.lightBlue,
          ),
          body: TabBarView(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: FutureBuilder(
                  future: getUsersForProject(widget.projectId),
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
                      return buildStream(snapshot.data);
                    }
                    else{
                      return Text("Loading data");
                        }
                      }
                  ),
              ),
            ],
          ),
        )
      );
  }
}