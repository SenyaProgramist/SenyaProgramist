import 'package:flutter/material.dart';
import 'package:phrasal_verbs/model/phrasal_verb.dart';

class PhrasalVerbMenu extends StatelessWidget {
  final PhrasalVerb phrasalVerb;
  final Color color;
  PhrasalVerbMenu({this.phrasalVerb, this.color = Colors.white});
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    var screenSize = MediaQuery.of(context).size;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        PhrasalVerbContent(
          color: color,
          title: 'Description',
          content: phrasalVerb.description,
        ),
        Container(
          height: height / 20,
        ),
        PhrasalVerbContent(
          color: color,
          title: 'Example',
          content: phrasalVerb.example,
        ),
      ],
    );
  }
}

class PhrasalVerbContent extends StatelessWidget {
  final String content;
  final String title;
  final Color color;
  final bool reverse;

  const PhrasalVerbContent({Key key, this.color, this.content, this.title, this.reverse = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    List styles = [
      TextStyle(
          color: color.withOpacity(0.7),
          fontWeight: FontWeight.w600,
          fontSize: width / 20),
      TextStyle(
          color: color,
          fontSize: width / 18,
          fontWeight: FontWeight.w600),
    ];
    return Container(
      margin: EdgeInsets.symmetric(horizontal: width / 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: styles[reverse?1:0]
          ),
          SizedBox(
            height: height / 100,
          ),
          Text(
            content,

            style: styles[reverse?0:1]
          ),
        ],
      ),
    );
  }
}
