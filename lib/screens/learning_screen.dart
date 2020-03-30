import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:phrasal_verbs/model/phrasal_verb.dart';
import 'package:provider/provider.dart';
import 'package:phrasal_verbs/widgets/like_button.dart';
import 'package:phrasal_verbs/model/data_provider.dart';
import 'package:phrasal_verbs/model/verbs_bank.dart';
import 'package:phrasal_verbs/const.dart';
import 'package:phrasal_verbs/screens/memorizing_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:phrasal_verbs/widgets/bottom_menu.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:like_button/like_button.dart';
import 'package:phrasal_verbs/model/data_provider.dart';
import 'package:provider/provider.dart';
import 'package:phrasal_verbs/screens/quiz_screen.dart';
import 'package:phrasal_verbs/widgets/content.dart';
import 'package:animated_background/animated_background.dart';
import 'package:simple_animations/simple_animations.dart';

import 'package:phrasal_verbs/animations.dart';

class LearningScreen extends StatefulWidget {
  final Category category;
  final int index;
  final String heroTag;
  LearningScreen({this.category, this.index, this.heroTag});
  @override
  _LearningScreenState createState() => _LearningScreenState();
}

class _LearningScreenState extends State<LearningScreen>
    with TickerProviderStateMixin {
  SwiperController swiperController;
  List<PhrasalVerb> resVerbs;
  List<String> isLiked = [];
  bool active = false;
  AnimationController rubberController;
  Animation<double> rubberAnimation;

  void initState() {
    resVerbs = PhrasalVerbsBank().verbsToLearn(widget.category, widget.index);
    // TODO: implement initState

    swiperController = SwiperController();
    rubberController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
    rubberAnimation =
        CurvedAnimation(parent: rubberController, curve: Curves.bounceOut);
    rubberController.addListener(() {
      setState(() {
        print(rubberAnimation);
      });
    });
    Future.delayed(
      Duration(milliseconds: 500),
    ).then((e) {
      rubberController.forward();
    });

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    swiperController.dispose();
    rubberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var provider = Provider.of<DataProvider>(context);
    Color color = kYellow;
    var width = size.width;
    var height = size.height;
    return Scaffold(
      body: Container(
        color: kDarkBlue.withOpacity(0.2),
        child: Stack(
          alignment: Alignment.topCenter,
          children: <Widget>[
//            SizedBox(
//              height: height / 10,
//            ),

            Container(
              padding: EdgeInsets.only(right: width / 20, bottom: height / 10),
              decoration: BoxDecoration(
                  color: Color(0xFFF0F5F5),
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(width / 10),
                    bottomLeft: Radius.circular(width / 10),
                  )),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Hero(
                    tag: widget.heroTag,
                    child: CornerSheet(
                        isRight: true,
                        color: color,
                        horizontalPadding: width / 10,
                        child: Icon(
                          provider.getCategoryIcon(widget.category),
                          color: Colors.white,
                          size: width / 9,
                        )),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: EdgeInsets.all(width / 50),
                      margin: EdgeInsets.only(top: height / 30),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: Colors.white),
                      child: Icon(
                        Icons.close,
                        color: kDarkBlue,
                        size: width / 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            FadeIn(
              delay: 1,
              begin: width / 20,
              child: Container(
                height: height / 1.6,
                margin: EdgeInsets.only(top: height / 6),
                child: Swiper(
                  controller: swiperController,
                  scrollDirection: Axis.horizontal,
                  onIndexChanged: (index) {
                    if (index == 4) {
                      setState(() {
                        active = true;
                      });
                    }
                  },
                  loop: false,
                  itemCount: 5,
                  viewportFraction: width / 450, //amount of screen taken
                  scale: width / 500, //difference in size
                  itemBuilder: (BuildContext context, int index) {
//              PhrasalVerb verb = widget.days[index];
//              bool isOne = widget.days.length <= 1 ? true : false;
                    return PhrasalVerbCard(
                      pV: PhrasalVerbsBank()
                          .verbsToLearn(widget.category, widget.index)[index],
//                    isLiked: isLiked.contains(PhrasalVerbsBank()
//                        .verbsToLearn(widget.category, widget.index)[index]
//                        .description),
//                    callback: (bool) async {
//                      await Future.delayed(Duration(seconds: 1));
////                      setState(() {
////                        isLiked.add(PhrasalVerbsBank()
////                            .verbsToLearn(widget.category, widget.index)[index]
////                            .description);
////                      });
//                      return true;
//                    },
                    );
                  },
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: rubberAnimation.value * height / 5,
                child: BottomMenu(
                  child: GestureDetector(
                    onTap: () {
                      provider.saveFromTempLikedVerbs();
                      if (active) {
                        provider.navigateTo(
                            MemorizingScreen(
                              false,
                              category: widget.category,
                              index: widget.index,
                            ),
                            context,
                        );
                      } else {
                        swiperController.next();
                      }
                    },
                    child: AnimatedContainer(
                      margin: EdgeInsets.symmetric(horizontal: width / 15),
                      duration: Duration(milliseconds: 200),
                      child: Center(
                        child: Text(
                          active ? 'START LEARNING' : 'NEXT',
                          style: TextStyle(
                              color: active ? Colors.white : color,
                              fontWeight: FontWeight.w900,
                              fontSize: width / 20),
                        ),
                      ),
                      decoration: BoxDecoration(
                          color: active ? color : Colors.transparent,
                          border: Border.all(color: color, width: width / 100),
                          boxShadow: active
                              ? [
                                  BoxShadow(
                                      color: color.withOpacity(0.5),
                                      offset: Offset(0, 3),
                                      blurRadius: 10,
                                      spreadRadius: 2),
                                ]
                              : null,
                          borderRadius: BorderRadius.circular(width)),
                      padding: EdgeInsets.symmetric(vertical: height / 50),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PhrasalVerbCard extends StatelessWidget {
  final PhrasalVerb pV;
  final bool isLiked;
  final Future<bool> Function(bool) callback;
  PhrasalVerbCard({this.pV, this.isLiked = false, this.callback});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    var provider = Provider.of<DataProvider>(context);
    var screenSize = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () async {
        await provider.vibrate(1);
      },
      child: Container(
        padding: EdgeInsets.only(
//          left: width / 50,
//          right: width / 20,
          top: height / 100,
          bottom: height / 15,
        ),
        child: Container(
          //content padding
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(width / 20),
              boxShadow: [
                BoxShadow(
                    offset: Offset(0, 10),
                    blurRadius: 10,
                    spreadRadius: 1,
                    color: kDarkBlue.withOpacity(0.1))
              ]),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(screenSize.width / 20),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.transparent),
                        borderRadius: BorderRadius.all(
                          Radius.circular(screenSize.width / 20),
                        )),
                    child: Text(
                      provider.nameOfPhrasalVerb(pV),
                      style: TextStyle(
                          fontSize: width / 12,
                          fontWeight: FontWeight.w800,
                          letterSpacing: width / 1000,
                          color: kDarkBlue),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                      right: width / 20,
                    ),
                    child: LikeStarButton(
                      phrasalVerb: pV,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: height / 40,
              ),
              PhrasalVerbMenu(
                phrasalVerb: pV,
                color: kDarkBlue,
              )
            ],
          ),
        ),
      ),
    );
  }
}

//AnimatedBackground(
//behaviour: RandomParticleBehaviour(
//options: ParticleOptions(
//spawnMaxSpeed: 50,
//spawnMinSpeed: 20,
//spawnMinRadius: 10,
//spawnMaxRadius: 20,
//baseColor: color.withOpacity(0.1),
//particleCount: 10)),
//vsync: this,
