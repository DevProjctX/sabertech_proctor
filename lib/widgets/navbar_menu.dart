import 'package:flutter/material.dart';

enum WhyFarther { harder, smarter, selfStarter, tradingCharter }

class MainMenu extends StatefulWidget {
  MainMenu({required this.title}) : super();

  final String title;

  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  WhyFarther _selection = WhyFarther.smarter;

  @override
  Widget build(BuildContext context) {
// This menu button widget updates a _selection field (of type WhyFarther,
// not shown here).
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: PopupMenuButton<WhyFarther>(
        child: Material(
          textStyle: Theme.of(context).textTheme.subtitle1,
          elevation: 2.0,
          child: Container(
            padding: EdgeInsets.all(8),
            child: Text(widget.title),
          ),
        ),
        onSelected: (WhyFarther result) {
          setState(() {
            _selection = result;
          });
        },
        itemBuilder: (BuildContext context) => <PopupMenuEntry<WhyFarther>>[
          const PopupMenuItem<WhyFarther>(
            value: WhyFarther.harder,
            child: Text('Working a lot harder'),
          ),
          const PopupMenuItem<WhyFarther>(
            value: WhyFarther.smarter,
            child: Text('Being a lot smarter'),
          ),
          const PopupMenuItem<WhyFarther>(
            value: WhyFarther.selfStarter,
            child: SubMenu('Sub Menu is too long'),
          ),
          const PopupMenuItem<WhyFarther>(
            value: WhyFarther.tradingCharter,
            child: Text('Placed in charge of trading charter'),
          ),
        ],
      ),
    );
  }
}

class SubMenu extends StatefulWidget {
  final String title;
  const SubMenu(this.title);

  @override
  _SubMenuState createState() => _SubMenuState();
}

class _SubMenuState extends State<SubMenu> {
  WhyFarther _selection = WhyFarther.smarter;

  @override
  Widget build(BuildContext context) {
//     print(rendBox.size.bottomRight);

    return PopupMenuButton<WhyFarther>(
      child: Row(
        children: <Widget>[
          Text(widget.title),
          Spacer(),
          Icon(Icons.arrow_right, size: 30.0),
        ],
      ),
      onCanceled: () {
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        }
      },
      onSelected: (WhyFarther result) {
        setState(() {
          _selection = result;
        });
      },
      // how much the submenu should offset from parent. This seems to have an upper limit.
      offset: Offset(0, 10000),
      itemBuilder: (BuildContext context) => <PopupMenuEntry<WhyFarther>>[
        const PopupMenuItem<WhyFarther>(
          value: WhyFarther.harder,
          child: Text('Working a lot harder'),
        ),
        const PopupMenuItem<WhyFarther>(
          value: WhyFarther.smarter,
          child: Text('Being a lot smarter'),
        ),
        const PopupMenuItem<WhyFarther>(
          value: WhyFarther.selfStarter,
          child: Text('Being a lot smarter'),
        ),
        const PopupMenuItem<WhyFarther>(
          value: WhyFarther.tradingCharter,
          child: Text('Placed in charge of trading charter'),
        ),
      ],
    );
  }
}