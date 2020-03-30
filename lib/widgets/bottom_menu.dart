import 'package:flutter/material.dart';

class BottomMenu extends StatelessWidget {
  final Widget child;
  BottomMenu({this.child});
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var width = size.width;
    var height = size.height;
    return Container(
      padding: EdgeInsets.symmetric(vertical: height / 20),
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(color: Colors.black12, spreadRadius: 2, blurRadius: 10),

          ],
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(width / 10),
            topLeft: Radius.circular(width / 10),
          )),
      child: child,
    );
  }
}

class CornerSheet extends StatelessWidget {
  final Widget child;
  final bool isRight;
  final Color color;
  final bool topPadding;
  final double height;

  final double horizontalPadding;
  CornerSheet(
      {this.child,
      this.height,
      this.horizontalPadding,
      this.color = Colors.white,
      this.topPadding = true,
      this.isRight});
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var width = size.width;
    var h = size.height;
    return Container(
      height: height == null ? h / 7 : height,
      padding: EdgeInsets.only(
        right: horizontalPadding,
        left: horizontalPadding,
        top: topPadding ? h / 30 : 0,
      ),
      decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.only(
            bottomRight: isRight ? Radius.circular(width / 8) : Radius.zero,
            bottomLeft: isRight ? Radius.zero : Radius.circular(width / 8),
          )),
      child: Center(child: child),
    );
  }
}
