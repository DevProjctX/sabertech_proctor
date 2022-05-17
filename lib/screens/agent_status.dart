import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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