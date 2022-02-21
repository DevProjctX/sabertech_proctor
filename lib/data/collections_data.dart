import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddUser extends StatelessWidget{
  final String fullName;
  final String company;
  final int age;

  AddUser(this.fullName, this.company, this.age);

  @override
  Widget build(BuildContext context) {
    // Create a CollectionReference called users that references the firestore collection
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    Future<void> addUser() {
      // Call the user's CollectionReference to add a new user
      return users
          .add({
            'full_name': fullName, // John Doe
            'company': company, // Stokes and Sons
            'age': age // 42
          })
          .then((value) => print("User Added"))
          .catchError((error) => print("Failed to add user: $error"));
    }

    return TextButton(
      onPressed: addUser,
      child: Text(
        "Add User",
      ),
    );
  }
}

void getUsers() async {

    // Access Firestore using the default Firebase app:
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  final List users = [];
  return firestore
    .collection('db-test1')
    .limit(10)
    .get()
    .then((QuerySnapshot querySnapshot) {
        return querySnapshot.docs.forEach((doc) {
            users.add(doc["user_id"])
        });
    });
}