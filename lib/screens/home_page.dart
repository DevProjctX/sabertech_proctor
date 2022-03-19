import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:sabertech_proctor/utils/authentication.dart';
import 'package:sabertech_proctor/widgets/auth_dialog.dart';
import 'package:sabertech_proctor/widgets/web_scrollbar.dart';
import 'package:sabertech_proctor/widgets/bottom_bar.dart';
import 'package:sabertech_proctor/widgets/carousel.dart';
import 'package:sabertech_proctor/widgets/destination_heading.dart';
import 'package:sabertech_proctor/widgets/explore_drawer.dart';
import 'package:sabertech_proctor/widgets/featured_heading.dart';
import 'package:sabertech_proctor/widgets/featured_tiles.dart';
import 'package:sabertech_proctor/widgets/floating_quick_access_bar.dart';
import 'package:sabertech_proctor/widgets/responsive.dart';
import 'package:sabertech_proctor/screens/projects_data.dart';
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
          // : PreferredSize(
          //     preferredSize: Size(screenSize.width, 1000),
          //     child: TopBarContents(_opacity),
          //   ),
      // drawer: ExploreDrawer(),
      body: Center(
            child: userEmail == null ? AuthDialog() : GetProject(),
              // SizedBox(height: 40),
            // ]
          ),
      // WebScrollbar(
      //   color: Colors.blueGrey,
      //   backgroundColor: Colors.blueGrey.withOpacity(0.3),
      //   width: 10,
      //   heightFraction: 0.3,
      //   controller: _scrollController,
      //   child: SingleChildScrollView(
      //     controller: _scrollController,
      //     physics: ClampingScrollPhysics(),
      //     child: Column(
      //       children: [
      //         // SizedBox(height: 40),
      //         // AuthDialog(),
      //         SizedBox(height: 40),
      //         Stack(
      //           children: [
      //             Container(
      //               child: AuthDialog(),
      //             ),
      //             Column(
      //               children: [
      //                 FloatingQuickAccessBar(screenSize: screenSize),
      //                 Container(
      //                   child: Column(
      //                     children: [
      //                       FeaturedHeading(
      //                         screenSize: screenSize,
      //                       ),
      //                       FeaturedTiles(screenSize: screenSize)
      //                     ],
      //                   ),
      //                 ),
      //               ],
      //             )
      //           ],
      //         ),
      //         // DestinationHeading(screenSize: screenSize),
      //         // DestinationCarousel(),
      //         SizedBox(height: screenSize.height / 10),
      //         // BottomBar(),
      //       ],
      //     ),
      //   ),
      // ),
    );
  }
}
