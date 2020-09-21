import 'package:flutter/material.dart';
import 'package:rate_my_app/rate_my_app.dart';

class RateModel {
  RateMyApp _rateMyApp = RateMyApp(
    preferencesPrefix: 'phrasalVerbs',
    minDays: 1,
    minLaunches: 2,
    remindLaunches: 2,
    remindDays: 1,
    googlePlayIdentifier: 'com.arseniynasikovskiy.phrasal_verbs',
    appStoreIdentifier: 'com.arseniynasikovskiy.phrasal-verbs',
  );

  Future<bool> shouldOpenDialog() async {
    await _rateMyApp.init();
    return _rateMyApp.shouldOpenDialog;
  }

  Future<bool> initialize() async {
    await _rateMyApp.init();
    return true;
  }

  Future showStarRateDialog(BuildContext context) async {
    if (await initialize()) {
      await _rateMyApp.showStarRateDialog(
        context,
        title: 'Rate this app', // The dialog title.
        message:
            'You like this app ? Then take a little bit of your time to leave a rating', // The dialog message.
        actionsBuilder: (_, stars) {
          // Triggered when the user updates the star rating.
          return [
            // Return a list of actions (that will be shown at the bottom of the dialog).
            FlatButton(
              child: Text('OK'),
              onPressed: () async {
                print('Thanks for the ' +
                    (stars == null ? '0' : stars.round().toString()) +
                    ' star(s) !');
                // You can handle the result as you want (for instance if the user puts 1 star then open your contact page, if he puts more then open the store page, etc...).
                // This allows to mimic the behavior of the default "Rate" button. See "Advanced > Broadcasting events" for more information :
                await _rateMyApp.callEvent(RateMyAppEventType.rateButtonPressed);
                Navigator.pop<RateMyAppDialogButton>(
                    context, RateMyAppDialogButton.rate);
              },
            ),
          ];
        },
        ignoreIOS:
            false, // Set to false if you want to show the native Apple app rating dialog on iOS.
        dialogStyle: DialogStyle(
          // Custom dialog styles.
          titleAlign: TextAlign.center,
          messageAlign: TextAlign.center,
          messagePadding: EdgeInsets.only(bottom: 20),
        ),
        starRatingOptions:
            StarRatingOptions(), // Custom star bar rating options.
        onDismissed: () => _rateMyApp.callEvent(RateMyAppEventType
            .laterButtonPressed), // Called when the user dismissed the dialog (either by taping outside or by pressing the "back" button).
      );
    }
  }

  Future ratingDismissed() async {
    await initialize();
    await _rateMyApp.callEvent(RateMyAppEventType.laterButtonPressed);
  }

  Future showRateDialog(BuildContext context) async {
    if (await initialize()) {}
    await _rateMyApp.showRateDialog(
      context,
      title: 'Rate this app', // The dialog title.
      message:
          'If you like this app, please take a little bit of your time to review it !\nIt really helps us and it shouldn\'t take you more than one minute.', // The dialog message.
      rateButton: 'RATE', // The dialog "rate" button text.
      noButton: 'NO THANKS', // The dialog "no" button text.
      laterButton: 'MAYBE LATER', // The dialog "later" button text.
      listener: (button) {
        // The button click listener (useful if you want to cancel the click event).
        switch (button) {
          case RateMyAppDialogButton.rate:
            print('Clicked on "Rate".');
            break;
          case RateMyAppDialogButton.later:
            print('Clicked on "Later".');
            break;
          case RateMyAppDialogButton.no:
            print('Clicked on "No".');
            break;
        }

        return true; // Return false if you want to cancel the click event.
      },
      ignoreIOS:
          false, // Set to false if you want to show the native Apple app rating dialog on iOS.
      dialogStyle: DialogStyle(), // Custom dialog styles.
      onDismissed: () => _rateMyApp.callEvent(RateMyAppEventType
          .laterButtonPressed), // Called when the user dismissed the dialog (either by taping outside or by pressing the "back" button).
      // actionsBuilder: (_) => [], // This one allows you to use your own buttons.
    );
  }
}
