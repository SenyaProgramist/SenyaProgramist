import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:phrasal_verbs/const.dart';

class ScoreProgressIndicator extends StatelessWidget {
  final double horizontalPadding;
  final double percent;
  final bool isResult;
  final Color color;

  ScoreProgressIndicator(
      {this.horizontalPadding,
      this.color,
      this.percent,
      this.isResult = false});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var width = size.width;
    var height = size.height;
    return Container(
      decoration: BoxDecoration(
          boxShadow: isResult
              ? [
                  BoxShadow(
                      color: Colors.yellow.shade600.withOpacity(0.3),
                      spreadRadius: 1,
                      blurRadius: 10)
                ]
              : null),
      child: LinearPercentIndicator(
        alignment: MainAxisAlignment.center,
        backgroundColor: isResult ? Colors.white : Colors.black12,
        animateFromLastPercent: true,
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        animation: true,
        lineHeight: height / 80,

        animationDuration: 300,
        percent: percent,
        linearGradient: LinearGradient(colors: [
          Colors.yellow.shade600,
          Colors.orangeAccent,
        ]),

        linearStrokeCap: LinearStrokeCap.roundAll,
//      progressColor: Colors.orangeAccent,
      ),
    );
  }
}
