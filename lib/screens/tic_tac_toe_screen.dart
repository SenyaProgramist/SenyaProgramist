import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:phrasal_verbs/model/phrasal_verb.dart';
import 'package:phrasal_verbs/model/tic_tac_toe.dart';
import 'package:provider/provider.dart';
import 'package:phrasal_verbs/model/game_model.dart';
import 'package:phrasal_verbs/model/data_provider.dart';
import 'package:phrasal_verbs/model/verbs_bank.dart';
import 'package:phrasal_verbs/const.dart';
import 'package:spring_button/spring_button.dart';
import 'package:phrasal_verbs/widgets/linear_progress_indicator.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:phrasal_verbs/screens/result_screen.dart';
import 'dart:math';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'dart:async';
import 'package:phrasal_verbs/model/data_provider.dart';
import 'package:provider/provider.dart';
import 'package:animated_background/animated_background.dart';

class TTTScreen extends StatefulWidget {
  @override
  _TTTScreenState createState() => _TTTScreenState();
}

class _TTTScreenState extends State<TTTScreen> with TickerProviderStateMixin {
  int score = 0;
  Random random = Random();
  List<PhrasalVerb> correctAnswers;
  GameModel model = GameModel();
  List<PhrasalVerb> quizOptions = [];
  List<String> verbs = [];

  var bank = PhrasalVerbsBank();
  var ttt = TicTacToe();
  Preposition prep;
  bool freeze = false;
  List<Color> colors;

  void createOptions() {
    quizOptions.clear();
    colors = [
      Colors.white,
      Colors.white,
      Colors.white,
      Colors.white,
    ];
    List<PhrasalVerb> verbs =
        bank.verbs.where((e) => e.preposition == prep).toList();
    for (var i = 0; i < 3; i++) {
      var pV = verbs[random.nextInt(verbs.length - 1)];
      quizOptions.add(pV);
    }
    quizOptions.add(correctAnswers[level - 1]);

    quizOptions.shuffle();
  }

//  AnimationController _sunController;
//  Animation<double> animation;

  AnimationController controller;
  AnimationController progressController;
  Curve curve = Curves.easeOutExpo;
  Duration duration = Duration(seconds: 1);
  String correctAnswer;

  bool reward1 = true;
  bool reward2 = true;
  bool reward3 = true;
  int reward = 3;

  @override
  void initState() {
    controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    progressController =
        AnimationController(duration: Duration(seconds: 20), vsync: this);
    progressController.addListener(() {
      setState(() {
//        if (progressController.value < (1 / 3)) {
//          reward1 = false;
//        } else if (progressController.value < (1 / 2)) {
//          reward2 = false;
//        } else if (progressController.value < (2 / 3)) {
//          reward3 = false;
//        }
        if (progressController.value < (1 / 4)) {
          reward1 = false;
          reward = 0;
        } else if (progressController.value < (1 / 2)) {
          reward2 = false;
          reward = 1;
        } else if (progressController.value < (3 / 4)) {
          reward3 = false;
          reward = 2;
        }
      });
    });
    progressController.reverse(from: 1);
//    _sunController =
//        AnimationController(vsync: this, duration: Duration(seconds: 10));
//    animation =
//        CurvedAnimation(parent: _sunController, curve: Curves.decelerate);
//
//    _sunController.addListener(() {
//      setState(() {
//        print(_sunController.value);
//      });
//    });
//    _sunController.forward();
//    _sunController.addStatusListener((status) {
//      if (status == AnimationStatus.completed) {
//        _sunController.reverse(from: 1);
//      } else if (status == AnimationStatus.dismissed) {
//        _sunController.forward(from: 0);
//      }
//    });
    // TODO: implement initState
//    controller.addListener(() {
//      setState(() {
//        print(controller.value);
//      });
//    });
    while (quizOptions.length < 10) {
      String verb = '';
      List<PhrasalVerb> verbs =
          bank.verbs.where((e) => e.preposition == prep).toList();
      verb = bank.shortenVerb(verbs[random.nextInt(verbs.length - 1)]);
//      quizOptions.add(verb);
    }

    quizOptions.shuffle();

    super.initState();
    Provider.of<DataProvider>(context, listen: false)
        .setRightAnswers(correctAnswers[level - 1]);
  }

