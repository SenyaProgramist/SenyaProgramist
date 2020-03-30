import 'package:vibrate/vibrate.dart';
import 'package:flutter/material.dart';
import 'package:phrasal_verbs/model/phrasal_verb.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:phrasal_verbs/model/rate_model.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:phrasal_verbs/model/database.dart';
import 'package:like_button/like_button.dart';
import 'package:phrasal_verbs/model/shared_prefs.dart';
import 'package:phrasal_verbs/model/verbs_bank.dart';
import 'package:phrasal_verbs/navigation_screen.dart';
import 'package:phrasal_verbs/widgets/dialogs.dart';
import 'package:phrasal_verbs/const.dart';
import 'package:phrasal_verbs/animations.dart';
import 'package:phrasal_verbs/widgets/dialog.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:phrasal_verbs/screens/library_screen.dart';
import 'package:get_it/get_it.dart';

class DataProvider extends ChangeNotifier {
  Future vibrate(int volume) async {
//    if (await Vibrate.canVibrate) {
//      if (volume == 1) {
//        var _type = FeedbackType.light;
//        Vibrate.feedback(_type);
//      } else if (volume == 2) {
//        var _type = FeedbackType.medium;
//        Vibrate.feedback(_type);
//      } else if (volume == 3) {
//        var _type = FeedbackType.success;
//        Vibrate.feedback(_type);
//      } else if (volume == 4) {
//        var _type = FeedbackType.error;
//        Vibrate.feedback(_type);
//      }
//    }
  }

  List<String> tempLikedVerbs = [];

  Future setTempLikedVerbs() async {
    tempLikedVerbs = await this.getLikedVerbs();
    notifyListeners();
  }

  Future saveScore(Category category, int difficulty, int score) async {
    Level level = await DBProvider.db.getLevel(category, difficulty);
    await DBProvider.db.updateLevel(Level(level.category, level.level,
        progress: score, unlocked: level.unlocked, id: level.id));
  }

  Future<int> getScoreForLevel(Category category, int difficulty) async {
    int score = await DBProvider.db.score(category, difficulty);
    print('SCORE' + score.toString());
    return score;
  }

  Future<int> getScoreAll(Category category, int difficulty) async {
    int score = await DBProvider.db.score(category, difficulty);
  }

  Future showRateDialog(BuildContext context, bool newLevel) async {
    await Dialogs.showRateDialog(context, newLevel: newLevel);
  }

  Future showAdDialog(BuildContext context, bool newLevel) async {
    await Dialogs.showAdDialog(
      context,
    );
  }

  void tempLikeUnlikeList(PhrasalVerb verb, bool like) {
    if (like) {
      tempLikedVerbs.add(verb.description);
    } else {
      tempLikedVerbs.remove(verb.description);
    }
    notifyListeners();
  }

  Future saveFromTempLikedVerbs() async {
    await SharedPreferencesTest.setLikedVerbs(this.tempLikedVerbs);
  }

  bool isTempLiked(PhrasalVerb phrasalVerb) {
    bool contains = false;
    this.tempLikedVerbs.forEach((e) {
      if (e == phrasalVerb.description) {
        contains = true;
      }
    });
    return contains;
  }

  Future<List<String>> getLikedVerbs() async {
    return await SharedPreferencesTest.getLikedVerbs() ?? [''];
  }

  void navigateTo(
    Widget page,
    BuildContext context,
  ) {
    Navigator.push(
        context,
        PageTransition(
            type: PageTransitionType.rightToLeftWithFade,
            child: page,
            curve: Curves.decelerate));
  }

  String categoryToLabel(Category category) {
    return bank.categoryToLabel(category);
  }

  var bank = PhrasalVerbsBank();

  String nameOfPhrasalVerb(PhrasalVerb pV) {
    return bank.nameOfPhrasalVerb(pV);
  }

  Future<List<int>> unlockedLevels() async {
    List<int> levels = [];
    var levelsStr = await SharedPreferencesTest.getUnlockedLevels();
    levelsStr.forEach((e) {
      levels.add(double.parse(e).toInt());
    });
    return levels;
  }

  Future<int> scoreLastLevel() async {
    var unlocked = await this.unlockedLevels();
    var lastLevels = bank.getSubLevelsRange(unlocked.last - 1,
        levels: await DBProvider.db.retrieveAllLevels());
    int res = PhrasalVerbsBank.levelScoreFinal(lastLevels);

    return res;
  }

  Future unlockLevel() async {
    var levelsStr = await SharedPreferencesTest.getUnlockedLevels();
    print('UNLOCKED LEVELS BEFORE ADDING');
    print(levelsStr);
    levelsStr.add((levelsStr.length + 1).toString());
    print('UNLOCKED LEVELS AFTER ADDING');
    print(levelsStr);
    await SharedPreferencesTest.setUnlockedLevels(levelsStr);
  }

  Future addLikedVerb(List<PhrasalVerb> likedVerb) async {
    List<String> verbs = await getLikedVerbs();
    likedVerb.forEach((verb) {
      verbs.add(this.nameOfPhrasalVerb(verb));
    });

    await SharedPreferencesTest.setLikedVerbs(verbs);
  }

