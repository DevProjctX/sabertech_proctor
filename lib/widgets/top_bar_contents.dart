import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:sabertech_proctor/constants.dart';
import 'package:sabertech_proctor/models/project.dart';
import 'package:sabertech_proctor/screens/create_project.dart';
import 'package:sabertech_proctor/screens/home_page.dart';
import 'package:sabertech_proctor/screens/manager_view/past_projects.dart';
import 'package:sabertech_proctor/screens/user_page.dart';
import 'package:sabertech_proctor/utils/authentication.dart';
import 'package:flutter/material.dart';
import 'package:sabertech_proctor/widgets/navbar_menu.dart';

class TopBarContents extends StatefulWidget {
  final double opacity;

  TopBarContents(this.opacity);

  @override
  _TopBarContentsState createState() => _TopBarContentsState();
}

class _TopBarContentsState extends State<TopBarContents> {
  final List _isHovering = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ];

  bool _isProcessing = false;
  final GlobalKey _historyKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return PreferredSize(
      preferredSize: Size(screenSize.width, 1000),
      child: Container(
        color: Theme.of(context).bottomAppBarColor.withOpacity(widget.opacity),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Sabertechs',
                style: TextStyle(
                  color: Color.fromARGB(255, 9, 73, 100),
                  fontSize: 20,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w400,
                  letterSpacing: 3,
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(width: screenSize.width / 8),
                    userEmail != null 
                    ? InkWell(
                      onHover: (value) {
                        setState(() {
                          value
                              ? _isHovering[1] = true
                              : _isHovering[1] = false;
                        });
                      },
                      onTap: () {
                        Navigator.of(context).push(
                             MaterialPageRoute(
                                  builder: (context)=> UserPage())
                          );
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          userRole == admin ?
                          Text(
                            'Users',
                            style: TextStyle(
                              color: _isHovering[0]
                                  ? Colors.blue[200]
                                  : Color.fromARGB(255, 9, 73, 100),
                            ),
                          ): SizedBox(),
                          // DropdownButton<String>(
                          //   items: <String>['A', 'B', 'C', 'D'].map((String value) {
                          //     return DropdownMenuItem<String>(
                          //       value: value,
                          //       child: Text(value),
                          //     );
                          //   }).toList(),
                          //   onChanged: (_) {
                          //     print(_);
                          //   },
                          //   // value: 'Projects',
                          // ),
                          // MainMenu( title: 'Project'),
                          // Text(
                          //   'Projects',
                          //   style: TextStyle(
                          //     color: _isHovering[1]
                          //         ? Colors.blue[200]
                          //         : Color.fromARGB(255, 9, 73, 100),
                          //   ),
                          // ),
                          SizedBox(height: 5),
                          Visibility(
                            maintainAnimation: true,
                            maintainState: true,
                            maintainSize: true,
                            visible: _isHovering[1],
                            child: Container(
                              height: 2,
                              width: 20,
                              color: Color.fromARGB(255, 9, 73, 100),
                            ),
                          )
                        ],
                      ),
                    ): SizedBox(),
                  ],
                ),
              ),
              SizedBox(width: screenSize.width / 50),
              userEmail != null 
                    ? InkWell(
                      onHover: (value) {
                        // Offset offset = Offset.zero;
                        // final RenderObject? renderBox = _historyKey.currentContext.findRenderObject();
                        final box = _historyKey.currentContext?.findRenderObject() as RenderBox;
                        print(box.size);
                        final pos = box.localToGlobal(Offset.zero);
                        final left = pos.dx;// + box.size.width;
                        final top = pos.dy + box.size.height; //+ ;
                        //*The right does not indicates the width
                        final right = left;
                        final RelativeRect position = RelativeRect.fromLTRB(left, top, right, 0.0) ;
                        setState(() {
                          print(box.size);
                          if(value && userRole == admin){
                            showMenu(context: context, position: position, items: [
                            PopupMenuItem<int>(
                              value: 0,
                              child: Text('Past Projects'),
                              onTap: (){
                                // Navigator.pop(context);
                                Navigator.pushNamed(context, "/historyProjects");
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                  builder: (context)=> const PastProjects())
                                );
                              },
                            ),
                            PopupMenuItem<int>(
                              value: 1,
                              child: Text('Create Projects'),
                              onTap: (){
                                // Navigator.pop(context);
                                Navigator.pushNamed(context, "/createProject");
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                  builder: (context)=> const CreateProject())
                                );
                              },
                            ),
                            ]);
                          } else{
                          }
                          value
                              ? _isHovering[0] = true
                              : _isHovering[0] = false;
                        });
                      },
                      onTap: () {
                        if(userRole != admin){
                          Navigator.of(context).push(
                             MaterialPageRoute(
                                  builder: (context)=> const PastProjects())
                          );
                        }
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          userRole == admin ?
                          Text(
                            'Project',
                            style: TextStyle(
                              color: _isHovering[0]
                                  ? Colors.blue[200]
                                  : Color.fromARGB(255, 9, 73, 100),
                            ),
                            key: _historyKey,
                          ): Text(
                            'History',
                            style: TextStyle(
                              color: _isHovering[0]
                                  ? Colors.blue[200]
                                  : Color.fromARGB(255, 9, 73, 100),
                            ),
                            key: _historyKey,
                          ),
                          SizedBox(height: 5),
                          Visibility(
                            maintainAnimation: true,
                            maintainState: true,
                            maintainSize: true,
                            visible: _isHovering[0],
                            child: Container(
                              height: 2,
                              width: 20,
                              color: Color.fromARGB(255, 9, 73, 100),
                            ),
                          )
                        ],
                      ),
                    ): SizedBox(),
                    
              // IconButton(
              //   icon: Icon(Icons.brightness_6),
              //   splashColor: Colors.transparent,
              //   highlightColor: Colors.transparent,
              //   color: Color.fromARGB(255, 9, 73, 100),
              //   onPressed: () {
              //     EasyDynamicTheme.of(context).changeTheme();
              //   },
              // ),
              SizedBox(
                width: screenSize.width / 50,
              ),
              InkWell(
                onHover: (value) {
                  setState(() {
                    value ? _isHovering[3] = true : _isHovering[3] = false;
                  });
                },
                onTap: userEmail == null
                    ? () {
                        showDialog(
                          context: context,
                          builder: (context) => SizedBox(),
                        );
                      }
                    : null,
                child: userEmail == null
                    ? SizedBox()
                    : Row(
                        children: [
                          CircleAvatar(
                            radius: 15,
                            backgroundImage: imageUrl != null
                                ? NetworkImage(imageUrl!)
                                : null,
                            child: imageUrl == null
                                ? Icon(
                                    Icons.account_circle,
                                    size: 30,
                                  )
                                : Container(),
                          ),
                          SizedBox(width: 10),
                          TextButton(
                            style: TextButton.styleFrom(
                              primary: Colors.blueGrey,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            onPressed: _isProcessing
                                ? null
                                : () async {
                                    setState(() {
                                      _isProcessing = true;
                                    });
                                    await signOut().then((result) {
                                      print(result);
                                      Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                          fullscreenDialog: true,
                                          builder: (context) => HomePage(),
                                        ),
                                      );
                                    }).catchError((error) {
                                      print('Sign Out Error: $error');
                                    });
                                    setState(() {
                                      _isProcessing = false;
                                    });
                                  },
                            child: Padding(
                              padding: EdgeInsets.only(
                                top: 8.0,
                                bottom: 8.0,
                              ),
                              child: _isProcessing
                                  ? CircularProgressIndicator()
                                  : Text(
                                      'Sign out',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Color.fromARGB(255, 9, 73, 100),
                                      ),
                                    ),
                            ),
                          )
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

