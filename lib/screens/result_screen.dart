import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:phrasal_verbs/model/data_provider.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:phrasal_verbs/model/phrasal_verb.dart';
import 'package:phrasal_verbs/widgets/linear_progress_indicator.dart';
import 'package:phrasal_verbs/model/verbs_bank.dart';
import 'package:phrasal_verbs/widgets/content.dart';
import 'package:phrasal_verbs/screens/memorizing_screen.dart';
import 'package:phrasal_verbs/widgets/bottom_menu.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:phrasal_verbs/screens/daily_screen.dart';
import 'package:phrasal_verbs/navigation_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:phrasal_verbs/model/data_provider.dart';
import 'package:confetti/confetti.dart';
import 'package:phrasal_verbs/const.dart';

class ResultScreen extends StatefulWidget {
  final int score;
  final bool newLesson;
  final Category category;
  final int index;
  final Widget widgetToGoBack;

  final bool general;
  final List<PhrasalVerb> mistakes;
  final List<PhrasalVerb> verbs;
  final Color right;
  final Color wrong;

  const ResultScreen(
      {Key key,
      this.index = 2,
      this.score,
      this.general = false,
      this.right,
      this.wrong,
      this.verbs = const [],
      this.widgetToGoBack,
      this.newLesson,
      this.mistakes = const [],
      this.category = Category.money})
      : super(key: key);

  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen>
    with TickerProviderStateMixin {
  AnimationController trophyController;
  Animation trophyAnimation;
  Animation bottomAnimation;
  AnimationController progressController;
  Animation progressAnimation;
  ConfettiController confettiController;

  @override
  void initState() {
    confettiController = ConfettiController(duration: Duration(seconds: 2));

    // TODO: implement initState
    trophyController =
        AnimationController(duration: Duration(seconds: 2), vsync: this);
    progressController = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
      upperBound: widget.score / 15,
      lowerBound: 0,
    );
    trophyAnimation =
        CurvedAnimation(parent: trophyController, curve: Curves.elasticInOut);
    bottomAnimation =
        CurvedAnimation(parent: trophyController, curve: Curves.easeOutCirc);
    progressAnimation =
        CurvedAnimation(parent: progressController, curve: Curves.decelerate);
    trophyController.addListener(() {
      setState(() {
        trophyController.toString();
        trophyAnimation.toString();
      });
    });
    progressController.addListener(() {
      setState(() {
        print(progressAnimation.value);
        progressController.value.toString();
        progressAnimation.toString();
        if (progressController.isCompleted) {
          if (widget.score == 15 && !widget.general) {
            confettiController.play();
          }
        }
      });
    });

    super.initState();
    trophyController.forward();
    progressController.forward();
  }