  Color getCategoryColor(Category category) {
    return kYellow;
//    switch (category) {
//      case Category.food:
//        return Colors.orange;
//      case Category.money:
//        return Colors.greenAccent.shade700;
//      case Category.technology:
//        return Colors.blue;
//      case Category.love:
//        return Colors.redAccent;
//      case Category.relationships:
//        return Colors.deepOrangeAccent;
//      case Category.health:
//        return Colors.lightGreenAccent.shade700;
//      case Category.business:
//        return Colors.blue;
//      case Category.family:
//        return Colors.green;
//      case Category.illness:
//        return Colors.brown;
//      case Category.emotions:
//        return Colors.purpleAccent;
//      case Category.animal:
//        return Colors.orangeAccent;
//      case Category.communication:
//        return Colors.cyan;
//      case Category.decision:
//        return Colors.brown.shade400;
//      case Category.education:
//        return Colors.lightBlue.shade300;
//      case Category.clothes:
//        return Colors.purple.shade400;
//      case Category.phone:
//        return Colors.lightBlueAccent.shade700;
//      case Category.house:
//        return Colors.yellow.shade900;
//      case Category.environment:
//        return Colors.lightGreen.shade600;
//      case Category.shopping:
//        return Colors.red;
//      case Category.crime:
//        return Colors.blueGrey;
//      case Category.work:
//        return Colors.lightBlue.shade400;
//      case Category.travel:
//        return Colors.blue.shade700;
//      default:
//        return Colors.black;
//    }
  }

  Future<List<PhrasalVerb>> unlockedPhrasalVerbs() async {
    List<Level> levels = await DBProvider.db.retrieveAllLevels();
    List<PhrasalVerb> verbs = [];
    levels.where((level) => level.progress != 0).forEach((v) {
      verbs.addAll(PhrasalVerbsBank().verbsToLearn(v.category, v.level));
    });

    return verbs;
  }

  Future<bool> isUnlocked(PhrasalVerb verb) async {
    var strings = await unlockedPhrasalVerbs();
    List<String> res = [];
    strings.forEach((v) {
      res.add(v.description);
    });
    return res.contains(verb.description);
  }

  IconData getCategoryIcon(Category category) {
    switch (category) {
      case Category.food:
        return Icons.fastfood;
      case Category.money:
        return MdiIcons.cash;

      case Category.technology:
        return Icons.computer;

      case Category.love:
        return MdiIcons.heartOutline;

      case Category.relationships:
        return MdiIcons.accountGroupOutline;

      case Category.health:
        return MdiIcons.dumbbell;
      case Category.business:
        return MdiIcons.handshake;
      case Category.family:
        return MdiIcons.babyCarriage;
      case Category.illness:
        return MdiIcons.pill;
      case Category.emotions:
        return MdiIcons.emoticonExcitedOutline;
      case Category.animal:
        return MdiIcons.jellyfishOutline;
      case Category.communication:
        return MdiIcons.accountVoice;
      case Category.decision:
        return MdiIcons.headDotsHorizontalOutline;
      case Category.education:
        return MdiIcons.schoolOutline;
      case Category.clothes:
        return MdiIcons.tshirtCrewOutline;
      case Category.phone:
        return MdiIcons.phoneOutline;
      case Category.house:
        return MdiIcons.homeVariantOutline;
      case Category.environment:
        return MdiIcons.sproutOutline;
      case Category.shopping:
        return MdiIcons.shoppingOutline;
      case Category.crime:
        return MdiIcons.robber;
      case Category.work:
        return MdiIcons.tie;
      case Category.travel:
        return MdiIcons.earth;
      default:
        return Icons.check;
    }
  }

  String correctVerb = '';
  String correctPrep1 = '';
  String correctPrep2 = '';
  bool verbAnswered = false;
  bool prepAnswered1 = false;
  bool prepAnswered2 = false;
  String chosenVerb = '';
  String chosenPrep = '';
  String chosenPrep2 = '';

  bool completed() {
    if (correctPrep2.isNotEmpty) {
      if (verbAnswered && prepAnswered1 && prepAnswered2) {
        return true;
      } else {
        return false;
      }
    } else {
      if (verbAnswered && prepAnswered1) {
        return true;
      } else {
        return false;
      }
    }
  }

  bool answer(String data) {
    if (!verbAnswered) {
      chosenVerb = data;
      notifyListeners();

      if (data == correctVerb) {
        verbAnswered = true;
        notifyListeners();
        return true;
      } else {
        verbAnswered = true;
        notifyListeners();
        Future.delayed(Duration(seconds: 1), () {
          verbAnswered = false;
          notifyListeners();
        });
        return false;
      }
    } else if (!prepAnswered1) {
      chosenPrep = data;
      notifyListeners();
      if (data == correctPrep1) {
        prepAnswered1 = true;

        notifyListeners();
        return true;
      } else {
        prepAnswered1 = true;
        notifyListeners();
        Future.delayed(Duration(seconds: 1), () {
          prepAnswered1 = false;
          notifyListeners();
        });
        return false;
      }
    } else if (!prepAnswered2) {
      chosenPrep2 = data;
      notifyListeners();
      if (data == correctPrep2) {
        prepAnswered2 = true;
        notifyListeners();
        return true;
      } else {
        prepAnswered2 = true;
        notifyListeners();
        Future.delayed(Duration(seconds: 1), () {
          prepAnswered2 = false;
          notifyListeners();
        });
        return false;
      }
    } else {
      return false;
    }
  }

  Future<List<PhrasalVerb>> getLikedPhrasalVerbs() async {
    List<String> descriptions = await SharedPreferencesTest.getLikedVerbs();
    List<PhrasalVerb> verbs = [];
    for (String desc in descriptions) {
      if (desc.isNotEmpty) {
        verbs.add(bank.verbs.firstWhere((pV) {
//          print(pV.description);
          return pV.description == desc;
        }));
      }
    }
    return verbs;
  }

  void setRightAnswers(PhrasalVerb verb) {
    correctVerb = bank.shortenVerb(verb);
    correctPrep1 = bank.shortenPreposition(verb);
    correctPrep2 = bank.shortenPreposition2(verb);
  }

  void cleanAnswers() {
    verbAnswered = false;
    prepAnswered1 = false;
    prepAnswered2 = false;
    notifyListeners();
  }
}
