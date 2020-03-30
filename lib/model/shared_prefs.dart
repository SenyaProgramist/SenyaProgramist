import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesTest {
  ///
  /// Instantiation of the SharedPreferences library
  ///

  static final String _unlockedLevels = "unlocked levels";
  static final String _currentLevel = "current level";
  static final String _levelsInitialized = "current level";
  static final String _likedVerbs = "liked verbs";

  /// ------------------------------------------------------------
  /// Method that returns the user decision to allow notifications
  /// ------------------------------------------------------------
  static Future<List<String>> getUnlockedLevels() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_unlockedLevels) ?? ['1'];
  }

  static Future setUnlockedLevels(List<String> list) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setStringList(_unlockedLevels, list);
  }

//
  //
  //
  //
  //
  //
  //
  static Future<List<String>> getLikedVerbs() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_likedVerbs) ?? [''];
  }

  static Future setLikedVerbs(List<String> verbs) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setStringList(_likedVerbs, verbs);
  }
//
  //
  //
  //
  //
  //

  //
  //
  static Future<int> getCurrentLevel() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_currentLevel) ?? 1;
  }

  static Future setCurrentLevel(int level) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setInt(_currentLevel, level);
  }

  static Future<bool> getLevelsInitialized() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_levelsInitialized) ?? false;
  }

  static Future selLevelsInitialized() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setBool(_levelsInitialized, true);
  }
}