  Container _listWrongAnswer(PhrasalVerb verb) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      child: PhrasalVerbContent(
        reverse: true,
        title: PhrasalVerbsBank().nameOfPhrasalVerb(verb),
        color: widget.mistakes.contains(verb) ? widget.right : widget.wrong,
        content: verb.description,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var width = size.width;
    var provider = Provider.of<DataProvider>(context);
    var height = size.height;
    Color color = kYellow;
    return Scaffold(
      backgroundColor: kLDarkBlue,
      body: Container(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            ListView(
              padding: EdgeInsets.only(bottom: height / 4),
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      height: height / 7,
                    ),
                    Text(
                      'MEMORIZATION',
                      style: TextStyle(
                          color: kDarkBlue,
                          fontSize: width / 10,
                          fontWeight: FontWeight.w900),
                    ),
                    SizedBox(
                      height: height / 7,
                    ),
                    Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        Align(
                          alignment: Alignment.center,
                          child: ConfettiWidget(
                              colors: [
                                kYellow,
                                Colors.orange,
                                Colors.deepOrangeAccent
                              ],
                              blastDirection: -1.57,
                              maxBlastForce: 15,
                              minimumSize: Size(width / 20, height / 20),
                              maximumSize: Size(width / 10, height / 15),
                              numberOfParticles: 6,
                              confettiController: confettiController),
                        ),
                        Stack(
                          alignment: Alignment.center,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.all(width / 10),
                              child: Container(
                                width: width / 2,
                                height: height / 12,
                                padding: EdgeInsets.only(right: width / 20),
                                decoration: BoxDecoration(
                                    color: kDarkBlue,
                                    borderRadius:
                                        BorderRadius.circular(width / 10)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        widget.score.toString(),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: width / 8,
                                            fontWeight: FontWeight.w900),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              top: height / 50,
                              left: width / 20,
                              child: Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: width / 50),
                                child: Transform.rotate(
                                    angle: -trophyAnimation.value / 4,
//                      child: Icon(
//                        FontAwesome.trophy,
//                        color: Colors.yellow.shade600,
//                        size: width / 3.7,
//                      ),
                                    child: SvgPicture.asset(
                                      'assets/trophy.svg',
                                      width: width / 4,
                                    )),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    widget.general
                        ? Container()
                        : ScoreProgressIndicator(
                            horizontalPadding: width / 20,
                            percent: progressController.value,
                            isResult: true,
                            color: color,
                          ),
                    widget.mistakes.isNotEmpty
                        ? Align(
                            alignment: Alignment.topRight,
                            child: Container(
                              margin:
                                  EdgeInsets.only(right: width / 15, top: 0),
                              padding: EdgeInsets.all(width / 30),
                              decoration: BoxDecoration(
                                  color: Colors.deepOrangeAccent,
                                  borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(width),
                                    topLeft: Radius.circular(width),
                                    bottomLeft: Radius.circular(width),
                                  )),
                              child: Text(
                                '${widget.mistakes.length} mistakes',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize:
                                        width / 22 * trophyAnimation.value,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                          )
                        : Container(),
                    SizedBox(
                      height: height / 10,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: width / 20),
                      decoration: BoxDecoration(
                          color: kRed.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(width / 20)),
                    ),
                    SizedBox(
                      height: height / 20,
                    ),
                    widget.verbs.isNotEmpty
                        ? Container(
                            margin:
                                EdgeInsets.symmetric(horizontal: width / 20),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.circular(width / 20)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: widget.verbs
                                  .map((wV) => _listWrongAnswer(wV))
                                  .toList(),
                            ),
                          )
                        : Container(),
                  ],
                ),
              ],
            ),

//

            Container(
              height: height / 5 * bottomAnimation.value,
              child: BottomMenu(
                child: Row(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        provider.vibrate(2);
                        provider.navigateTo(
                          widget.widgetToGoBack,
                          context,
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.only(left: width / 20),
                        child: Icon(
                          Icons.replay,
                          color: color,
                          size: width / 8,
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          provider.vibrate(2);

                          int scoreLastLevel = await provider.scoreLastLevel();
                          bool newLevel = scoreLastLevel > 90 ?? false;
                          if (newLevel) {
                            await provider.unlockLevel();
                          }
                          Future.delayed(Duration(seconds: 1), () async {
                            if (newLevel) {
                              await provider.showRateDialog(
                                context,
                                true,
                              );
                            } else {
                              if (widget.score == 15 && !widget.general) {
                                await provider.showRateDialog(
                                  context,
                                  false,
                                );
                              }
                            }
                          });
                          provider.navigateTo(
                            NavigationScreen(),
                            context,
                          );
                        },
                        child: AnimatedContainer(
                          margin: EdgeInsets.symmetric(horizontal: width / 15),
                          duration: Duration(milliseconds: 200),
                          child: Center(
                            child: Text(
                              'MOVE ON',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  fontSize: width / 15),
                            ),
                          ),
                          decoration: BoxDecoration(
                              color: color,
                              boxShadow: [
                                BoxShadow(
                                    color: color.withOpacity(0.5),
                                    offset: Offset(0, 3),
                                    blurRadius: 10,
                                    spreadRadius: 2),
                              ],
                              borderRadius: BorderRadius.circular(width)),
                          padding: EdgeInsets.symmetric(vertical: height / 50),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    progressController.dispose();
    trophyController.dispose();
    super.dispose();
  }
}
