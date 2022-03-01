

import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sabertech_proctor/models/user_project_timeline.dart';
import 'package:sabertech_proctor/utils/authentication.dart';

class ControlUserProjectTimeline extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
      // Create a CollectionReference called users that references the firestore collection
      // final timelineRef = FirebaseFirestore.instance.collection('db-test1'); 
      final projectRef = FirebaseFirestore.instance.collection('db-test1').withConverter<UserProjectTimeline>(
        fromFirestore: (snapshot, _) => UserProjectTimeline.fromJson(snapshot.data()!),
        toFirestore: (project, _) => project.toJson(),
      );
      // Future<List<UserProjectTimeline>> getUserProjectTimeline(userEmail) async {
      //   List<UserProjectTimeline> dataDocs = [];
      //   print("dataDocs1, $dataDocs");
      //   await projectRef.limit(1).get()
      //     .then((snapshot) => snapshot.docs.forEach((projectDoc) => {
      //       dataDocs.add(projectDoc.data())
      //       // print(projectDoc.data())
      //     }));
      //   print("dataDocs2, $dataDocs");
      //   return dataDocs;
      // }

      // DocumentSnapshot<Map<String, dynamic>> getUserProjectTime(userEmail) {
      //   print("dataDocs3");
      //   return timelineRef.doc('2aRQQXunzlzIJXsZpqls').get()
      //     // .then((snapshot) => dataDocs = snapshot.data());
      //   // print("dataDocs4, $dataDocs");
      //   // return dataDocs;
      // }

      List<DataColumn> getColumns(List<String> columns) => columns
        .map((String column) => DataColumn(
              label: Text(column),
              // onSort: onSort,
            ))
        .toList();

      // void pushUserProjectTimeline(args) {
        
      // }


      List<DataCell> getCells(List<dynamic> cells) =>
          cells.map((data) => DataCell(Text('$data'))).toList();

        List<DataRow> getRows(List<UserProjectTimeline> project) => project.map(
          (UserProjectTimeline doc) {
            final cells = [doc.tabs, doc.timeStamp, doc.userEmailId];
            // final projectDummy = getUserProjectTimeline(userEmail);
            return DataRow(cells: getCells(cells));
          }).toList();

      Widget buildDataTable(projectData) {
        final columns = ['Tabs', 'timestamp', 'emailId'];
        return DataTable(
          columns: getColumns(columns),
          rows: getRows(projectData)
        );
      }

      return Scaffold(
        body: FutureBuilder(
          future: projectRef.doc('2aRQQXunzlzIJXsZpqls').get(),
          builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot){
            if (snapshot.hasError) {
              return Text("Something went wrong");
            }

            if (snapshot.hasData && !snapshot.data!.exists) {
              return Text("Document does not exist");
            }

            if (snapshot.connectionState == ConnectionState.done) {
              UserProjectTimeline data = snapshot.data!.data() as UserProjectTimeline;
              final tabsUrl = [];
              data.tabs.forEach((element) { 
                tabsUrl.add(element.url);
              });
              return Text("DATA: ${tabsUrl}");
            }

            return Text("loading");
          }      
        ),
      );

      // return Scaffold(
      //   body: FutureBuilder(
      //         future: getUserProjectTimeline(userEmail),
      //         builder: (BuildContext context, snapshot){
      //           if(snapshot.hasData){
      //             return buildDataTable(snapshot.data);
      //           } else{
      //             return Text("Loading data");
      //           }
      //         },
      //     ),
      //   );
  }
}
