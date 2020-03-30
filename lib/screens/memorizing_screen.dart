import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:phrasal_verbs/model/phrasal_verb.dart';
import 'package:provider/provider.dart';
import 'package:phrasal_verbs/widgets/screen_quiz_template.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'package:phrasal_verbs/widgets/progress_trophy.dart';
import 'package:page_transition/page_transition.dart';
import 'package:phrasal_verbs/model/game_model.dart';
import 'package:phrasal_verbs/model/data_provider.dart';
import 'package:phrasal_verbs/model/verbs_bank.dart';
import 'package:phrasal_verbs/const.dart';
import 'package:spring_button/spring_button.dart';
import 'package:phrasal_verbs/widgets/linear_progress_indicator.dart';
import 'package:phrasal_verbs/widgets/bottom_menu.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:phrasal_verbs/screens/result_screen.dart';
import 'dart:math';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'dart:async';
import 'package:phrasal_verbs/model/data_provider.dart';
import 'package:provider/provider.dart';
import 'package:animated_background/animated_background.dart';

class MemorizingScreen extends StatefulWidget {
  final Category category;
  final int index;

  final bool general;
  MemorizingScreen(this.general, {this.index, this.category});
  @override
  _MemorizingScreenState createState() => _MemorizingScreenState();
}

class _MemorizingScreenState extends State<MemorizingScreen>
    with TickerProviderStateMixin {
  int score = 0;
  Random random = Random();
  List<PhrasalVerb> correctAnswers;
  GameModel model = GameModel();
  List<String> options = [];
  var bank = PhrasalVerbsBank();

  void createOptions() {
    options.clear();
    boolList.clear();
    while (boolList.length < 7) {
      boolList.add(false);
    }

    //Adding wrong answers
    while (options.length < 3) {
      options.add(
          bank.shortenVerb(bank.verbs[random.nextInt(bank.verbs.length - 1)]));
    }

    //Adding correct answers
    options.add(bank.shortenVerb(correctAnswers[level - 1]));
    options.add(bank.shortenPreposition(correctAnswers[level - 1]));

    if (threeWordsPV) {
      options.add(bank.shortenPreposition2(correctAnswers[level - 1]));
    }

    options.shuffle();
  }

//  AnimationController _sunController;
//  Animation<double> animation;

  AnimationController controller;
  AnimationController progressController;
  Animation progressAnimation;

  bool reward1 = true;
  bool reward2 = true;
  bool reward3 = true;
  int reward = 3;

  double val;

  @override
  void initState() {
    controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    progressController = AnimationController(
        duration: Duration(seconds: widget.general ? 10 : 15), vsync: this);
    progressAnimation =
        CurvedAnimation(parent: progressController, curve: Curves.linear);
    progressAnimation.addListener(() {
      setState(() {
        val = progressAnimation.value;
//        if (progressController.value < (1 / 3)) {
//          reward1 = false;
//        } else if (progressController.value < (1 / 2)) {
//          reward2 = false;
//        } else if (progressController.value < (2 / 3)) {
//          reward3 = false;
//        }
        if (progressAnimation.value < (1 / 4)) {
          reward1 = false;
          reward = 0;
        } else if (progressAnimation.value < (1 / 2)) {
          reward2 = false;
          reward = 1;
        } else if (progressAnimation.value < (3 / 4)) {
          reward3 = false;
          reward = 2;
        } else {
          reward = 3;
          reward1 = true;
          reward2 = true;
          reward3 = true;
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

    if (widget.general) {
      correctAnswers = bank.optionsListGeneral(10);
    } else {
      correctAnswers = bank.verbsToLearn(widget.category, widget.index);
    }
    createOptions();

    super.initState();
    Provider.of<DataProvider>(context, listen: false)
        .setRightAnswers(correctAnswers[level - 1]);
  }

  int level = 1;

  PageController pageController = PageController(
    keepPage: false,
    initialPage: 0,
  );
  PageController pageControllerDescription = PageController(
    keepPage: false,
    initialPage: 0,
  );

  @override
  void dispose() {
    // TODO: implement dispose
//    _sunController.dispose();
    controller.dispose();
    pageController.dispose();
    pageControllerDescription.dispose();
    progressController.dispose();

    super.dispose();
  }

  bool get threeWordsPV => correctAnswers[level - 1].secondPreposition != null;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var width = size.width;
    var height = size.height;
    final Animation<double> offsetAnimation = Tween(begin: 0.0, end: width / 20)
        .chain(CurveTween(curve: Curves.elasticIn))
        .animate(controller)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              controller.reverse();
            }
          });
    var provider = Provider.of<DataProvider>(context);
//    Color color = provider.getCategoryColor(widget.category);
    Color color = kYellow;

    void nextPage() {
      provider.cleanAnswers();
      pageController.nextPage(
          duration: Duration(seconds: 1), curve: Curves.easeOutExpo);
    }

    double horizontalPadding = width / 30;

    return QuizScreenTemplate(
      color: color,
      general: widget.general,
      secondChild: PageView.builder(
        controller: pageControllerDescription,
        itemCount: correctAnswers.length,
        physics: NeverScrollableScrollPhysics(),
        pageSnapping: true,
        itemBuilder: (context, item) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: width / 15),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      child: Text(
                        correctAnswers[level - 1].description,
                        style: TextStyle(
                            color: kDarkBlue.withOpacity(0.8),
                            fontWeight: FontWeight.w500,
                            fontSize: height / 30),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),

                Container(
                  height: height / 12,
                  decoration: BoxDecoration(
                      color: kLDarkBlue,
                      borderRadius: BorderRadius.circular(width / 20)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      WordCellGetter(
                        accepted: provider.verbAnswered,
                        color: color,
                        animation: offsetAnimation,
                        data: provider.chosenVerb,
                      ),
                      WordCellGetter(
                        accepted: provider.prepAnswered1,
                        color: color,
                        data: provider.chosenPrep,
                        animation: offsetAnimation,
                      ),
                      threeWordsPV
                          ? WordCellGetter(
                              accepted: provider.prepAnswered2,
                              color: color,
                              data: provider.chosenPrep2,
                              animation: offsetAnimation,
                            )
                          : Container()
                    ],
                  ),
                ),
                SizedBox(
                  height: height / 40,
                ),
              ],
            ),
          );
        },
      ),
      thirdChild: PageView.builder(
        controller: pageController,
        itemCount: correctAnswers.length + 1,
        physics: NeverScrollableScrollPhysics(),
        pageSnapping: true,
        itemBuilder: (context, item) {
          return Container(
              decoration: BoxDecoration(
              ),
              padding: EdgeInsets.symmetric(
                horizontal: width / 20,
              ),
              child: GridView.builder(
                padding: EdgeInsets.only(top: height / 100),
                itemCount: options.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: height / 190 * size.aspectRatio,
                  crossAxisCount: 2,
                ),
                itemBuilder: (context, i) {
                  return WordCellAnswer(
                    accepted: boolList[i],
                    data: options[i],
                    color: color,
                    onTap: () {
                      setState(() {
                        boolList[i] = true;
                      });
                    },
                    onFailed: () {
                      controller.forward();
                    },
                    callback: () async {
                      setState(() {
                        score = score + reward;
                      });

                      print(level);
                      if (level == correctAnswers.length) {
                        if (!widget.general) {
                          if (await provider.getScoreForLevel(
                                  widget.category, widget.index) <
                              score) {
                            provider
                                .saveScore(widget.category, widget.index, score)
                                .then((e) {
                              print('COMPLETED SAVING');
                            });
                          }
                        }

                        provider.navigateTo(
                          ResultScreen(
                            general: widget.general,
                            score: score,
                            category: widget.category,
                            newLesson: score == 15,
                            widgetToGoBack: this.widget,
                          ),
                          context,
                        );
                        provider.cleanAnswers();
                      } else {
                        setState(() {
                          level++;
                        });
                        provider.cleanAnswers();
                        pageControllerDescription.nextPage(
                            duration: Duration(seconds: 1),
                            curve: Curves.easeOutExpo);
                        pageController.nextPage(
                            duration: Duration(seconds: 1),
                            curve: Curves.easeOutExpo);
                        provider.setRightAnswers(correctAnswers[level - 1]);
                        setState(() {
                          createOptions();
                        });

                        await progressController.reverse(from: 1);
                        setState(() {});
                      }
                    },
                  );
                },
              ));
        },
      ),
      reward1: reward1,
      reward2: reward2,
      reward3: reward3,
      progressValue: progressAnimation.value,
      score: score,
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

