import 'package:flutter/material.dart';

DefaultTabController(
  length: 2,
  child: MaterialApp(
    home: Scaffold(
      appBar: AppBar(
        bottom: TabBar(
          onTap: (index) {
           // Tab index when user select it, it start from zero
          },
          tabs: [
            Tab(icon: Icon(Icons.card_travel)),
            Tab(icon: Icon(Icons.add_shopping_cart)),
          ],
        ),
        title: Text('Tabs Demo'),
      ),
      body: TabBarView(
        children: [
          Center(
              child: Text(
            "0",
            style: TextStyle(fontSize: 40),
          )),
          Center(
              child: Text(
            "1",
            style: TextStyle(fontSize: 40),
          )),
        ],
      ),
    ),
  ),
);