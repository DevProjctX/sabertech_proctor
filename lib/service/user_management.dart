
// class UserManagement {
  
// }
//   BehaviorSubject currentUser = BehaviorSubject<String>(seedValue: 'nouser');

//   Widget handleAuth() {
//     return new StreamBuilder(
//       stream: FirebaseAuth.instance.onAuthStateChanged,
//       builder: (BuildContext context, snapshot) {
//         if (snapshot.hasData) {
//           print(snapshot.data.uid);
//           currentUser.add(snapshot.data.uid);
//           return DashboardPage();
//         }
//         return LoginPage();
//       },
//     );
//   }

//   signOut() {
//     FirebaseAuth.instance.signOut();
//   }

//   authorizeAdmin(BuildContext context) {
//     FirebaseAuth.instance.currentUser().then((user) {
//       Firestore.instance
//           .collection('users')
//           .where('uid', isEqualTo: user.uid)
//           .getDocuments()
//           .then((docs) {
//         if (docs.documents[0].exists) {
//           if (docs.documents[0].data['role'] == 'admin') {
//             Navigator.push(
//                 context,
//                 new MaterialPageRoute(
//                     builder: (BuildContext context) => new AdminPage()));
//           } else {
//             print('Not Authorized');
//           }
//         }
//       });
//     });
//   }
// }