class WordCellAnswer extends StatelessWidget {
  const WordCellAnswer(
      {Key key,
      this.onTap,
      this.data,
      this.color,
      this.onFailed,
      this.accepted,
      this.callback})
      : super(key: key);
  final String data;
  final bool accepted;
  final Function callback;
  final Function onTap;
  final Function onFailed;
  final Color color;

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<DataProvider>(context);
    var size = MediaQuery.of(context).size;
    var width = size.width;
    var height = size.height;

    return AnimatedSwitcher(
      duration: Duration(milliseconds: 100),
      child: !accepted
          ? SpringButton(
              SpringButtonType.OnlyScale,
              WordCellContent(
                data: data,
                isGetter: false,
                color: color,
              ),
              alignment: Alignment.center,
              scaleCoefficient: 0.9,
              onTap: () {
                if (provider.answer(data)) {
                  onTap();
                } else {
                  onFailed();
                }
                Future.delayed(Duration(seconds: 1), () {
                  if (provider.completed()) {
                    callback();
                  }
                });
              },
            )
          : Container(),
    );
  }
}

class WordCellGetter extends StatefulWidget {
  const WordCellGetter({
    Key key,
    this.data,
    this.animation,
    this.accepted,
    this.color,
  }) : super(key: key);
  final String data;
  final bool accepted;
  final Animation<double> animation;
  final Color color;

  @override
  _WordCellGetterState createState() => _WordCellGetterState();
}

class _WordCellGetterState extends State<WordCellGetter> {
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<DataProvider>(context);
    var size = MediaQuery.of(context).size;
    var width = size.width;
    var height = size.height;
    return AnimatedBuilder(
        animation: widget.animation,
        builder: (buildContext, child) {
          return Transform.rotate(
            angle: widget.animation.value / 50,
            child: Container(
              child: AnimatedSwitcher(
                duration: Duration(milliseconds: 100),
                child: widget.accepted
                    ? WordCellContent(
                        isGetter: true, data: widget.data, color: widget.color)
                    : Container(),
              ),
            ),
          );
        });
  }
}

class WordCellContent extends StatelessWidget {
  const WordCellContent({Key key, this.color, this.data, this.isGetter})
      : super(key: key);
  final String data;
  final isGetter;
  final Color color;

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<DataProvider>(context);
    var size = MediaQuery.of(context).size;
    var width = size.width;
    var height = size.height;

    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: isGetter ? width / 40 : width / 20,
          vertical: height / 80),
      decoration: BoxDecoration(
          color: !isGetter ? color : Colors.transparent,
          borderRadius: BorderRadius.circular(width)),
      child: Text(
        data,
        style: TextStyle(
            color: isGetter ? kDarkBlue : Colors.white,
            fontSize: width / 13,
            fontWeight: FontWeight.w800),
      ),
    );
  }
}
