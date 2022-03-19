import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';
import 'package:sabertech_proctor/models/project.dart';
import 'package:sabertech_proctor/widgets/date_time_picker.dart';

// import '../widgets/date_time_picker.dart';

class FormWidgetsDemo extends StatefulWidget {
  const FormWidgetsDemo({Key? key}) : super(key: key);

  @override
  _FormWidgetsDemoState createState() => _FormWidgetsDemoState();
}

class _FormWidgetsDemoState extends State<FormWidgetsDemo> {
  final _formKey = GlobalKey<FormState>();
  String projectName = '';
  String description = '';
  DateTime startDateTime = DateTime.now();
  int numStudents = 1;
  int numAgents = 1;
  int numSupervisor = 1;
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  double maxValue = 0;
  bool? brushedTeeth = false;
  bool enableFeature = false;

  @override
  Widget build(BuildContext context) {
    String projectId;
        return Scaffold(
          appBar: AppBar(
            title: const Text('Form widgets'),
          ),
          body: Form(
            key: _formKey,
            child: Scrollbar(
              child: Align(
                alignment: Alignment.topCenter,
                child: Card(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 800),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ...[
                            TextFormField(
                              decoration: const InputDecoration(
                                filled: true,
                                hintText: 'Enter Project Name',
                                labelText: 'Project Name',
                              ),
                              onChanged: (value) {
                                setState(() {
                                  projectName = value;
                                });
                              },
                            ),
                            TextFormField(
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                filled: true,
                                hintText: 'Project description...',
                                labelText: 'Project Description',
                              ),
                              onChanged: (value) {
                                description = value;
                              },
                              maxLines: 5,
                            ),
                            TextFormField(
                              keyboardType: TextInputType.number,
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              decoration: const InputDecoration(
                                filled: true,
                                hintText: '10',
                                labelText: 'Agents Required',
                              ),
                              onChanged: (value) {
                                setState(() {
                                  numAgents = int.tryParse(value)!;
                                });
                              },
                            ),
                            TextFormField(
                              keyboardType: TextInputType.number,
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              decoration: const InputDecoration(
                                filled: true,
                                hintText: '10',
                                labelText: 'Total Students',
                              ),
                              onChanged: (value) {
                                setState(() {
                                  numStudents = int.tryParse(value)!;
                                });
                              },
                            ),
                            TextFormField(
                              keyboardType: TextInputType.number,
                              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                              decoration: const InputDecoration(
                                filled: true,
                                hintText: '10',
                                labelText: 'Supervisor Required',
                              ),
                              onChanged: (value) {
                                setState(() {
                                  numSupervisor = int.tryParse(value)!;
                                });
                              },
                            ),
                            DatetimePickerWidget(
                              dateTime: startDate,
                              onChanged: (value) {
                                setState(() {
                                  startDate = value;
                                });
                              },
                              widgetText: 'Project Start time',
                            ),
                            DatetimePickerWidget(
                              dateTime: endDate,
                              onChanged: (value) {
                                setState(() {
                                  endDate = value;
                                });
                              },
                              widgetText: 'Project End time',
                            ),
                            //   date: date,
                            //   onChanged: (value) {
                            //     setState(() {
                            //       date = value;
                            //     });
                            //   },
                            // ),
                        RaisedButton(

                          onPressed: () {
                            projectId = Uuid().toString();
                            //TODO: Firestore create a new record code
                            final projectDetails = Project(
                              projectId:projectId,
                              projectName: projectName,
                              projectDetails: description,
                              status: 'CREATED',
                              numAgents: numAgents,
                              numStudents: numStudents,
                              numSupervisor: numSupervisor,
                              duration: endDate.toUtc().millisecondsSinceEpoch - startDate.millisecondsSinceEpoch,
                              projectStartTime: startDate,
                              projectEndTime: endDate,
                              projectDate: startDate
                            );
                            

                            FirebaseFirestore.instance
                                .collection("projects").doc(projectId)
                                .set(projectDetails.toJson())
                                .whenComplete((){
                              Navigator.of(context).pop();
                            } );

                          },
                          child: Text("Submit", style: TextStyle(color: Colors.white),),
                        ),
                      ].expand(
                        (widget) => [
                          widget,
                          const SizedBox(
                            height: 24,
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// class _FormDatePicker extends StatefulWidget {
//   final DateTime date;
//   final ValueChanged<DateTime> onChanged;

//   const _FormDatePicker({
//     required this.date,
//     required this.onChanged,
//   });

//   @override
//   _FormDatePickerState createState() => _FormDatePickerState();
// }

// class _FormDatePickerState extends State<_FormDatePicker> {
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: [
//             Text(
//               'Date',
//               style: Theme.of(context).textTheme.bodyText1,
//             ),
//             Text(
//               intl.DateFormat.yMd().format(widget.date),
//               style: Theme.of(context).textTheme.subtitle1,
//             ),
//           ],
//         ),
//         TextButton(
//           child: const Text('Edit'),
//           onPressed: () async {
//             var newDate = await showDatePicker(
//               context: context,
//               initialDate: widget.date,
//               firstDate: DateTime(1900),
//               lastDate: DateTime(2100),
//             );

//             // Don't change the date if the date picker returns null.
//             if (newDate == null) {
//               return;
//             }

//             widget.onChanged(newDate);
//           },
//         )
//       ],
//     );
//   }
// }

// class _FormTimePicker extends StatefulWidget {
//   final Time date;
//   final ValueChanged<DateTime> onChanged;

//   const _FormTimePicker({
//     required this.date,
//     required this.onChanged,
//   });

//   @override
//   _FormDatePickerState createState() => _FormDatePickerState();
// }

// class _FormTimePickerState extends State<_FormTimePicker> {
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: [
//             Text(
//               'Start time',
//               style: Theme.of(context).textTheme.bodyText1,
//             ),
//             Text(
//               intl.DateFormat.Hm().format(widget.date),
//               style: Theme.of(context).textTheme.subtitle1,
//             ),
//           ],
//         ),
//         TextButton(
//           child: const Text('Edit'),
//           onPressed: () async {
//             var newDate = await showTimePicker(
//               context: context,
//               initialTime: widget.date,
//             );

//             // Don't change the date if the date picker returns null.
//             if (newDate == null) {
//               return;
//             }

//             widget.onChanged(newDate);
//           },
//         )
//       ],
//     );
//   }
// }
