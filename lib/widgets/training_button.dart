import 'package:flutter/material.dart';
import 'package:phrasal_verbs/model/phrasal_verb.dart';
import 'package:phrasal_verbs/model/data_provider.dart';
import 'package:provider/provider.dart';
import 'package:phrasal_verbs/model/database.dart';
import 'package:phrasal_verbs/screens/learning_screen.dart';
import 'package:phrasal_verbs/animations.dart';
import 'package:phrasal_verbs/model/shared_prefs.dart';
import 'package:page_transition/page_transition.dart';
import 'package:phrasal_verbs/model/adjust_screen.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:phrasal_verbs/model/verbs_bank.dart';
import 'package:phrasal_verbs/const.dart';
import 'package:enhanced_future_builder/enhanced_future_builder.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:phrasal_verbs/model/phrasal_verb.dart';
import 'package:phrasal_verbs/animations.dart';

//
//class TrainingButton extends StatelessWidget {
//  final int index;
//  final Category category;
//
//  TrainingButton({
//    this.index,
//    this.category,
//  });
//  @override
//  Widget build(BuildContext context) {
//    var provider = Provider.of<DataProvider>(context);
//    var size = MediaQuery.of(context).size;
//    var width = size.width;
//    var height = size.height;
//    return GestureDetector(
//      onTap: () async {
//        await provider.vibrate(1);
//        provider.navigateTo(MemorizingScreen(), context);
////        subjectTapped(context, index);
////        provider.changeSubjectIndex(index);
//      },
//      child: Stack(children: [
//        Container(
//          padding: EdgeInsets.all(width / 20),
//          decoration: BoxDecoration(
//              color: Colors.orange,
//              borderRadius: BorderRadius.circular(width / 15),
//              boxShadow: [
//                BoxShadow(
//                  color: Colors.orange.withOpacity(0.2),
//                  spreadRadius: 5,
//                  blurRadius: 20,
//                )
//              ],
//              gradient: LinearGradient(colors: [
//                Colors.orange,
//                Colors.orange.withOpacity(0.7),
//              ], begin: Alignment.bottomLeft, end: Alignment.topRight)),
//          child: Column(
//            mainAxisAlignment: MainAxisAlignment.spaceBetween,
//            children: [
//              Align(
//                  alignment: Alignment.topRight,
//                  child: Icon(
//                    getCategoryIcon(category),
//                    color: Colors.black26,
//                    size: width / 6,
//                  )),
//              Align(
//                alignment: Alignment.bottomLeft,
//                child: Column(
//                  crossAxisAlignment: CrossAxisAlignment.start,
//                  mainAxisAlignment: MainAxisAlignment.end,
//                  children: <Widget>[
//                    Text(
//                      getCategoryLabel(category),
//                      style: TextStyle(
//                          color: Colors.white,
//                          fontWeight: FontWeight.w800,
//                          fontSize: width / 15),
//                    ),
//                    Stack(
//                      alignment: Alignment.centerLeft,
//                      children: <Widget>[
//                        Container(
//                          decoration: BoxDecoration(
//                              color: Colors.black26,
//                              borderRadius: BorderRadius.circular(width)),
//                          width: width / 5,
//                          height: height / 100,
//                        ),
//                        Container(
//                          decoration: BoxDecoration(
//                              color: Colors.white,
//                              borderRadius: BorderRadius.circular(width)),
//                          width: width / 10,
//                          height: height / 100,
//                        ),
//                      ],
//                    ),
//                  ],
//                ),
//              ),
//            ],
//          ),
//        ),
//      ]),
//    );
//  }
//}
class AllLevels extends StatelessWidget {
//  List<Category> categories = PhrasalVerbsBank().categoriesList();
  final List<Level> categories;
  final int levels;

//  List<List<Category>> list = [];
  PageController controller = PageController();

