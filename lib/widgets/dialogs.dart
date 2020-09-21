import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:phrasal_verbs/const.dart';
import 'package:phrasal_verbs/animations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:phrasal_verbs/widgets/dialog.dart';
import 'package:phrasal_verbs/model/rate_model.dart';

class Dialogs {
  static Future showRateDialog(BuildContext context, {bool newLevel}) async {
    var size = MediaQuery.of(context).size;
    var width = size.width;
    var height = size.height;
    bool askToRate = await RateModel().shouldOpenDialog();
    Widget _dialogButton(bool skip, BuildContext context) {
      return DialogButton(
          skip: skip,
          label: skip ? 'SKIP' : 'RATE',
          onTap: () async {
            if (skip) {
              if (askToRate) {
                await RateModel().ratingDismissed();
              }
              Navigator.pop(context);
            } else {
              await RateModel().showRateDialog(context);
            }
          });
    }

    await AwesomeDialog(
      context: context,
      animType: AnimType.BOTTOMSLIDE,
      dialogType: DialogType.SUCCES,
      btnCancel: askToRate ? _dialogButton(true, context) : null,
      btnOk: _dialogButton(!askToRate, context),
      body: Body(
          svg: 'winner',
          confetti: true,
          mainText:
              '${newLevel ? 'You\'ve just opened a new level!' : 'You\'ve just mastered a handful of new words while playing!'} ${askToRate ? 'Did you enjoy it?' : ''}',
          title: newLevel ? 'Congratulations!' : 'Good job!'),
      dismissOnTouchOutside: false,
    ).show();
  }

  static Future showAdDialog(BuildContext context,
      {bool unlockWord = true}) async {
    Widget _dialogButton(BuildContext context) {
      return DialogButton(
          skip: true,
          label: 'OK',
          onTap: () {
            Navigator.pop(context);
//            await RateModel().showRateDialog(context);
          });
    }

    var size = MediaQuery.of(context).size;
    var width = size.width;
    var height = size.height;
    await AwesomeDialog(
      context: context,
      animType: AnimType.BOTTOMSLIDE,
      btnCancel: null,
      dialogType: DialogType.SUCCES,
      btnOk: _dialogButton(context),
      body: Body(
        svg: 'padlock',
        title: '',
        confetti: false,
        or: false,
        mainText: unlockWord
            ? 'You can unlock a word by learning it'
            : 'To unlock a new level you should reach 90% progress',
        // or: true,
      ),
      dismissOnTouchOutside: true,
    ).show();
  }
}

class Body extends StatelessWidget {
  final String title;
  final String mainText;
  final bool or;
  final bool confetti;
  final String svg;

  const Body(
      {Key key,
      this.mainText,
      this.svg = 'winner',
      this.or = false,
      this.confetti = false,
      this.title})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var width = size.width;
    var height = size.height;
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        !confetti ? Container() : Confetti(),
        Container(
          color: Colors.transparent,
          padding: EdgeInsets.symmetric(
              horizontal: width / 20, vertical: height / 1005),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: height / 15,
              ),
              SizeAnimation(
                  delay: 2,
                  end: 2.2,
                  begin: -0.5,
                  child: Container(
                    padding:
                        EdgeInsets.only(left: svg == 'winner' ? 0 : width / 30),
                    child: SvgPicture.asset(
                      'assets/$svg.svg',
                      height: height / 12,
                    ),
                  )),
              SizedBox(
                height: height / 15,
              ),
              Text(
                title,
                style: TextStyle(
                    color: kDarkBlue,
                    fontWeight: FontWeight.w900,
                    fontSize: width / 16),
              ),
              SizedBox(
                height: height / 50,
              ),
              Text(
                mainText,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: kDarkBlue.withOpacity(0.7),
                    fontWeight: FontWeight.w600,
                    fontSize: width / 20),
              ),
              SizedBox(
                height: height / 50,
              ),
              or
                  ? Text(
                      'or',
                      style: TextStyle(
                          color: kDarkBlue,
                          fontWeight: FontWeight.w900,
                          fontSize: width / 16),
                    )
                  : Container(),
            ],
          ),
        ),
      ],
    );
  }
}

class DialogButton extends StatelessWidget {
  final bool skip;
  final Function onTap;
  final String label;

  const DialogButton({
    Key key,
    this.skip,
    this.label,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var width = size.width;
    var height = size.height;
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: height / 40),
        padding: EdgeInsets.symmetric(vertical: height / 50),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(width),
            boxShadow: !skip
                ? [
                    BoxShadow(
                        color: Colors.orange.withOpacity(0.5),
                        offset: Offset(0, 3),
                        blurRadius: 10,
                        spreadRadius: 2),
                  ]
                : null,
            color: !skip ? Colors.orange : Colors.white,
            border: Border.all(color: Colors.orange, width: 2)),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
                color: skip ? Colors.orange : Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: width / 25),
          ),
        ),
      ),
    );
  }
}
