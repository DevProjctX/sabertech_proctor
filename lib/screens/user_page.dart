import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:sabertech_proctor/models/users.dart';
import 'package:sabertech_proctor/widgets/scrollable_widget.dart';
import 'package:flutter/material.dart';

class SortablePage extends StatefulWidget {
  @override
  _SortablePageState createState() => _SortablePageState();
}

class _SortablePageState extends State<SortablePage> {
  late List<User> users;
  int? sortColumnIndex;
  bool isAscending = false;

  @override
  void initState() {
    super.initState();
  }

  final userRef = FirebaseFirestore.instance.collection('users').withConverter<User>(
      fromFirestore: (snapshot, _) => User.fromJson(snapshot.data()!),
      toFirestore: (user, _) => user.toJson(),
    );
    Future<List<User>> getUsers() async {
      List<User> dataDocs = [];
      (await userRef.limit(10).get()
        .then((snapshot) => snapshot.docs.forEach((userDoc) => {
          // print(projectDoc.data());
          dataDocs.add(userDoc.data())
        })));
      return dataDocs;
    }

  @override
  Widget build(BuildContext context) => DefaultTabController(
  length: 2,
  child: MaterialApp(
    home: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              onTap: (index) {
              // Tab index when user select it, it start from zero
              },
              tabs: [
                Tab(icon: const Text("Upcoming Project")),
                Tab(icon: const Text("Completed Project")),
              ],
            ),
            title: Text('Project Tabs'),
          ),
          body: TabBarView(
            children: [
              FutureBuilder(
                future: getUsers(),
                builder: (BuildContext context, snapshot){
                  if(snapshot.hasData){
                    print(snapshot);
                    return buildDataTable(snapshot.data as List<User>);
                  } else{
                    return Text("Loading data");
                  }
                },
              ),
              FutureBuilder(
                future: getUsers(),
                builder: (BuildContext context, snapshot){
                  if(snapshot.hasData){
                    return buildDataTable(snapshot.data as List<User>);
                  } else{
                    return Text("Loading data");
                  }
                },
              ),
            ],
          ),
        )));

  Widget buildDataTable(List<User> userData) {
    final columns = ['name', 'emailId', 'Age'];
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

  List<DataRow> getRows(List<User> users) => users.map((User user) {
        final cells = [user.name, user.emailId, user.userRole];

        return DataRow(cells: getCells(cells));
      }).toList();

  List<DataCell> getCells(List<dynamic> cells) =>
      cells.map((data) => DataCell(Text('$data'))).toList();

  // void onSort(int columnIndex, bool ascending) {
  //   if (columnIndex == 0) {
  //     users.sort((user1, user2) =>
  //         compareString(ascending, user1.firstName, user2.firstName));
  //   } else if (columnIndex == 1) {
  //     users.sort((user1, user2) =>
  //         compareString(ascending, user1.lastName, user2.lastName));
  //   } else if (columnIndex == 2) {
  //     users.sort((user1, user2) =>
  //         compareString(ascending, '${user1.age}', '${user2.age}'));
  //   }

  //   setState(() {
  //     this.sortColumnIndex = columnIndex;
  //     this.isAscending = ascending;
  //   });
  // }

  int compareString(bool ascending, String value1, String value2) =>
      ascending ? value1.compareTo(value2) : value2.compareTo(value1);
}