  AllLevels({Key key, this.categories, this.levels}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<DataProvider>(context);
    var size = MediaQuery.of(context).size;
    var width = size.width;
    var height = size.height;
//    List<Map<Category, int>> maps = [];
//    for (Category cat in categories){
//     maps.add({cat:categories.where((c)=>c==cat).toList().indexOf(cat,3)});
//     maps.forEach((e) {
//       print(e.values.first.toString() + " " + e.keys.first.toString());
//     });
//    }
//    List<Widget> buttons = []
    return EnhancedFutureBuilder(
      future: provider.unlockedLevels(),
      rememberFutureResult: true,
      whenNotDone: Container(
        color: Colors.white,
      ),
      whenWaiting: Container(
        color: Colors.white,
      ),
      whenNone: Container(
        color: Colors.white,
      ),
      whenDone: (data) {
        print(size.aspectRatio);
        return size.aspectRatio > 0.5
            ? ListView.builder(
                padding: EdgeInsets.only(),
                itemCount: levels,
                scrollDirection: Axis.vertical,
                controller: PageController(initialPage: data.last - 1),
                itemBuilder: (context, index) {
                  return LevelPage(
                      levels: PhrasalVerbsBank().getSubLevelsRange(index,
                          levels: PhrasalVerbsBank().levels),
                      level: index + 1,
                      isLocked: !data.contains(index + 1));
                },
              )
            : PageView.builder(
                itemCount: levels,
                pageSnapping: true,
                scrollDirection: Axis.vertical,
                controller: PageController(initialPage: data.last - 1),
                itemBuilder: (context, index) {
                  return LevelPage(
                      levels: PhrasalVerbsBank().getSubLevelsRange(index,
                          levels: PhrasalVerbsBank().levels),
                      level: index + 1,
                      isLocked: !data.contains(index + 1));
                },
              );
      },
    );
  }
}

class LevelProgress extends StatefulWidget {
  final bool isLocked;
  final int score;

  LevelProgress({Key key, this.isLocked, this.score}) : super(key: key);
  @override
  _LevelProgressState createState() => _LevelProgressState();
}

class _LevelProgressState extends State<LevelProgress>
    with SingleTickerProviderStateMixin {
  AnimationController progressController;
  Animation<double> progressAnimation;
  @override
  void initState() {
    progressController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );
    progressAnimation = CurvedAnimation(
      parent: progressController,
      curve: Curves.easeOutCubic,
    );
    progressAnimation.addListener(() {
      setState(() {
        print(progressAnimation.value * 10);
      });
    });
    progressController.forward(from: 0);
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    progressController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var width = size.width;
    var height = size.height;
    List<Widget> stripes() {
      List<Widget> strs = [];
      strs.add(Container(
        margin: EdgeInsets.only(right: width / 30),
        child: Text(
          ((progressAnimation.value * widget.score).ceil()).toString() +
              ' ' +
              '%',
          style: TextStyle(
              color: kDarkBlue.withOpacity(0.9),
              fontWeight: FontWeight.w700,
              fontSize: width / 15),
        ),
      ));
      for (var i = 0; i < 10; i++) {
        var str = Container(
          margin: EdgeInsets.symmetric(horizontal: width / 150),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(width),
              color: i < progressAnimation.value * widget.score ~/ 10
                  ? kDarkBlue.withOpacity(0.9)
                  : kDBackGround),
          width: width / 80,
          height: height / 40,
        );
        strs.add(str);
      }
      return strs;
    }

    return Row(
      children: stripes(),
    );
  }
}

class LevelPage extends StatelessWidget {
  final List<Level> levels;
  final int level;
  final bool isLocked;
  const LevelPage({Key key, this.levels, this.isLocked = false, this.level})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<DataProvider>(context);
    var size = MediaQuery.of(context).size;
    var width = size.width;
    var height = size.height;
    List<Widget> buttons = [];
    return EnhancedFutureBuilder(
      future: Future.wait([
        provider.unlockedLevels(),
        DBProvider.db.retrieveAllLevels(),
      ]).then((response) => Merged(
            levelsUnlocked: response[0],
            level: response[1],
          )),
      rememberFutureResult: true,
      whenNotDone: Container(),
      whenWaiting: Container(),
      whenNone: Container(),
      whenDone: (data) {
        List<Level> subLevels = [];
        for (var category in levels) {
          Level levelStored = data.level.firstWhere((l) =>
              l.level == category.level && l.category == category.category);
          subLevels.add(levelStored);
        }

        buttons.add(Container(
            margin: EdgeInsets.only(
              left: width / 15,
              right: width / 15,
              bottom: height / 50,
              top: height / 15,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Level $level',
                  style: TextStyle(
                      color: isLocked ? Colors.black26 : kDarkBlue,
                      fontSize: width / 13,
                      fontWeight: FontWeight.w900),
                ),
                Container(
//                  decoration: BoxDecoration(color: kDBackGround, shape: BoxShape.circle),
                  // padding: EdgeInsets.all(width/30),
                  child: Text(
                    '',
                    style: TextStyle(
                        color: isLocked ? Colors.black26 : kDarkBlue,
                        fontSize: width / 12,
                        fontWeight: FontWeight.w800),
                  ),
                ),
                SizedBox(
                  height: height / 100,
                ),
                isLocked
                    ? Container()
                    : PhrasalVerbsBank.levelScoreFinal(subLevels) < 5
                        ? Container()
                        : LevelProgress(
                            isLocked: isLocked,
                            score: PhrasalVerbsBank.levelScoreFinal(subLevels)),
              ],
            )));
        subLevels.forEach((category) {
          var button = TrainingButton(
            index: category.level,
            delay: subLevels.indexOf(category) / 5,
            category: category.category,
            isLocked: isLocked ? true : category.unlocked,
            progress: category.progress,
          );
          buttons.add(button);
        });

