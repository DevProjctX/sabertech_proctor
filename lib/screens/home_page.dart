
import 'package:sabertech_proctor/screens/mobile_auth.dart';
import 'package:sabertech_proctor/screens/user_details_form.dart';
import 'package:sabertech_proctor/utils/authentication.dart';
import 'package:sabertech_proctor/screens/projects_data.dart';
import 'package:sabertech_proctor/widgets/auth_dialog.dart';
import 'package:sabertech_proctor/widgets/top_bar_contents.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  static const String route = '/';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late ScrollController _scrollController;
  double _scrollPosition = 0;
  double _opacity = 0;

  _scrollListener() {
    setState(() {
      _scrollPosition = _scrollController.position.pixels;
    });
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    _opacity = _scrollPosition < screenSize.height * 0.40
        ? _scrollPosition / (screenSize.height * 0.40)
        : 1;

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
              backgroundColor:
                  Theme.of(context).bottomAppBarColor.withOpacity(_opacity),
              title: TopBarContents(_opacity),
            ),
      body: Center(
            child: userSignedIn == false ? AuthDialog() : userMobile == null ? UserDetailForm(key: UniqueKey()) : GetProject(),
          ),
    );
  }
}