  int level = 1;

  PageController pageController = PageController(
    keepPage: false,
    initialPage: 1,
  );
  PageController pageControllerDescription = PageController(
    keepPage: false,
    initialPage: 1,
  );

  @override
  void dispose() {
    // TODO: implement dispose
//    _sunController.dispose();
    super.dispose();
  }

  int rightAnswer(int level) {
    return quizOptions.indexWhere((option) =>
        option.description == correctAnswers[level - 1].description);
  }

  bool get threeWordsPV => correctAnswers[level - 1].secondPreposition != null;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var width = size.width;
    final Animation<double> offsetAnimation = Tween(begin: 0.0, end: width / 20)
        .chain(CurveTween(curve: Curves.elasticIn))
        .animate(controller)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              controller.reverse();
            }
          });
    var provider = Provider.of<DataProvider>(context);
    Color color = provider.getCategoryColor(Category.food);
    var height = size.height;
    void nextPage() {
      provider.cleanAnswers();
      pageController.nextPage(
          duration: Duration(seconds: 1), curve: Curves.easeOutExpo);
    }

    double horizontalPadding = width / 30;

    return Scaffold(
      backgroundColor: color,
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: height / 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.close,
                    color: Colors.white,
                    size: width / 10,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    provider.cleanAnswers();
                  },
                ),
                Center(
                  child: Text(
                    'Description',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: width / 15),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: height / 40,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                ScoreProgressIndicator(
                  color: color,
                  horizontalPadding: horizontalPadding,
                  percent: progressController.value,
                ),
                SizedBox(
                  height: height / 100,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    SizedBox(
                      width: (width - horizontalPadding * 2) / 10,
                    ),
                    ProgressSection(
                      active: reward1,
                    ),
                    ProgressSection(
                      active: reward2,
                    ),
                    ProgressSection(
                      active: reward3,
                    ),
                    SizedBox(
                      width: (width - horizontalPadding * 2) / 10,
                    ),
                  ],
                ),
              ],
            ),
            Container(
                padding: EdgeInsets.all(width / 20),
                decoration: BoxDecoration(
                    color: kDarkBlue,
                    border: Border.all(color: kDarkBlue, width: width / 200)),
                child: Text(
                  bank.shortenPrepositionNoPv(prep),
                  style: TextStyle(fontSize: width / 10, color: Colors.white),
                )),
            SizedBox(
              height: height / 20,
            ),
            Container(
              width: width,
              height: width,
              child: Center(
                child: Container(
                  child: GridView.builder(
                    padding: EdgeInsets.only(),
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: 9,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3),
                    itemBuilder: (context, i) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            ttt.playGame(i, false);
                            ttt.checkWin();
                          });
                        },
                        child: AnswerCell(
                          state: ttt.gameState[i],
//
                          verb: 'verb',
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            PageView(
                controller: pageController,
                physics: NeverScrollableScrollPhysics(),
                pageSnapping: true,
                children: [
                  ListView.builder(
                    padding: EdgeInsets.only(top: height / 30),
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: 4,
                    itemBuilder: (context, i) {
                      return OptionAnswer(
                        accepted: false,
                        color: colors[i],
                        data: bank.shortenPrepositionNoPv(Preposition.of),
                        label: '',
                        onTap: () async {
                          if (!freeze) {
                            freeze = true;
                            setState(() {
                              prep = Preposition.$with;
                              colors[i] = Colors.green;
                            });
                            await Future.delayed(
                                Duration(milliseconds: 750), () {});
                            setState(() {
                              createOptions();
                            });
                            pageController.nextPage(
                                duration: duration, curve: curve);
                            freeze = false;
                          }
                        },
                      );
                    },
                  ),
                  ListView.builder(
                    padding: EdgeInsets.only(top: height / 30),
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: 4,
                    itemBuilder: (context, i) {
                      return OptionAnswer(
                        accepted: false,
                        color: colors[i],
                        data: 'kjdejkde',
                        label: '',
                        onTap: () async {
                          if (!freeze) {
                            freeze = true;
                            setState(() {
                              colors[i] = Colors.orangeAccent;
                            });
                            await Future.delayed(Duration(seconds: 1), () {});
                            setState(() {
                              colors[rightAnswer(level)] = Colors.green;

                              double n = 1 / correctAnswers.length;
                            });
                            await Future.delayed(
                                Duration(milliseconds: 750), () {});
                            if (level == correctAnswers.length) {
                              Navigator.pop(context);
                            } else {
                              setState(() {
                                level++;
                                createOptions();
                              });

                              pageController.nextPage(
                                  duration: duration, curve: curve);
                              pageControllerDescription.nextPage(
                                  duration: duration, curve: curve);
                              freeze = false;
                            }
                          }
                        },
                      );
                    },
                  ),
                  Container(),
                ]),
          ],
        ),
      ),
    );
  }
}

