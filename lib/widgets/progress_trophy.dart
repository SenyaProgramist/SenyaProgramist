import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ProgressSection extends StatelessWidget {
  const ProgressSection({Key key, this.active = true}) : super(key: key);

  final bool active;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var width = size.width;
    var height = size.height;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
//          Container(
//            height: height / 30,
//            width: width / 40,
//            decoration: BoxDecoration(
//                color: Colors.white,
//                borderRadius: BorderRadius.circular(width)),
//          ),
        Container(
            decoration: BoxDecoration(shape: BoxShape.circle),
            child: Icon(
              MdiIcons.trophy,
              color: active ? Colors.yellow.shade700 : Colors.black26,
            )),
      ],
    );
  }
}
