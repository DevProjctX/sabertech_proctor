import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sabertech_proctor/constants.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:sabertech_proctor/models/users.dart' as firestore_user;
import 'package:sabertech_proctor/utils/authentication.dart';
import 'package:flutter/material.dart';

class UserPage extends StatefulWidget {
  @override
  _SortablePageState createState() => _SortablePageState();
}

class _SortablePageState extends State<UserPage> {
  late List<firestore_user.User> users;
  int? sortColumnIndex;
  bool isAscending = false;

  @override
  initState() {
    super.initState();
  }

  final userRef = FirebaseFirestore.instance.collection('users').withConverter<firestore_user.User>(
      fromFirestore: (snapshot, _) => firestore_user.User.fromJson(snapshot.data()!),
      toFirestore: (user, _) => user.toJson(),
    );
    Future<List<firestore_user.User>> getUsers() async {
      userRole = await getUserRole(uid);
      List<firestore_user.User> dataDocs = [];
      (await userRef.limit(10).get()
        .then((snapshot) => snapshot.docs.forEach((userDoc) => {
          // print(projectDoc.data());
          dataDocs.add(userDoc.data())
        })));
      return dataDocs;
    }

  TabBar _tabBar = TabBar(
                onTap: (index) {
                // Tab index when user select it, it start from zero
                },
                tabs: [
                  Tab(icon: const Text("Users", style: TextStyle(color: Color.fromARGB(255, 9, 73, 100)),)),
                ],
                );
  @override
  Widget build(BuildContext context) => DefaultTabController(
  length: 1,
  child: Scaffold(
          appBar: AppBar(
            bottom: PreferredSize(
              preferredSize: _tabBar.preferredSize,
              child: ColoredBox(
                color: Colors.white,
                child: _tabBar,
                )),
            title: Text('User Details', style: TextStyle(fontWeight: FontWeight.w400), ),
            // backgroundColor: Color.fromARGB(255, 204, 240, 237),
          ),
          body: FutureBuilder(
            future: getUserRole(uid),
            builder: (BuildContext context, snapshot){
              // print("userRole user_page:$userRole");
              // print("snapshot data user_page:${snapshot.data}");
              if(userRole == 'admin' && snapshot.hasData){
                return TabBarView(
                  children: [
                    FutureBuilder(
                      future: getUsers(),
                      builder: (BuildContext context, snapshot){
                        if(snapshot.hasData){
                          return buildDataTable(snapshot.data as List<firestore_user.User>);
                        } else{
                          return Text("Loading data");
                        }
                      },
                    )
                  ],
                );
              } else {return const Text("Not authorised");}
            },
          )
        ));

  Widget buildDataTable(List<firestore_user.User> userData) {
    List<String> columns = [];
    if(userRole == admin){
      columns = ['Name', 'Mobile', 'Role', 'Select role'];
    } else if(userRole == supervisor){
      columns = ['Name', 'Email', 'Role'];
    }
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
  List<DataRow> getRows(List<firestore_user.User> users) => users.map((firestore_user.User user) {
        final cells = [user.name, user.mobileNumber, user.userRole];
        index += 1;
        return DataRow(selected: index % 2 == 0 ? true : false, cells: getCells(cells, user));
      }).toList();

  List<DataCell> getCells(List<dynamic> cells, firestore_user.User user) {
    var cellsList = cells.map(
        (data) => DataCell(Text('$data'))
      ).toList();
    if(userRole == admin){
      cellsList.add(
        DataCell(DropdownButton<String>(
          value: user.userRole,
          onChanged: (String? newRole) {
            print("changing roles to $newRole");
            setState(() {
              changeUserRole(newRole?? 'agent', user.userId);
            });
          },
          items: firestore_user.User.userRolesList.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ))
      );
    }
    return cellsList;
  }

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