class AnswerCell extends StatelessWidget {
  AnswerCell({Key key, this.state, this.verb}) : super(key: key);

  final TTT state;
  final String verb;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var width = size.width;
    var provider = Provider.of<DataProvider>(context);
    Color color = provider.getCategoryColor(Category.food);
    var height = size.height;
    return Container(
      decoration: BoxDecoration(
          border: Border.all(
              style: BorderStyle.solid, width: width / 100, color: kDarkBlue)),
      child: state == TTT.empty
          ? Text(verb)
          : Icon(
              TicTacToe().getIcon(state),
              size: width / 5,
              color: Colors.white,
            ),
    );
  }
}

class ProgressSection extends StatelessWidget {
  const ProgressSection({Key key, this.active = true}) : super(key: key);

  final bool active;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var width = size.width;
    var height = size.height;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Icon(
          FontAwesome.trophy,
          color: active ? Colors.yellow : Colors.white24,
        )
//          Container(
//            height: height / 30,
//            width: width / 40,
//            decoration: BoxDecoration(
//                color: Colors.white,
//                borderRadius: BorderRadius.circular(width)),
//          ),
//                              Container(
//                                padding: EdgeInsets.all(width / 50),
//                                decoration: BoxDecoration(
//                                    color: Colors.white,
//                                    shape: BoxShape.circle),
//                                child: Icon(
//                                  FontAwesome.trophy,
//                                  color: color,
//                                  size: width / 20,
//                                ),
//                              ),
      ],
    );
  }
}

List<bool> boolList = [
  false,
  false,
  false,
  false,
  false,
  false,
];

class OptionAnswer extends StatelessWidget {
  const OptionAnswer(
      {Key key,
      this.data,
      this.correctAnswer,
      this.accepted,
      this.color = Colors.white,
      this.label,
      this.onTap})
      : super(key: key);
  final dynamic data;
  final bool accepted;
  final String correctAnswer;
  final String label;
  final Color color;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<DataProvider>(context);
    var size = MediaQuery.of(context).size;
    var width = size.width;
    var height = size.height;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
          duration: Duration(milliseconds: 150),
          width: width,
          padding: EdgeInsets.symmetric(vertical: height / 50),
          margin: EdgeInsets.symmetric(
              vertical: height / 100, horizontal: width / 20),
          decoration: BoxDecoration(
              color: color, borderRadius: BorderRadius.circular(width)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                width: width / 10,
              ),
              Text(
                '$label:',
                style: TextStyle(
                    color: kDarkBlue,
                    fontSize: width / 13,
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(
                width: width / 15,
              ),
              Text(
                data.toString(),
                style: TextStyle(
                    color: kDarkBlue,
                    fontSize: width / 14,
                    fontWeight: FontWeight.w700),
              ),
            ],
          )),
    );
  }
}
