import 'dart:async';
import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sabertech_proctor/data/agent_project_data.dart';

class UserInformation extends StatefulWidget {
  @override
    _UserInformationState createState() => _UserInformationState();
}

class _UserInformationState extends State<UserInformation> {
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance.collection('user-online').snapshots();

  Widget buildDataTable(List<QueryDocumentSnapshot> documents) {
    List<String> columns = ['projectId', 'Email', 'Online Status', 'Last 10 mins status', 'Overall Status'];
    Timer.periodic(const Duration(hours: 0, minutes: 1, seconds: 0), (Timer t) => setState((){}));
    return DataTable(
      columns: getColumns(columns),
      rows: getRows(documents),
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
  var indexR = 0;
  List<DataRow> getRows(List<QueryDocumentSnapshot> users) => users.map((DocumentSnapshot document) {
    var user = document.data()! as Map<String, dynamic>;
    var timeStamp = user['time_stamp'] as Timestamp;
    var currentTimeStamp = DateTime.now().millisecondsSinceEpoch;
    print(document.data());
    bool userOnline = false;
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
    final cells = [user['project_id'], user['user_email']];
    indexR += 1;
    return DataRow(selected: indexR % 2 == 0 ? true : false, cells: getCells(cells, userOnline, user['user_email']));
  }).toList();

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
          showDialog(
            context: context,
            builder: (context) {
              return Dialog(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                elevation: 16,
                child: Container(
                  width: 500,
                  child: SingleChildScrollView(
                    child: ListView(
                      shrinkWrap: true,
                      children: <Widget>[
                        SizedBox(height: 20),
                        Center(
                          child: Text(
                            'Last 10 Mins details', 
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Center(child:Text('User email: ${userEmail}')),
                        SizedBox(height: 20),
                        buildDataTableDialog(),
                      ],
                    ),
                  )
                ),
              );
            },
          );
        },
        child: Text('Show Detail'),
      ),
    ));
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
          showDialog(
            context: context,
            builder: (context) {
              return Dialog(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                elevation: 16,
                child: Container(
                  width: 500,
                  child: SingleChildScrollView(
                    child: ListView(
                      shrinkWrap: true,
                      children: <Widget>[
                        SizedBox(height: 20),
                        Center(
                          child: Text(
                            'Overall details', 
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Center(child:Text('User Mobile: ${userEmail}')),
                        SizedBox(height: 20),
                        buildDataTableDialog(),
                      ],
                    ),
                  )
                ),
              );
            },
          );
        },
        child: Text('Show Detail'),
      ),
    ));
    // if(userRole == admin){
    //   cellsList.add(
    //     DataCell(DropdownButton<String>(
    //       value: userRole,
    //       onChanged: (String? newRole) {
    //         setState(() {
    //           changeUserRole(newRole?? 'agent');
    //         });
    //       },
    //       items: firestore_user.User.userRolesList.map<DropdownMenuItem<String>>((String value) {
    //         return DropdownMenuItem<String>(
    //           value: value,
    //           child: Text(value),
    //         );
    //       }).toList(),
    //     ))
    //   );
    // }
    // print(cellsList.length);
    return cellsList;
  }
  List<DataCell> getCellsDialog(List<dynamic> cells) {
    return cells.map(
        (data) => DataCell(Text('$data'))
      ).toList();
    }
  List<DataRow> getRowsDialog(){
    // print(cells);
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

  Widget buildDataTableDialog() {
    List<String> columns = ['Url', 'Percentage Spent', 'Time Spend'];
    return DataTable(
      columns: getColumns(columns),
      rows: getRowsDialog(),
      showBottomBorder: true,
      headingRowColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 207, 222, 225)),
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
              // SingleChildScrollView(
              //   scrollDirection: Axis.vertical,
              //   child: FutureBuilder(
              //     future: getUsersForProject(widget.),
              //     builder: (BuildContext context, snapshot){
              //       if (snapshot.hasError) {
              //         print(snapshot.error);
              //         return Text("Something went wrong");
              //       }
              //       if (!snapshot.hasData) {
              //         return Text("No data");
              //       }

              //       if (!snapshot.hasData) {
              //         return Text("Document does not exist");
              //       }
              //       if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
              //         return buildDataTable(snapshot.data);
              //       }
              //       else{
              //         return Text("Loading data");
              //           }
              //         }
              //     ),
              // ),
              SingleChildScrollView(
                child: StreamBuilder<QuerySnapshot>(
                  stream: _usersStream,
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text('Something went wrong');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Text("Loading");
                    }

                    return buildDataTable(
                      snapshot.data!.docs
                    );
                  },
                ))
              ],
          ),
        )
      );
  }
}