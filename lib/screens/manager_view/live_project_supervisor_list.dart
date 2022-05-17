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
    List<String> columns = ['Project Id', 'Email', 'Timestamp', 'Online Status', 'Last 10 mins status', 'Overall Project status'];
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

  List<DataRow> getRows(List<QueryDocumentSnapshot> users) => users.map((DocumentSnapshot document) {
    var user = document.data()! as Map<String, dynamic>;
    var timeStamp = user['time_stamp'] as Timestamp;
    var currentTimeStamp = DateTime.now().millisecondsSinceEpoch;
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

  //convert the below logic to status of agents under him {TODO}
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
                  builder: (context)=> UserInformation())
          );
        },
        child: Text('Show Details'),
      ),
    ));
    return cellsList;
  }
  List<DataCell> getCellsDialog(List<dynamic> cells) {
    return cells.map(
        (data) => DataCell(Text('$data'))
      ).toList();
    }
  List<DataRow> getRowsDialogShort(){
    // print(cells);
    var index = 0;
    var data = [['google.com', '10%', '1min'],
            ['facebook.com', '20%', '2min'],
            ['meet.com', '20%', '2min'],
            ['proctor.com', '20%', '2min'],
            ['youtube.com', '30%', '3min']];
    List<DataRow> dataRow = [];
   data.forEach((e) => {
     index += 1,
      dataRow.add(DataRow( selected: index % 2 == 0 ? true : false, cells: getCellsDialog(e)))
    });
    return dataRow;
  }

  List<DataRow> getRowsDialogOverall(){
    // print(cells);
    var index = 0;
    var data = [['google.com', '10%', '1min'],
            ['facebook.com', '20%', '2min'],
            ['meet.com', '20%', '2min'],
            ['proctor.com', '20%', '2min'],
            ['youtube.com', '30%', '3min']];
    List<DataRow> dataRow = [];
   data.forEach((e) => {
     index += 1,
      dataRow.add(DataRow( selected: index % 2 == 0 ? true : false, cells: getCellsDialog(e)))
    });
    return dataRow;
  }

  Widget buildDataTableDialog() {
    List<String> columns = ['Url', 'Percentage Spent', 'Time Spend'];
    return DataTable(
      columns: getColumns(columns),
      rows: getRowsDialogShort(),
      showBottomBorder: true,
      headingRowColor: MaterialStateProperty.all<Color>(Color.fromARGB(255, 207, 222, 225)),
    );
  }

  Widget buildDataTableDialogOverall() {
    List<String> columns = ['Url', 'Percentage Spent', 'Time Spend'];
    return DataTable(
      columns: getColumns(columns),
      rows: getRowsDialogOverall(),
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