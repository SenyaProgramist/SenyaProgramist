import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:phrasal_verbs/model/phrasal_verb.dart';
import 'package:provider/provider.dart';
import 'package:phrasal_verbs/model/data_provider.dart';
import 'package:phrasal_verbs/model/verbs_bank.dart';
import 'package:auto_size_text/auto_size_text.dart';

import 'package:phrasal_verbs/const.dart';
import 'package:phrasal_verbs/screens/result_screen.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'dart:math';
import 'package:phrasal_verbs/model/data_provider.dart';
import 'package:provider/provider.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:animated_background/animated_background.dart';
import 'package:phrasal_verbs/widgets/screen_quiz_template.dart';

class QuizScreen extends StatefulWidget {
  final Category category;
  final int index;
  final bool general;
  QuizScreen(this.general, {this.category, this.index});
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen>
    with SingleTickerProviderStateMixin {
  int score = 0;
  bool verbAccepted = false;
  bool freeze = false;
  bool prepAccepted = false;
  PageController pageController = PageController(
    keepPage: false,
    initialPage: 0,
  );
  PageController pageControllerDescription = PageController(
    keepPage: false,
    initialPage: 0,
  );
  Random random = Random();
  var bank = PhrasalVerbsBank();
  List<PhrasalVerb> correctAnswers;
  List<PhrasalVerb> options = [];
  String givenAnswer;
  int level = 1;
  Curve curve = Curves.easeOutExpo;
  Duration duration = Duration(seconds: 1);
  String correctAnswer;
  AnimationController progressController;
  Animation progressAnimation;

  bool reward1 = true;
  bool reward2 = true;
  bool reward3 = true;
  int reward = 3;

  double val;
  @override
  void initState() {
    progressController =
        AnimationController(duration: Duration(seconds: 10), vsync: this);
    progressAnimation =
        CurvedAnimation(parent: progressController, curve: Curves.decelerate);
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
    // TODO: implement initState
    if (widget.general) {
      correctAnswers = bank.optionsListGeneral(10);
    } else {
      correctAnswers = bank.verbsToLearn(widget.category, widget.index);
    }

    createOptions(1);

    super.initState();
  }

  void createOptions(int level) {
    options.clear();
    colors = [
      kYellow,
      kYellow,
      kYellow,
      kYellow,
    ];

    for (var i = 0; i < 3; i++) {
      var pV;
      if (widget.general) {
        pV = bank.verbs[random.nextInt(bank.verbs.length - 1)];
      } else {
        pV =
            bank.verbsToLearn(widget.category, widget.index)[random.nextInt(4)];
      }
      options.add(pV);
    }
    options.add(correctAnswers[level - 1]);

    options.shuffle();
  }

  int rightAnswer(int level) {
    return options.indexWhere((option) =>
        option.description == correctAnswers[level - 1].description);
  }

  List<Color> colors = [
    kYellow,
    kYellow,
    kYellow,
    kYellow,
  ];
  double progress = 0;
  List<PhrasalVerb> mistake = [];
  Color rightColor = Colors.greenAccent.shade700.withOpacity(0.8);
      Color wrongColor = kRed.withOpacity(0.9);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var provider = Provider.of<DataProvider>(context);

    var width = size.width;
    var height = size.height;
    return QuizScreenTemplate(
      color: kYellow,
      general: widget.general,
      secondChild: PageView.builder(
        controller: pageControllerDescription,
        itemCount: correctAnswers.length + 1,
        physics: NeverScrollableScrollPhysics(),
        pageSnapping: true,
        itemBuilder: (context, item) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: width / 15),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Container(
                    child: Text(
                      correctAnswers[level - 1].description,
                      style: TextStyle(
                        color: kDarkBlue.withOpacity(0.8),
                        fontSize: height / 30,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
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
      thirdChild: Container(
          child: PageView.builder(
        controller: pageController,
        itemCount: correctAnswers.length,
        physics: NeverScrollableScrollPhysics(),
        pageSnapping: true,
        itemBuilder: (context, item) {
          return ListView.builder(
            padding: EdgeInsets.only(top: height / 50),
            physics: NeverScrollableScrollPhysics(),
            itemCount: 4,
            itemBuilder: (context, i) {
              return OptionAnswer(
                accepted: false,
                color: colors[i],
                data: provider.nameOfPhrasalVerb(options[i]),
                label: getLabel(i + 1),
                onTap: () async {
                  provider.vibrate(2);
                  progressController.stop();
                  if (!freeze) {
                    freeze = true;
                    setState(() {
                      colors[i] =wrongColor;
                    });
                    await Future.delayed(Duration(seconds: 1), () {});
                    setState(() {
                      colors[rightAnswer(level)] =
                          rightColor;
                      if (i == rightAnswer(level)) {
                        provider.vibrate(3);
                        score = score + reward;
                      } else {
                        provider.vibrate(5);
                        mistake.add(correctAnswers[level - 1]);
                      }
                    });
                    await Future.delayed(Duration(milliseconds: 750), () {});
                    if (level == correctAnswers.length) {
                      provider.navigateTo(
                        ResultScreen(
                          general: false,
                          score: score,
                          right: rightColor,
                          wrong: wrongColor,
                          category: widget.category,
                          newLesson: score == 15,
                          widgetToGoBack: this.widget,
                          verbs: correctAnswers,mistakes: mistake,
                        ),
                        context,
                      );
                    } else {
                      setState(() {
                        level++;
                        createOptions(level);
                      });
                      pageController.nextPage(duration: duration, curve: curve);
                      pageControllerDescription.nextPage(
                          duration: duration, curve: curve);
                      freeze = false;
                    }
                  }
                  await progressController.reverse(from: 1);
                },
              );
            },
          );
        },
      )),
      thirdChildFlex: 3,
      reward1: reward1,
      reward2: reward2,
      reward3: reward3,
      progressValue: progressAnimation.value,
      score: score,
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose

    progressController.dispose();
    pageController.dispose();
    pageControllerDescription.dispose();
    super.dispose();
  }
}



getLabel(int i) {
  switch (i) {
    case 1:
      return 'A';
    case 2:
      return 'B';

    case 3:
      return 'C';

    case 4:
      return 'D';

    case 5:
      return 'E';
  }
}

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
  final String data;
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
          padding: EdgeInsets.symmetric(vertical: height / 60),
          margin: EdgeInsets.symmetric(
              vertical: height / 150, horizontal: width / 20),
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
                data,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: width / 13,
                    fontWeight: FontWeight.w800),
              ),
            ],
          )),
    );
  }
}
