import 'package:like_button/like_button.dart';
import 'package:flutter/material.dart';
import 'package:phrasal_verbs/const.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:phrasal_verbs/model/data_provider.dart';
import 'package:phrasal_verbs/model/phrasal_verb.dart';

class LikeStarButton extends StatelessWidget {
  final PhrasalVerb phrasalVerb;

  LikeStarButton({Key key, this.phrasalVerb}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color color = Color(0xFFff5858).withOpacity(0.9);
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    var provider = Provider.of<DataProvider>(context);
    return LikeButton(
      size: width / 10,
      animationDuration: Duration(milliseconds: 500),
      circleColor: CircleColor(start: Colors.redAccent, end: Colors.redAccent),
      bubblesColor: BubblesColor(
        dotPrimaryColor: color,
        dotSecondaryColor: color,
      ),
      isLiked: provider.isTempLiked(phrasalVerb),
      onTap: (bool) async {
        Future.delayed(Duration(milliseconds: 500)).then((e) {
          provider.tempLikeUnlikeList(phrasalVerb, !bool);
        });
        return !bool;
      },
      likeBuilder: (bool isLiked) {
        return Icon(
          isLiked ? MdiIcons.heart : MdiIcons.heartOutline,
          color: isLiked ? color : kDarkBlue.withOpacity(0.5),
          size: width / 10,
        );
      },
    );
  }
}
