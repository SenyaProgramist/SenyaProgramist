import 'package:flutter/material.dart';
import 'package:phrasal_verbs/navigation_screen.dart';
import 'package:provider/provider.dart';
import 'package:phrasal_verbs/model/shared_prefs.dart';
import 'package:phrasal_verbs/model/data_provider.dart';
import 'package:phrasal_verbs/model/verbs_bank.dart';
import 'package:phrasal_verbs/model/database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:phrasal_verbs/const.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
//  var prefs = await SharedPreferences.getInstance();
//  await prefs.clear();
  if (await SharedPreferencesTest.getLevelsInitialized() == false) {
    print('were not initialized');
    for (var level in PhrasalVerbsBank().levels) {
      await DBProvider.db.insertLevel(level);
    }
    await SharedPreferencesTest.selLevelsInitialized();
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DataProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
               title: 'Flutter Demo',
        theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Colors
              .pink[800], //Changing this will change the color of the TabBar
          accentColor: Colors.cyan[100],
        ),
        home: NavigationScreen(),
      ),
    );
  }
}
