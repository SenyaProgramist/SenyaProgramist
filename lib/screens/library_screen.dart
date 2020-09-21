import 'package:flutter/material.dart';
import 'package:phrasal_verbs/model/data_provider.dart';
import 'package:provider/provider.dart';
import 'package:phrasal_verbs/model/phrasal_verb.dart';
import 'package:tinycolor/tinycolor.dart';
import 'package:phrasal_verbs/widgets/like_button.dart';
import 'package:phrasal_verbs/const.dart';
import 'package:phrasal_verbs/screens/learning_screen.dart';
import 'package:phrasal_verbs/widgets/dialogs.dart';
import 'package:phrasal_verbs/animations.dart';
import 'package:phrasal_verbs/model/phrasal_verb.dart';
import 'package:phrasal_verbs/model/database.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:phrasal_verbs/widgets/bottom_menu.dart';
import 'package:animated_size_and_fade/animated_size_and_fade.dart';
import 'package:enhanced_future_builder/enhanced_future_builder.dart';
import 'package:phrasal_verbs/widgets/content.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:phrasal_verbs/model/verbs_bank.dart';

enum libraryStyle { all, unlocked, liked }

class LibraryScreen extends StatefulWidget {
  final String label;
  final Color theme;
  final libraryStyle style;

  LibraryScreen({
    Key key,
    this.label,
    this.style,
    this.theme,
  }) : super(key: key);
  @override
  _LibraryScreenState createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen>
    with TickerProviderStateMixin {
  ScrollController scrollController;
  PageController pageVerbsController;
  PageController pageCategoryController;
  PanelController panelController;
  bool isLocked = false;
  var bank = PhrasalVerbsBank();
//  AnimationController controller;

  Category selectedCategory;
  Color color;
  PhrasalVerb selectedPhrasalVerb;
  List<PhrasalVerb> getVerbs(bool inSearch, List<PhrasalVerb> verbs) {
    if (inSearch) {
      return verbs
          .where((e) => bank
              .nameOfPhrasalVerb(e)
              .toLowerCase()
              .contains(searched.toLowerCase()))
          .toList();
    } else {
      return bank.verbsListByCategory(selectedCategory, verbs);
    }
  }

  List<Category> getCategories(bool inSearch, List<PhrasalVerb> verbs) {
    List<Category> res = [];
    if (inSearch) {
      for (var verb in getVerbs(inSearch, verbs)) {
        if (!res.contains(verb.category)) {
          res.add(verb.category);
        }
      }
    } else {
      for (var verb in verbs) {
        if (widget.label == 'Favourites') {
//          print(verb.category);
        }
        if (!res.contains(verb.category)) {
//          print(verb.category);
          res.add(verb.category);
        }
      }
    }
    return res;
  }

  FocusNode node;
  @override
  void initState() {
    node = FocusNode();
    scrollController = ScrollController();
    pageVerbsController = PageController();

    panelController = PanelController();
    pageCategoryController = PageController(
      initialPage: 0,
      viewportFraction: 0.85,
    );
    color = widget.theme;
//    controller = AnimationController(vsync: this, duration: Duration(milliseconds: 300));
//    controller.addListener(() {
//      setState(() {});
//  });
//    controller.forward();
    print('LIBRARY SCREEN');
    // TODO: implement initState
//    selectedCategory = getCategories(inSearch)[0];
//Future.delayed(Duration(seconds: 5),(){
//  setState(() {
//    selectedCategory = Category.money;
//  });
//});
    selectedPhrasalVerb = bank.verbs.first;
    super.initState();
  }

  bool firstLoad = true;
  int selectedIndex = 0;

  bool inSearch = false;
  String searched = '';

  double panelOpenedPercent = 0;
  Duration loadDuration = const Duration(milliseconds: 300);
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var width = size.width;
    var provider = Provider.of<DataProvider>(context);

    var height = size.height;
    double extent = width / 2.2;

    Future<List<PhrasalVerb>> verbsByLibraryStyle() async {
      switch (widget.style) {
        case libraryStyle.liked:
          return await Future.delayed(loadDuration, () async {
            return await provider.getLikedPhrasalVerbs();
          });
        case libraryStyle.all:
          return await Future.delayed(loadDuration, () {
            return bank.verbs;
          });
        case libraryStyle.unlocked:
          return await provider.unlockedPhrasalVerbs();
        default:
          return await Future.delayed(loadDuration, () {
            return bank.verbs;
          });
      }
    }

    return Scaffold(
      backgroundColor: kDBackGround,
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
      body: SlidingUpPanel(
        minHeight: 0,
        backdropTapClosesPanel: true,
        backdropEnabled: true,
        backdropOpacity: 0.5,
        maxHeight: height / 1.32,
        parallaxEnabled: false,
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(width / 20),
            topLeft: Radius.circular(width / 20)),
        controller: panelController,
        //
        //
        onPanelClosed: () async {
          await provider.saveFromTempLikedVerbs();
        },
        onPanelSlide: (double) async {
          await Future.delayed(Duration(milliseconds: 50));
          setState(() {
            panelOpenedPercent = double;
          });
        },
        defaultPanelState: PanelState.CLOSED,
        panel: PhrasalVerbFullScreen(
            phrasalVerb: selectedPhrasalVerb,
            color: color,
            revealedPercent: panelOpenedPercent),
        body: Container(
          child: Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: height / 1,
                  decoration: BoxDecoration(
                    color: kDBackGround,
                  ),
                  child: EnhancedFutureBuilder(
//                    future: provider.getLikedPhrasalVerbs(),
                    future: Future.delayed(Duration(milliseconds: 200),
                        () => verbsByLibraryStyle()),
                    rememberFutureResult: true,
                    whenDone: (data) {
                      if (data.isNotEmpty) {
                        if (firstLoad) {
                          selectedCategory = getCategories(inSearch, data)[0];
                          firstLoad = false;
                        }
                        return FadeIn(
                          delay: 0,
                          isHorizontal: false,
                          begin: 0,
                          duration: Duration(milliseconds: 200),
                          child: PageView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            controller: pageVerbsController,
                            itemBuilder: (context, index) {
                              var phrasalVerbs = getVerbs(inSearch, data);
                              return ListView.builder(
                                  physics: AlwaysScrollableScrollPhysics(),
                                  padding: EdgeInsets.only(
                                      bottom: height / 7, top: height / 2.7),
                                  itemCount: phrasalVerbs.length,
                                  itemBuilder: (context, item) {
                                    var phrasalVerb = phrasalVerbs[item];
                                    return GestureDetector(
                                      onTap: () async {

                                        if (await provider
                                            .isUnlocked(phrasalVerb)) {
                                          provider.vibrate(2);
                                          await provider.setTempLikedVerbs();
                                          setState(() {
                                            selectedPhrasalVerb = phrasalVerb;
                                          });
                                          await panelController.open();
                                        } else {
                                          await provider.vibrate(4);
//                                          await Dialogs.showAdDialog(context);
                                          await Dialogs.showAdDialog(
                                            context,
                                            unlockWord: true,
                                          );
                                        }
//        subjectTapped(context, index);
//        provider.changeSubjectIndex(index);
                                      },
                                      child: ListCard(
                                        bank: bank,
                                        phrasalVerb: phrasalVerb,
                                        style: widget.style,
                                        delay: item / 10,
                                      ),
                                    );
                                  });
                            },
                          ),
                        );
                      } else {
                        return Center(
                          child: GestureDetector(
                            onTap: () {
                              provider.vibrate(1);
                              if (widget.style == libraryStyle.unlocked) {
                                provider.navigateTo(
                                  LearningScreen(
                                    category: PhrasalVerbsBank.firstCategory,
                                    index: 1,
                                    heroTag: '',
                                  ),
                                  context,
                                );
                              }
                            },
                            child: FadeIn(
                              delay: 1,
                              begin: 0,
                              isHorizontal: false,
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: width / 20),
                                child: Text(
                                  widget.style == libraryStyle.liked
                                      ? 'Tap ❤ to mark phrasal verbs as favourite'
                                      : 'Learn some few words first',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    decoration:
                                        widget.style == libraryStyle.unlocked
                                            ? TextDecoration.underline
                                            : TextDecoration.none,
                                    color: kDarkBlue.withOpacity(0.8),
                                    fontWeight: FontWeight.w700,
                                    fontSize: width / 15,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                    },
                    whenNotDone: Container(),
                  ),
                ),
              ),
              Container(
//                height: height/7 + height*controller.value/5 ,//
                height: height / 3,
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: kDarkBlue.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 8,
                      )
                    ],
                    color: kLDarkBlue,
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(width / 15),
                        bottomLeft: Radius.circular(width / 15))),
                child: Column(
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            FadeIn(
                              begin: -width / 100,
                              delay: 0.5,
                              child: AnimatedContainer(
                                padding: EdgeInsets.only(
                                  left: width / 20,
                                  right: width / 20,
                                  top: height / 30,
                                ),
                                decoration: BoxDecoration(
//                                borderRadius: BorderRadius.circular(width),
                                    borderRadius: BorderRadius.only(
                                        bottomRight:
                                            Radius.circular(width / 15)),
                                    color: Colors.white),
                                curve: Curves.decelerate,
                                width: inSearch ? width / 1.3 : width / 1.7,
                                duration: Duration(milliseconds: 500),
                                child: AnimatedSwitcher(
                                    duration: Duration(milliseconds: 50),
                                    child: Center(
                                      child: inSearch
                                          ? Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: width / 20),
                                              child: TextField(
                                                focusNode: node,
                                                decoration: null,
                                                cursorColor: kDarkBlue,
                                                cursorWidth: 4,
                                                cursorRadius:
                                                    Radius.circular(1000),
                                                style: TextStyle(
                                                    fontSize: width / 20,
                                                    fontWeight:
                                                        FontWeight.w700),
                                                onChanged: (str) {
                                                  setState(() {
                                                    searched = str;
                                                  });
                                                },
                                              ),
                                            )
                                          : Text(
                                              widget.label,
                                              style: TextStyle(
                                                  color: color,
                                                  fontSize: width / 12,
                                                  fontWeight: FontWeight.w800),
                                            ),
                                    )),
                              ),
                            ),
                            FadeIn(
                              begin: width / 100,
                              delay: 0.5,
                              child: GestureDetector(
                                onTap: () async {
                                  provider.vibrate(2);
                                  if (inSearch) {
                                    setState(() {
                                      inSearch = false;
                                      searched = '';
                                    });
                                    FocusScope.of(context)
                                        .requestFocus(new FocusNode());
                                  } else {
                                    setState(() {
                                      inSearch = true;
                                    });
                                    await Future.delayed(
                                      loadDuration,
                                    );
                                    FocusScope.of(context).requestFocus(node);
                                  }
                                },
                                child: Container(
                                  margin: EdgeInsets.only(
                                      top: height / 35, right: width / 40),
                                  child: AnimatedSizeAndFade(
                                    vsync: this,
                                    child: Icon(
                                      !inSearch ? Icons.search : Icons.close,
                                      key: ValueKey(inSearch),
                                      size: width / 10,
                                      color: kDarkBlue,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height / 40,
                    ),
                    Expanded(
                      flex: 3,
                      child: Container(
                        child: EnhancedFutureBuilder(
//                        future: provider.getLikedPhrasalVerbs(),
                          future: verbsByLibraryStyle(),
                          rememberFutureResult: true,
                          whenDone: (data) {
                            if (!data.isNotEmpty) {
                              return Container();
                            } else {
                              if (firstLoad) {
                                selectedCategory =
                                    getCategories(inSearch, data).first;

                                firstLoad = false;
                              }

                              return Container(
                                child: PageView.builder(
                                    itemCount:
                                        getCategories(inSearch, data).length,
                                    scrollDirection: Axis.horizontal,

//                  viewportFraction: 0.35,

                                    pageSnapping: false,
//                              controller: scrollController,

                                    controller: pageCategoryController,
//                            viewportFraction: 0.5,
//                              itemExtent: extent,
                                    itemBuilder: (context, index) {
                                      Category category =
                                          getCategories(inSearch, data)[index];
                                      return InkWell(
                                        enableFeedback: true,
                                        onTap: () async {
                                          provider.vibrate(1);
                                          // controller.move(index);
                                          pageCategoryController.animateToPage(
                                              index,
                                              duration: animationDuration,
                                              curve: Curves.decelerate);
//                                          Future.delayed(
//                                              Duration(milliseconds: 200), () {
//                                            if (index < selectedIndex) {
//                                              pageVerbsController.previousPage(
//                                                  duration: animationDuration,
//                                                  curve: Curves.decelerate);
//                                            } else if (index > selectedIndex) {
//                                              pageVerbsController.nextPage(
//                                                  duration: animationDuration,
//                                                  curve: Curves.decelerate);
//                                            }
//                                          });

//                                        Future.delayed(
//                                            Duration(
//                                                milliseconds: (animationDuration
//                                                        .inMilliseconds ~/
//                                                    20)), () {
                                          setState(() {
                                            selectedCategory = category;
                                            selectedIndex = index;
                                          });
//                                        });

//                                  scrollController.animateTo(
//                                      extent * (index - 1),
//                                      duration: Duration(milliseconds: 500),
//                                      curve: Curves.easeOutCubic);
                                        },
                                        child: SizeAnimation(
                                          end: 1,
                                          delay: 0,
                                          begin: 0.5,
                                          child: CategoryAvatar(
                                              color: color,
                                              category: category,
                                              isChosen:
                                                  selectedCategory == category),
                                        ),
                                      );
                                    }),
                              );
                            }
                          },
                          whenNotDone: Container(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    node.dispose();
    pageCategoryController.dispose();
    scrollController.dispose();
    pageVerbsController.dispose();
    super.dispose();
  }
}

class ListCard extends StatelessWidget {
  const ListCard({
    Key key,
    @required this.bank,
    @required this.delay,
    @required this.phrasalVerb,
    @required this.style,
  }) : super(key: key);

  final PhrasalVerbsBank bank;
  final double delay;
  final PhrasalVerb phrasalVerb;
  final libraryStyle style;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var width = size.width;
    var provider = Provider.of<DataProvider>(context);
    var height = size.height;
    return Container(
      height: height / 9,
      padding: EdgeInsets.symmetric(horizontal: width / 15),
      margin:
          EdgeInsets.symmetric(vertical: height / 100, horizontal: width / 30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(width / 20),
      ),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Expanded(
          flex: 5,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              FadeIn(
                delay: delay / 2,
                begin: 0,
                child: Text(
                  bank.nameOfPhrasalVerb(phrasalVerb),
                  style: TextStyle(
                      color: kDarkBlue,
                      fontWeight: FontWeight.w800,
                      fontSize: width / 16),
                ),
              ),
              SizedBox(
                height: height / 100,
              ),
              FadeIn(
                delay: delay,
                isHorizontal: false,
                begin: width / 15,
                child: Text(
                  bank.capitalize(phrasalVerb.description),
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Colors.black26,
                      fontWeight: FontWeight.w600,
                      fontSize: width / 25),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Container(),
        ),
        Container(
          child: FutureBuilder(
            future: provider.isUnlocked(phrasalVerb),
            builder: (context, AsyncSnapshot<bool> snapshot) {
              if (snapshot.hasData) {
                bool unlocked;
                if (style == libraryStyle.all) {
                  unlocked = snapshot.data;
                } else {
                  unlocked = true;
                }
                return FadeIn(
                  delay: delay,
                  begin: width / 50,
                  child: Icon(
                    unlocked ? Icons.keyboard_arrow_right : Icons.lock,
                    size: unlocked ? width / 10 : width / 15,
                    color: Colors.black12,
                  ),
                );
              } else {
                return Container();
              }
            },
          ),
        ),
      ]),
    );
  }
}

const Duration animationDuration = Duration(milliseconds: 300);

class CategoryAvatar extends StatelessWidget {
  const CategoryAvatar({
    Key key,
    @required this.category,
    @required this.isChosen,
    @required this.color,
  }) : super(key: key);

  final Category category;
  final bool isChosen;
  final Color color;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var width = size.width;
    var provider = Provider.of<DataProvider>(context);
    var height = size.height;
    return Container(
      padding: EdgeInsets.only(bottom: height / 40),
      child: AnimatedContainer(
        padding: EdgeInsets.all(width / 20),
        margin: EdgeInsets.symmetric(
          horizontal: width / 70,
        ),
        duration: Duration(milliseconds: 400),
        width: height / 10,
        height: height / 10,
        decoration: BoxDecoration(
//                                  borderRadius:
//                                      BorderRadius.circular(width / 15),
          borderRadius: BorderRadius.circular(width / 15),
          boxShadow: isChosen
              ? [
                  BoxShadow(
                    color: color.withOpacity(0.6),
                    offset: Offset(0, 3),
                    spreadRadius: 1,
                    blurRadius: 8,
                  )
                ]
              : [],
          color: !isChosen ? color.withOpacity(0.9) : color,
//          gradient: LinearGradient(colors: [
//            provider.getCategoryColor(category),
//            provider.getCategoryColor(category).withOpacity(0.9),
//          ], begin: Alignment.centerLeft, end: Alignment.centerRight)
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                provider.categoryToLabel(category),
                style: TextStyle(
                    color: isChosen ? Colors.white : Colors.black26,
                    fontWeight: FontWeight.w700,
                    fontSize: width / 22),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                child: SizeAnimation(
                  delay: 0.5,
                  end: 1,
                  child: Icon(
                    provider.getCategoryIcon(category),
                    color: !isChosen ? Colors.black26 : Colors.white,
                    size: width / 10,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PhrasalVerbFullScreen extends StatelessWidget {
  final PhrasalVerb phrasalVerb;
  final double revealedPercent;
  final Color color;
//  final int gradient;

  PhrasalVerbFullScreen({
    this.phrasalVerb,
    this.revealedPercent,
    this.color,
  }

//    this.gradient,
      );
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var width = size.width;
    var provider = Provider.of<DataProvider>(context);
    var height = size.height;
    var bank = PhrasalVerbsBank();

    return Container(
      decoration: BoxDecoration(
//          gradient: LinearGradient(
//              begin: Alignment.topCenter,
//              end: Alignment.bottomCenter,
//              colors: gradient == 1
//                  ? [Color(0xFFF15F79), Color(0xFFF15F79)]
//                  : gradient == 2
//                      ? [Color(0xFFF7971E), Color(0xFFFFD200)]
//                      : [Color(0xFF0083B0), Color(0xFF00B4DB)]),
//              colors: [Color(0xFFF7971E), Color(0xFFFFD200)]),
//              colors: [Color(0xFF0083B0), Color(0xFF00B4DB)]),
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(width / 20),
              topLeft: Radius.circular(width / 20))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                color: color,
//                gradient: LinearGradient(
//                    begin: Alignment.topCenter,
//                    end: Alignment.bottomCenter,
//                    colors: gradient == 1
//                        ? [Color(0xFFF15F79), Color(0xFFF15F79)]
//                        : gradient == 2
//                        ? [Color(0xFFF7971E), Color(0xFFFFD200)]
//                        : [Color(0xFF00CDAC).withOpacity(0.8), Color(0xFF00B4DB)]),
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(width / 20),
                    topLeft: Radius.circular(width / 20))),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(
                      top: height / 20 + height / 15 * revealedPercent,
                      left: width / 20,
                      bottom: height / 50),
                  child: Text(
                    bank.nameOfPhrasalVerb(phrasalVerb),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: width / 10,
                        fontWeight: FontWeight.w900),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(width / 20),
                        bottomLeft: Radius.circular(width / 8),
                      )),
                  padding: EdgeInsets.all(width / 12),
                  child: LikeStarButton(
                    phrasalVerb: phrasalVerb,
                  ),
                )
              ],
            ),
          ),
//          Container(
//            margin: EdgeInsets.symmetric(vertical: height/20),
//            child: Row(
//              children: <Widget>[],
//            ),

//          ),
          Expanded(
            child: Opacity(
              opacity: revealedPercent,
              child: Container(
                padding: EdgeInsets.only(top: height / 20),
                color: Colors.white,
                child: PhrasalVerbMenu(
                  phrasalVerb: phrasalVerb,
                  color: kDarkBlue,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
