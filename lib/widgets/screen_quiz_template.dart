import 'package:flutter/material.dart';
import 'package:phrasal_verbs/const.dart';
import 'package:phrasal_verbs/widgets/screen_quiz_template.dart';
import 'package:phrasal_verbs/widgets/linear_progress_indicator.dart';
import 'package:provider/provider.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:phrasal_verbs/widgets/bottom_menu.dart';
import 'package:phrasal_verbs/widgets/progress_trophy.dart';
import 'package:phrasal_verbs/model/data_provider.dart';

class QuizScreenTemplate extends StatefulWidget {
  final Widget secondChild;
  final Widget thirdChild;
  final int score;
  final int thirdChildFlex;
  final double progressValue;
  final bool reward1;
  final bool reward2;
  final bool reward3;
  final bool general;
  final Color color;

  QuizScreenTemplate(
      {Key key,
      this.secondChild,
      this.general,
        this.thirdChildFlex = 2,
      this.thirdChild,
      this.score,
      this.progressValue,
      this.reward1 = true,
      this.reward2 = true,
      this.reward3 = true,
      this.color})
      : super(key: key);

  @override
  _QuizScreenTemplateState createState() => _QuizScreenTemplateState();
}

class _QuizScreenTemplateState extends State<QuizScreenTemplate> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var width = size.width;
    var height = size.height;
    var provider = Provider.of<DataProvider>(context);
    double horizontalPadding = width / 30;
    return Scaffold(
      body: Container(
        color: Color(0xFFE8ECF1),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  color: kLDarkBlue,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(width / 10),
                      bottomRight: Radius.circular(width / 10))),
              padding: EdgeInsets.only(bottom: height / 30),
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(left: width / 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        GestureDetector(
                          child: Container(
                            margin: EdgeInsets.only(top: height / 30),
                            child: Icon(
                              Icons.close,
                              color: kDarkBlue,
                              size: width / 12,
                            ),
                          ),
                          onTap: () {
                            Navigator.of(context)
                                .popUntil((route) => route.isFirst);

                            provider.cleanAnswers();
                          },
                        ),
//                Center(
//                  child: Text(
//                    'Description',
//                    style: TextStyle(
//                        color: Colors.white,
//                        fontWeight: FontWeight.w600,
//                        fontSize: width / 15),
//                  ),
//                ),
                        CornerSheet(
                          horizontalPadding: width / 15,
height: height/9,
                          isRight: false,
                          child: Row(
                            children: <Widget>[
                              Text(
                                '${widget.score}/${widget.general ? '30' : '15'}',
                                style: TextStyle(
                                    color: kDarkBlue,
                                    fontSize: width / 20,
                                    letterSpacing: 1,
                                    fontWeight: FontWeight.w700),
                              ),
                              SizedBox(
                                width: width / 50,
                              ),
                              Icon(
                                MdiIcons.trophy,
                                color: kYellow,
                                size: width / 15,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: height / 30,
                  ),
                  Container(
                    child: Column(
                      children: <Widget>[
                        ScoreProgressIndicator(
                          horizontalPadding: horizontalPadding,
                          color: widget.color,
                          percent: widget.progressValue,
                        ),
                        SizedBox(
                          height: height / 50,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: width / 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              ProgressSection(
                                active: widget.reward1,
                              ),
                              ProgressSection(
                                active: widget.reward2,
                              ),
                              ProgressSection(
                                active: widget.reward3,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Container(
                margin: EdgeInsets.only(top: height / 30),
                decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(width / 10),
                        bottomLeft: Radius.circular(width / 10))),
                child: widget.secondChild,
              ),
            ),
            Expanded(
              flex: widget.thirdChildFlex,
                child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(width / 10),
                            topRight: Radius.circular(width / 10))),
                    child: widget.thirdChild)),
          ],
        ),
      ),
    );
  }
}
