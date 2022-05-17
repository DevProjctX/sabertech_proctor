import 'dart:convert';
import 'dart:html';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:sabertech_proctor/constants.dart';
import 'package:sabertech_proctor/data/agent_project_data.dart';
import 'package:sabertech_proctor/screens/project_details_agent.dart';
import 'package:sabertech_proctor/screens/manager_view/project_details_manager_view.dart';
import 'package:sabertech_proctor/screens/supervisor_view/supervisor_project_agent_list.dart';
import 'package:sabertech_proctor/screens/supervisor_view/supervisor_project_details.dart';
import 'package:sabertech_proctor/utils/authentication.dart';

class ProjectDetails extends StatefulWidget {
  ProjectDetails({required Key key, required this.projectId}) : super(key: key);
  final String projectId;

  @override
  _ProjectDetailsState createState() => _ProjectDetailsState();
}

class _ProjectDetailsState extends State<ProjectDetails> {
  Uint8List uploadedCsv = new Uint8List(0);
  List<List<String>> uploadedCsvRows = [];
  String option1Text = "";

  _startFilePicker() async {
    FileUploadInputElement uploadInput = FileUploadInputElement();
    uploadInput.click();

    uploadInput.onChange.listen((e){
      // read file content as dataURL
      final files = uploadInput.files;
      if (files?.length == 1) {
        final file = files![0];
        FileReader reader = FileReader();

        reader.onLoadEnd.listen((e) async{
          setState(() {
            uploadedCsv = Base64Decoder()
                .convert(reader.result.toString().split(",").last);
            // print(reader.result.toString().split(",").last);
            // print(utf8.decode(uploadedCsv).split('\n'));
            var csvRows = utf8.decode(uploadedCsv).split('\n');
            csvRows.forEach((element) {
              uploadedCsvRows.add(element.split(',').map((el) => el.trim()).toList());
            });
          });
          var headers = uploadedCsvRows.first;
          var rowLength = headers.length;
          var error = false;
          uploadedCsvRows.forEach((element) {
            if(element.length != rowLength){
              error = true;
            }
          });
          Map<String, String> superVisorAgentMap = {};
          var uploadedBy = userEmail;
          var numCsvRow = uploadedCsvRows.sublist(1);
          numCsvRow.forEach((element){
            superVisorAgentMap[element.first] = element[1];
          });
          await uploadSupAgentMap(superVisorAgentMap, widget.projectId, uploadedBy);  
          
          if(error){
            setState(() {
                option1Text = "File format or data not correct";
              });
          }
        });

        reader.onError.listen((fileEvent) {
          setState(() {
            option1Text = "Some Error occured while reading the file";
          });
        });
        reader.readAsDataUrl(file);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style = ElevatedButton.styleFrom(primary: Colors.blueAccent);
    return Scaffold(
      appBar: AppBar(
        title: Text("Project Details"),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            userRole == agent ? SizedBox(height: 20,):
            Align(
              alignment: Alignment.centerRight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 5,),
                  userRole == admin?
                  ElevatedButton(
                    style: style,
                    child: Text("Upload csv"),
                    onPressed: () =>{
                      _startFilePicker()
                    },
                  ):SizedBox(),
                  Text(option1Text),
                  // uploadedCsv == null
                  //     ? Container()
                  //     : Text(String.fromCharCodes(uploadedCsv)),
                  // uploadedCsv == null
                  //     ? Container()
                  //     : Text(utf8.decode(uploadedCsv)),
                ],
              ),
            ),
            SizedBox(height:20),
            userRole == agent ? ProjectDetailAgent(key: UniqueKey(), projectId: widget.projectId): 
            userRole == supervisor ? ProjectDetailsSupView(projectId: widget.projectId, key: UniqueKey()) :
              ProjectDetailsAdminView(projectId: widget.projectId, key: UniqueKey()),
          ]
        ),
      )
    );
  }
}