import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sabertech_proctor/data/projects.dart';
import 'package:sabertech_proctor/models/project.dart';

class AgentStatus extends StatelessWidget {

  final List<String> elements = [
    "Zero",
    "One",
    "Two",
    "Three",
    "Four",
    "Five",
    "Six",
    "Seven",
    "Eight",
    "A Million Billion Trillion",
    "A much, much longer text that will still fit"
  ];


  @override
  Widget build(context) =>
      Scaffold(
          body: Container(
              height: MediaQuery.of(context).size.height*0.3,
              width: MediaQuery.of(context).size.width*0.2,
                    //height: 300,
                    child: GridView.count(
              //maxCrossAxisExtent: 50.0,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        //crossAxisSpacing: 10.0,
                        //mainAxisSpacing: 10.0,
                        crossAxisCount: 5,
                        children: elements.map((el) =>
                          Card(
                              child: InkWell(
                                  splashColor: Colors.blue.withAlpha(30),
                                  onTap: () {
                                    debugPrint('Card tapped.');
                                  },
                                  child: const SizedBox(
                                    width: 10,
                                    height: 10,
                                    child: Text('Red'),
                                  ),
                              )
                          )
                      ).toList()
                    )
                )
      );
}

  /*
  @override
  Widget build(BuildContext context) {
    // Create a CollectionReference called users that references the firestore collection
    final projectRef = FirebaseFirestore.instance.collection('projects').withConverter<Project>(
      fromFirestore: (snapshot, _) => Project.fromJson(snapshot.data()!),
      toFirestore: (project, _) => project.toJson(),
    );
    Future<List<Project>> getProject() async {
      List<Project> dataDocs = [];
      (await projectRef.limit(10).get()
          .then((snapshot) =>
          snapshot.docs.forEach((projectDoc) =>
          {
            // print(projectDoc.data());
            dataDocs.add(projectDoc.data())
          })));
      return dataDocs;
    }

    List<DataColumn> getColumns(List<String> columns) => columns
        .map((String column) => DataColumn(
      label: Text(column),
      // onSort: onSort,
    ))
        .toList();


    List<DataCell> getCells(List<dynamic> cells) =>
        cells.map((data) => DataCell(Text('$data'))).toList();

    List<DataRow> getRows(List<Project> project) => project.map(
            (Project project) {
          final cells = [project.projectName, project.status, project.duration];
          final projectDummy = getProject();
          return DataRow(cells: getCells(cells));
        }).toList();

    Widget buildDataTable(projectData) {
      final columns = ['Project Name', 'Status', 'Duration'];
      return DataTable(
          columns: getColumns(columns),
          rows: getRows(projectData)
      );
    }
    void _onTileClicked(int index){
      debugPrint("You tapped on item $index");
    }

    // Get grid tiles
    List<Widget> _getTiles(List<File> iconList) {
      final List<Widget> tiles = <Widget>[];
      for (int i = 0; i < iconList.length; i++) {
        tiles.add( new GridTile(
            child: new InkResponse(
              enableFeedback: true,
              child: new Image.file(iconList[i], fit: BoxFit.cover,),
              onTap: () => _onTileClicked(i),
            )));
      }
      return tiles;
    }


    // GridView
    new GridView.count(
      crossAxisCount: 4,
      childAspectRatio: 1.0,
      padding: const EdgeInsets.all(4.0),
      mainAxisSpacing: 4.0,
      crossAxisSpacing: 4.0,
      children: _getTiles(_imageList),
    )

    return DefaultTabController(
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
                    future: getProject(),
                    builder: (BuildContext context, snapshot){
                      if(snapshot.hasData){
                        return buildDataTable(snapshot.data);
                      } else{
                        return Text("Loading data");
                      }
                    },
                  ),
                  FutureBuilder(
                    future: getProject(),
                    builder: (BuildContext context, snapshot){
                      if(snapshot.hasData){
                        return buildDataTable(snapshot.data);
                      } else{
                        return Text("Loading data");
                      }
                    },
                  ),
                ],
              ),
            )));
  }
} */