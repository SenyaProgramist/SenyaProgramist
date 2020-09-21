import 'package:flutter/material.dart';
import 'package:phrasal_verbs/const.dart';
import 'package:phrasal_verbs/animations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:phrasal_verbs/screens/memorizing_screen.dart';
import 'package:phrasal_verbs/screens/quiz_screen.dart';
import 'package:phrasal_verbs/model/data_provider.dart';
import 'package:provider/provider.dart';
import 'package:page_transition/page_transition.dart';

class GamesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var width = size.width;
    var height = size.height;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
          Color(0xFFec008c),
          Color(0xFFfc6767),
        ], begin: Alignment.bottomLeft, end: Alignment.topRight),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          FadeIn(
            begin: -width / 100,
            delay: 0.5,
            child: Container(
              padding: EdgeInsets.only(
                left: width / 20,
                right: width / 20,
                top: height / 18,
                bottom: height / 50,
              ),
              decoration: BoxDecoration(
//                                borderRadius: BorderRadius.circular(width),
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(width / 15)),
                  color: Colors.white),
              child: Text(
                'Games',
                style: TextStyle(
                    color: Color(0xFFec008c),
                    fontSize: width / 12,
                    fontWeight: FontWeight.w800),
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: height/25,),
                GameCard(
                  label: 'QUIZ',
                  iconData: 'qa',
                  delay: 1,
                  navigateTo: QuizScreen(true),
                ),
                GameCard(
                  label: 'PUZZLE',
                  iconData: 'fit',
                  delay: 1.5,
                  navigateTo: MemorizingScreen(true),
                ),
                GameCard(
                  iconData: 'ttt',
                  label: 'TIC TAC TOE',
                  delay: 2,
                  comingSoon: true,
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }
}

class GameCard extends StatelessWidget {
  const GameCard(
      {this.label,
      this.iconData,
      this.navigateTo,
      this.delay,
      this.color1 = kYellow,
      this.color2 = kYellow,
      this.left,
      this.comingSoon = false});

  final String label;
  final double delay;
  final Widget left;
  final Color color1;
  final Color color2;
  final String iconData;
  final Widget navigateTo;
  final bool comingSoon;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var width = size.width;
    var provider = Provider.of<DataProvider>(context);
    var height = size.height;
    return SizeAnimation(
      delay: delay,

      end: 1,
      child: InkWell(
        onTap: () {
          if (!comingSoon) {
            provider.vibrate(2);
            provider.navigateTo(navigateTo, context,
                );
          }
        },
        child: Container(
          height: height / 6,
          margin: EdgeInsets.all(width / 25),
          decoration: BoxDecoration(
              color: Colors.orange,
              borderRadius: BorderRadius.circular(width / 15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  spreadRadius: 2,
                  offset: Offset(0, 5),
                  blurRadius: 10,
                )
              ],
              gradient: LinearGradient(colors: [
                color1,
                color2,
              ], begin: Alignment.bottomLeft, end: Alignment.topRight)),
          child: Stack(children: [
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                padding: EdgeInsets.only(left: width / 20, top: height / 50),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      label,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: width / 12),
                    ),
                    SizedBox(
                      height: height / 100,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: width / 30, vertical: height / 100),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(width / 15),
                        color: Colors.white,
                      ),
                      child: Text(
                        comingSoon ? 'COMING SOON' : 'PLAY',
                        style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.w800,
                            fontSize: width / 20),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Positioned(
                bottom: -height / 50,
                right: -width / 20,
                child: SvgPicture.asset(
                  'assets/$iconData.svg',
                  color: Colors.redAccent,
                  width: width / 3,
                )),
          ]),
        ),
      ),
    );
  }
}
