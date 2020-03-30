import 'package:flutter/material.dart';
import 'package:phrasal_verbs/model/adjust_screen.dart';
import 'package:phrasal_verbs/model/phrasal_verb.dart';
import 'package:phrasal_verbs/widgets/training_button.dart';
import 'package:phrasal_verbs/model/verbs_bank.dart';
import 'package:page_transition/page_transition.dart';
import 'package:phrasal_verbs/const.dart';
import 'package:linear_gradient/linear_gradient.dart';


class DailyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var width = size.width;
    var height = size.height;
    return Scaffold(
        backgroundColor: Colors.white,
        body: AllLevels(
          categories: PhrasalVerbsBank().levels,
          levels: 12,
        ));
  }



  //  Container(
//              height: height / 10,
//              width: width,
//              decoration: BoxDecoration(
//                  color: kDarkBlue,
//                  borderRadius: BorderRadius.only(
//                      bottomLeft: Radius.circular(width),
//                      bottomRight: Radius.circular(width))),
//              child: Center(
//                child: NumberSlideAnimation(
//                  number: "33",
//                  duration: const Duration(seconds: 2),
//                  curve: Curves.bounceIn,
//                  textStyle:
//                      TextStyle(fontSize: width/10, fontWeight: FontWeight.bold, color: Colors.white),
//                ),
//              ),
//            ),


//  List<Widget> buttonCategory() {
//    List<PhrasalVerb> bank = PhrasalVerbsBank().verbs;
//    List<Category> categories = [];
//    List<Widget> res = [];
//    for (var verb in bank) {
//      if (!categories.contains(verb.category)) {
//        categories.add(verb.category);
//      }
//    }
//    for (var cat in categories) {
//      res.add(TrainingButton(
//        index: 1,
//        category: cat,
//      ));
//    }
//    return res;
//  }
}
