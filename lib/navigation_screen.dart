import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:phrasal_verbs/model/adjust_screen.dart';
import 'package:phrasal_verbs/screens/daily_screen.dart';
import 'package:phrasal_verbs/screens/games_screen.dart';
import 'package:phrasal_verbs/screens/result_screen.dart';
import 'package:phrasal_verbs/model/phrasal_verb.dart';
import 'package:phrasal_verbs/screens/gradients.dart';
import 'package:phrasal_verbs/model/shared_prefs.dart';
import 'package:phrasal_verbs/screens/tic_tac_toe_screen.dart';
import 'const.dart';
import 'package:provider/provider.dart';
import 'package:phrasal_verbs/model/data_provider.dart';
import 'package:phrasal_verbs/model/verbs_bank.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:phrasal_verbs/screens/library_screen.dart';
import 'package:phrasal_verbs/widgets/linear_progress_indicator.dart';

class NavigationScreen extends StatefulWidget {
  @override
  _NavigationScreenState createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen>
    with TickerProviderStateMixin {
  TabController tabController;
  List items = [
    MenuItem(name: MdiIcons.calendarSearch, color: kYellow, x: -1),
    MenuItem(
        name: MdiIcons.gamepadVariant, color: Colors.deepOrangeAccent, x: -0.5),
    MenuItem(
        name: MdiIcons.lockOpenOutline,
        color: Color(0xFF00CDAC).withOpacity(0.9),
        x: 0),
    MenuItem(name: MdiIcons.heart, color: Color(0xFFff5858), x: 0.5),
    MenuItem(name: MdiIcons.bookshelf, color: kYellow, x: 1),
  ];

  @override
  void initState() {
    // TODO: implement initState
    active = items[0];
    super.initState();
    tabController = new TabController(length: 5, vsync: this);
  }

  MenuItem active;
  @override
  void dispose() {
    // TODO: implement dispose
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var width = size.width;
    var height = size.height;
    Widget flare(MenuItem item) {
      return Padding(
        padding: EdgeInsets.only(top: height / 50),
        child: Tab(
          icon: Icon(
            item.name,
            size: active == item ? width / 12 : width / 15,
            color: active == item ? item.color : Colors.black26,
          ),
        ),
      );
    }

    List<Widget> list = [
      DailyScreen(),
      GamesScreen(),
      LibraryScreen(
        theme: kGreen.withOpacity(0.8),
        label: 'Unlocked',
        style: libraryStyle.unlocked,
      ),
      LibraryScreen(
        theme: kRed.withOpacity(0.9),
        style: libraryStyle.liked,
        label: 'Favourites',
      ),
      LibraryScreen(
        theme: kYellow,
        label: 'Categories',
        style: libraryStyle.all,
      ),
    ];

    var tabBarItem = new Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(width / 20)),
      height: height / 8,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          AnimatedContainer(
            //  <-- 3. Animated top bar

            duration: Duration(milliseconds: 200),
            alignment: Alignment(active.x, -1),
            child: AnimatedContainer(
              decoration: BoxDecoration(
                color: active.color,
              ),
              duration: Duration(milliseconds: 500),
              height: height / 100,
              width: width * 0.2,
            ),
          ),
          Expanded(
            child: TabBar(
              onTap: (index) {
                setState(() {
                  active = items[index];
                });
              },
              labelColor: kDarkBlue,
              unselectedLabelColor: Colors.black26,
              indicatorSize: TabBarIndicatorSize.label,
              indicatorColor: Colors.white,
              labelPadding: EdgeInsets.only(bottom: height / 25),
              tabs: items.map((f) => flare(f)).toList(),
              controller: tabController,
            ),
          ),
        ],
      ),
    );
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: tabBarItem,
        body: TabBarView(
          controller: tabController,
          physics: NeverScrollableScrollPhysics(),
          children: list,
        ),
      ),
    );
  }
}

class MenuItem {
  final IconData name;
  final Color color;
  final double x;
  MenuItem({this.name, this.color, this.x});
}