        return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: buttons);
      },
    );
  }
}

class Merged {
  List<int> levelsUnlocked;
  List<Level> level;
  Merged({this.level, this.levelsUnlocked});
}

class TrainingButton extends StatelessWidget {
  final int index;
  final Category category;
  final bool isLocked;
  final int progress;
  final double delay;

  TrainingButton(
      {this.index, this.category, this.isLocked, this.progress, this.delay});
  @override
  Widget build(BuildContext context) {
    String _heroTag = '$index $category $delay $progress';
    var provider = Provider.of<DataProvider>(context);
    var size = MediaQuery.of(context).size;
    var width = size.width;
    var height = size.height;
    Color color = kYellow;
    return FadeIn(
      delay: delay,
      isHorizontal: true,
      begin: -width / 15,
      child: GestureDetector(
        onTap: () async {
          if (!isLocked) {
            await provider.vibrate(2);
            await provider.setTempLikedVerbs();
            provider.navigateTo(
              LearningScreen(
                category: category,
                index: index,
                heroTag: _heroTag,
              ),
              context,
            );
          } else {
            await provider.vibrate(5);
            await provider.showAdDialog(context, unlockWord: false);
          }

//        subjectTapped(context, index);
//        provider.changeSubjectIndex(index);
        },
        child: Container(
          padding: EdgeInsets.only(right: width / 15),
          margin: EdgeInsets.symmetric(
              vertical: height / 70, horizontal: width / 30),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(width / 15),
              boxShadow: [
                BoxShadow(
                    color: progress != 15
                        ? Colors.grey.shade200
                        : color.withOpacity(0.7),
                    spreadRadius: 1,
                    blurRadius: 7,
                    offset: Offset(
                      0,
                      height / 300,
                    ))
              ],
              gradient: progress != 15
                  ? null
                  : LinearGradient(
                      colors: [color, color.withOpacity(0.5)],
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight)),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Hero(
                  tag: _heroTag,
                  child: Container(
                    width: width / 5,
                    height: width / 5,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(width / 15),
                        color: isLocked ? Colors.black12 : null,
                        boxShadow: progress==15? null:[
                          BoxShadow(
                            color: isLocked
                                ? Colors.transparent
                                : Colors.orangeAccent.withOpacity(0.4),
                            spreadRadius: 1,
                            blurRadius: 7,
                          )
                        ],
                        gradient: isLocked
                            ? null
                            : LinearGradient(
                                colors: [color, color.withOpacity(1)],
                                begin: Alignment.bottomLeft,
                                end: Alignment.topRight)),
                    child: SizeAnimation(
                      delay: delay + 1,
                      end: 2,
                      child: Icon(
                        provider.getCategoryIcon(category),
                        color: progress == 15 ? Colors.black26 : Colors.white,
                        size: width / 20,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: width / 20,
                ),
                Text(
                  provider.categoryToLabel(category),
                  style: TextStyle(
                      color: isLocked
                          ? Colors.black26
                          : progress == 15
                              ? Colors.white
                              : kDarkBlue.withOpacity(0.8),
                      fontWeight: FontWeight.w800,
                      fontSize: width / 23),
                ),
              ],
            ),
            isLocked
                ? Icon(
                    Icons.lock,
                    color: Colors.black26,
                  )
                : progress == 15
                    ? Icon(
                        Icons.check_circle,
                        size: width / 10,
                        color: Colors.white,
                      )
                    : Container(
                        child: Stack(
                          alignment: Alignment.centerLeft,
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(width)),
                              width: width / 6,
                              height: height / 100,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: color,
                                  borderRadius: BorderRadius.circular(width)),
                              width: width / 6 / 15 * progress,
                              height: height / 100,
                            ),
                          ],
                        ),
                      ),
          ]),
        ),
      ),
    );
  }
}
