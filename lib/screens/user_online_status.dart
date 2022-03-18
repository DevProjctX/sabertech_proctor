import 'dart:async';
import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserInformation extends StatefulWidget {
  @override
    _UserInformationState createState() => _UserInformationState();
}

class _UserInformationState extends State<UserInformation> {
  final Stream<QuerySnapshot> _usersStream = FirebaseFirestore.instance.collection('user-online').snapshots();

  Widget buildDataTable(List<QueryDocumentSnapshot> documents) {
    List<String> columns = ['projectId', 'emailId', 'Timestamp', 'Online Status', 'Last 10 mins status'];
    Timer.periodic(const Duration(hours: 0, minutes: 1, seconds: 0), (Timer t) => setState((){}));
    return DataTable(
      columns: getColumns(columns),
      rows: getRows(documents)
    );
  }

  List<DataColumn> getColumns(List<String> columns) => columns
      .map((String column) => DataColumn(
            label: Text(column),
            // onSort: onSort,
          ))
      .toList();

  List<DataRow> getRows(List<QueryDocumentSnapshot> users) => users.map((DocumentSnapshot document) {
    var user = document.data()! as Map<String, dynamic>;
    var timeStamp = user['time_stamp'] as Timestamp;
    var currentTimeStamp = DateTime.now().millisecondsSinceEpoch;
    print(currentTimeStamp);
    print(timeStamp.millisecondsSinceEpoch);
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
    final cells = [user['project_id'], user['user_email'], timeStamp.toString()];
    // print(cells);
    return DataRow(cells: getCells(cells, userOnline, user['user_email']));
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
   data.forEach((e) => {
      dataRow.add(DataRow(cells: getCellsDialog(e)))
    });
    return dataRow;
  }

  Widget buildDataTableDialog() {
    List<String> columns = ['Url', 'Percentage Spent', 'Time Spend'];
    return DataTable(
      columns: getColumns(columns),
      rows: getRowsDialog()
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
            // Container(
            //   decoration: BoxDecoration(color: Colors.yellow[900], borderRadius: BorderRadius.circular(20)),
            //   padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
            //   child: Text('$score'),
            // ),
          ],
        ),
      ],
    ),
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Agents Project Data'),
        ),
        body: StreamBuilder<QuerySnapshot>(
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
              // .map((DocumentSnapshot document) {
              // Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                // return buildDataTable(
                //   data
                //   // trailing: Text(data['project_id']),
                // );
            );
          },
        )
    );
  }
}