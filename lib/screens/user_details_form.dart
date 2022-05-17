import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:sabertech_proctor/models/users.dart';
import 'package:sabertech_proctor/utils/authentication.dart' as auth;
import 'package:sabertech_proctor/models/users.dart' as firebase_user;

import 'home_page.dart';

// import '../widgets/date_time_picker.dart';

class UserDetailForm extends StatefulWidget {
  const UserDetailForm({Key? key}) : super(key: key);

  @override
  _UserDetailFormState createState() => _UserDetailFormState();
}

class _UserDetailFormState extends State<UserDetailForm> {
  final _formKey = GlobalKey<FormState>();
  String userName = '';
  String userPhone = '';
  DateTime signedInDate = DateTime.now();
  String error = '';

  @override
  Widget build(BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('User Details Form'),
          ),
          body: Form(
            autovalidateMode: AutovalidateMode.always,
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
                                hintText: 'Enter Name',
                                labelText: 'Name',
                              ),
                              validator: (text) {
                                            if (text == null || text.isEmpty) {
                                              return 'Name is empty';
                                            }
                                            return null;
                                          },
                              onChanged: (value) {
                                setState(() {
                                  userName = value;
                                });
                              },
                            ),
                            TextFormField(
                              decoration: const InputDecoration(
                                // border: OutlineInputBorder(),
                                filled: true,
                                hintText: '9999988888',
                                labelText: 'Mobile no.',
                              ),
                              validator: (value) => validateMobile(value),
                              onChanged: (value) {
                                userPhone = value;
                              },
                            ),
                        ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              await updateUserProfile().then((value)
                              {
                                print("userProfileupdated");
                                // Navigator.of(context).pop();
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                  builder: (context)=> HomePage())
                                );
                              });
                            }
                            
                            //TODO: Firestore create a new record code
                            // final projectDetails = User(
                            //   projectId:projectId,
                            //   projectName: projectName,
                            //   projectDetails: description,
                            //   status: 'CREATED',
                            //   numAgents: numAgents,
                            //   numStudents: numStudents,
                            //   numSupervisor: numSupervisor,
                            //   duration: endDate.toUtc().millisecondsSinceEpoch - startDate.millisecondsSinceEpoch,
                            //   projectStartTime: startDate,
                            //   projectEndTime: endDate,
                            //   projectDate: startDate
                            // );
                            

                            // FirebaseFirestore.instance
                            //     .collection("projects").doc(projectId)
                            //     .set(projectDetails.toJson())
                            //     .whenComplete((){
                            //   Navigator.of(context).pop();
                            // } );

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
  String? validateMobile(String? value) {
    String pattern =
        r"[0-9]{10}";
    RegExp regex = RegExp(pattern);
    if (value == null || value.isEmpty || !regex.hasMatch(value))
      return 'Enter a valid mobile number';
    else
      return null;
  }

  Future<void> updateUserProfile() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final User? user = _auth.currentUser;
    if (user != null) {
      print("inside if $user");
      final userToSave = firebase_user.User(
        name: userName,
        emailId: user.email ?? "dummy@email.com",
        userId: user.uid ,
        userRole: "agent",
        mobileNumber: userPhone,
        dateOfReg: DateTime.now()
      );

      await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .set(userToSave.toJson());
      await user.updateDisplayName(userName).then((value) => auth.name);
      // await user.updatePhoneNumber(userPhone)
      auth.userMobile = userPhone;
    }
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
