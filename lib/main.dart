import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sabertech_proctor/screens/agent_project_approval.dart';
import 'package:sabertech_proctor/screens/manager_view/past_projects.dart';
import 'package:sabertech_proctor/screens/projects_data.dart';
import 'package:sabertech_proctor/screens/user_online_status.dart';
import 'package:sabertech_proctor/utils/authentication.dart';
import 'package:sabertech_proctor/utils/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:sabertech_proctor/screens/user_page.dart';
import 'package:sabertech_proctor/screens/user_project_timeline.dart';
import 'package:sabertech_proctor/screens/create_project.dart';
import 'package:sabertech_proctor/widgets/menu_widget_using_package.dart';
import 'screens/home_page.dart';
import 'screens/agent_status.dart';

void main() async {
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyCFqdrDM-UZh8mOj12_AbdYu8qvzJE9Z5M",
      authDomain: "personal-test-81fe1.firebaseapp.com",
      databaseURL: "https://personal-test-81fe1-default-rtdb.firebaseio.com",
      projectId: "personal-test-81fe1",
      storageBucket: "personal-test-81fe1.appspot.com",
      messagingSenderId: "175534480516",
      appId: "1:175534480516:web:9cf8b0971d6ff0cfc6f6d1",
      measurementId: "G-BZQJ4NKXGQ"
  ));

  FirebaseAuth.instance.authStateChanges().listen(
      (event) async {
        if (event == null) {
          print('----user is currently signed out');
          userSignedIn = false;
        } else {
          userSignedIn = true;
          userEmail = event.email;
          name = event.displayName;
          uid = event.uid;
          await getUserRole(event.uid);
          print('----user is signed in $event ');
        }
        runApp(
          EasyDynamicThemeWidget(
            child: MyApp(),
          ),
        );
      },
    );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future getUserInfo() async {
    await getUser();
    setState(() {});
    print(uid);
  }

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sabertech Monitoring',
      theme: lightThemeData,
      // darkTheme: darkThemeData,
      debugShowCheckedModeBanner: false,
      themeMode: EasyDynamicTheme.of(context).themeMode,
      home: HomePage(),
      routes: {
        '/historyProjects': (context) => const PastProjects(),
        '/userTable': (context) => UserPage(),
        '/project': (context) => GetProject(),
        '/agentStatus': (context) => AgentStatus(),
        '/userTimeLine': (context) => ControlUserProjectTimeline(),
        '/createProject': (context) => CreateProject(),
        '/viewAgentProject/:id': (context) => AgentProjectApprovalScreen(key:UniqueKey(), id: ""),
        '/agentOnline': (context) => UserInformation(),
        // '/projectDetails': (context) => ProjectDetailsScreen(key: UniqueKey(), id: 'plqRydtwW8nfTaygbtZC'),
        // '/agentProjectDetails/:id': (context, args) => ProjectDetails(key: UniqueKey(), projectId: context.par),
      },
    );
  }
}
