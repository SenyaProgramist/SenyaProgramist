import 'package:flutter/material.dart';
import 'package:phrasal_verbs/model/data_provider.dart';
import 'package:provider/provider.dart';
import 'package:linear_gradient/linear_gradient.dart';
import 'package:phrasal_verbs/model/phrasal_verb.dart';
import 'package:phrasal_verbs/model/verbs_bank.dart';
import 'package:phrasal_verbs/model/shared_prefs.dart';

class Gradients extends StatefulWidget {
  @override
  _GradientsState createState() => _GradientsState();
}

class _GradientsState extends State<Gradients> {
  List<int> gradients = [];

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<DataProvider>(context);
    return Container(
      child: Scaffold(
        body: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Expanded(
              child: ListView.builder(itemBuilder: (c, i) {
                return GestureDetector(
                  onTap: () {

//                    setState(() {
//                      gradients.add(i);
//                      gradients.forEach((e) {
//                        print(e);
//                      });
//
//                  });

//                    for (var verb in bank) {
//                      if (bank
//                              .where((e) => e.description == verb.description)
//                              .toList()
//                              .length >
//                          1) {
//                        print(PhrasalVerbsBank().nameOfPhrasalVerb(verb));
//                      }
//                    }
                  },
                  child: Container(
                    height: 100,
                    width: 100,
                    child: Icon(
                      Icons.print,

                      color: Colors.white,
                    ),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradientStyle.linearGradient(
                            orientation: 1, gradientType: i)),
                  ),
                );
              }),
            ),
            Container(
              width: 200,
              child: ListView.builder(
                  itemCount: gradients.length,
                  itemBuilder: (c, i) {
                    return GestureDetector(
                      onTap: () {
                        print(gradients[i]);
                      },
                      child: Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradientStyle.linearGradient(
                                orientation: 2, gradientType: gradients[i])),
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
