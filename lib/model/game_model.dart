import 'package:flutter/material.dart';

class GameModel {
  Curve curve = Curves.easeOutExpo;
  Duration duration = Duration(seconds: 1);
  PageController pageController = PageController(
    keepPage: false,
    initialPage: 1,
  );
  PageController pageControllerDescription = PageController(
    keepPage: false,
    initialPage: 1,
  );
  void nextPage() {
    pageController.nextPage(duration: duration, curve: curve);
  }
}
