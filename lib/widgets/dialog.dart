import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:phrasal_verbs/const.dart';
import 'package:get_it/get_it.dart';

class Confetti extends StatefulWidget {

  @override
  _ConfettiState createState() => _ConfettiState();
}

class _ConfettiState extends State<Confetti> {
  ConfettiController confettiController;

  @override
  void initState() {
    confettiController = ConfettiController(duration: Duration(seconds: 2));

      confettiController.play();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var width = size.width;
    var height = size.height;
    return ConfettiWidget(
        colors: [kYellow, kRed],
        blastDirection: -1.57,
        maxBlastForce: 30,
        minimumSize: Size(width / 20, height / 20),
        maximumSize: Size(width / 10, height / 15),
        numberOfParticles: 3,
        confettiController: confettiController);
  }
}
