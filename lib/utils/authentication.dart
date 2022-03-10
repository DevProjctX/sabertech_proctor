import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:sabertech_proctor/models/users.dart' as firebase_user;

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

String? uid;
String? name;
String? userEmail;
String? imageUrl;
String? userRole;

/// For checking if the user is already signed into the
/// app using Google Sign In
Future getUser() async {
  await Firebase.initializeApp();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool authSignedIn = prefs.getBool('auth') ?? false;
  final userRef = FirebaseFirestore.instance.collection('users').withConverter<firebase_user.User>(
        fromFirestore: (snapshot, _) => firebase_user.User.fromJson(snapshot.data()!),
        toFirestore: (user, _) => user.toJson(),
      );

  final User? user = _auth.currentUser;

  if (authSignedIn == true) {
    if (user != null) {
      var userDetails = (await userRef.doc(user.uid).get()).data();
      userRole = userDetails?.userRole;

      print("UserRole : $userRole");
      uid = user.uid;
      name = user.displayName;
      userEmail = user.email;
      imageUrl = user.photoURL;
    }
  }
}

Future<String?> getUserRole(String? uid) async{
  final userRef = FirebaseFirestore.instance.collection('users').withConverter<firebase_user.User>(
        fromFirestore: (snapshot, _) => firebase_user.User.fromJson(snapshot.data()!),
        toFirestore: (user, _) => user.toJson(),
      );
  var userDetails = (await userRef.doc(uid).get()).data();
  userRole = userDetails?.userRole;
  return userRole;
}

Future<String?> changeUserRole(String newRole) async {
  (await FirebaseFirestore.instance.collection('users').doc(uid).update({'user_role':newRole})
    .then((value) {
      print("role changed successfully");
      userRole = newRole;
    } ));
  print('user role changed $userRole');
  return userRole;
}

/// For authenticating user using Google Sign In
/// with Firebase Authentication API.
///
/// Retrieves some general user related information
/// from their Google account for ease of the login process
Future<User?> signInWithGoogle() async {
  await Firebase.initializeApp();

  User? user;

  if (kIsWeb) {
    GoogleAuthProvider authProvider = GoogleAuthProvider();

    try {
      final UserCredential userCredential =
          await _auth.signInWithPopup(authProvider);
      user = userCredential.user;
      print("before if1 $user");
        user = userCredential.user;
        if(userCredential.additionalUserInfo?.isNewUser == true && user != null){
          var userRole = firebase_user.UserRole.agent;
          print("inside if1 $user, UserRole:  $userRole");
          final userToSave = firebase_user.User(
                name: user.displayName,
                emailId: user.email ?? "test@email.com",
                userId: user.uid ,
                userRole: "agent",
                dateOfReg: DateTime.now()
              );

              FirebaseFirestore.instance
                  .collection("users").doc(user.uid)
                  .set(userToSave.toJson());
        }
    } catch (e) {
      print(e);
    }
  } else {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        final UserCredential userCredential =
            await _auth.signInWithCredential(credential);
        
        print("before if $user");
        user = userCredential.user;
        if(userCredential.additionalUserInfo?.isNewUser == true && user != null){
          print("inside if $user");
          final userToSave = firebase_user.User(
                name: user.displayName,
                emailId: user.email ?? "test@email.com",
                userId: user.uid ,
                userRole: "agent",
                dateOfReg: DateTime.now()
              );

              FirebaseFirestore.instance
                  .collection("users")
                  .doc(user.uid)
                  .set(userToSave.toJson());
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          print('The account already exists with a different credential.');
        } else if (e.code == 'invalid-credential') {
          print('Error occurred while accessing credentials. Try again.');
        }
      } catch (e) {
        print(e);
      }
    }
  }

  if (user != null) {
    uid = user.uid;
    name = user.displayName;
    userEmail = user.email;
    imageUrl = user.photoURL;
    userRole = await getUserRole(uid);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('auth', true);
  }

  return user;
}

Future<User?> registerWithEmailPassword(String email, String password) async {
  await Firebase.initializeApp();
  User? user;

  try {
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    user = userCredential.user;

    if (user != null) {
      uid = user.uid;
      userEmail = user.email;
    }
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      print('The password provided is too weak.');
    } else if (e.code == 'email-already-in-use') {
      print('The account already exists for that email.');
    }
  } catch (e) {
    print(e);
  }

  return user;
}

Future<User?> signInWithEmailPassword(String email, String password) async {
  await Firebase.initializeApp();
  User? user;

  try {
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    user = userCredential.user;

    if (user != null) {
      uid = user.uid;
      userEmail = user.email;

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('auth', true);
    }
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      print('No user found for that email.');
    } else if (e.code == 'wrong-password') {
      print('Wrong password provided.');
    }
  }

  return user;
}

Future<String> signOut() async {
  await _auth.signOut();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool('auth', false);

  uid = null;
  userEmail = null;

  return 'User signed out';
}

/// For signing out of their Google account
void signOutGoogle() async {
  await googleSignIn.signOut();
  await _auth.signOut();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool('auth', false);

  uid = null;
  name = null;
  userEmail = null;
  imageUrl = null;

  print("User signed out of Google account");
}
