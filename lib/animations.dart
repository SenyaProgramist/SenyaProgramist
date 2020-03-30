import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

class SizeAnimation extends StatelessWidget {
  final double delay;
  final Widget child;
  final double end;
  final bool isHorizontal;
  final Curve curve;
  final double begin;
  final int duration;

  SizeAnimation(
      {this.delay,
      this.end = 0,
      this.child,
      this.begin = 0,
      this.isHorizontal = true,
      this.duration = 1000,
      this.curve = Curves.easeOutQuart});

  @override
  Widget build(BuildContext context) {
    final tween = MultiTrackTween([
      Track("opacity")
          .add(Duration(milliseconds: 50), Tween(begin: 0.0, end: 1.0)),
      Track("size").add(
          Duration(milliseconds: duration), Tween(begin: begin, end: end),
          curve: curve)
    ]);

    return ControlledAnimation(
      delay: Duration(milliseconds: (300 * delay).round()),
      duration: tween.duration,
      tween: tween,
      child: child,
      curve: curve,
      builderWithChild: (context, child, animation) => Opacity(
        opacity: animation["opacity"],
        child: Transform.scale(
          scale: animation['size'].toDouble(),
          child: child,
          alignment: Alignment.center,
        ),
      ),
    );
  }
}

class FadeIn extends StatelessWidget {
  final double delay;
  final Widget child;
  final double begin;
  final bool isHorizontal;
  final dynamic curve;
  final Duration duration;

  FadeIn(
      {this.delay,
      this.duration = const Duration(milliseconds: 500),
      this.begin,
      this.child,
      this.isHorizontal = true,
      this.curve = Curves.easeOut});

  @override
  Widget build(BuildContext context) {
    final tween = MultiTrackTween([
      Track("opacity").add(duration, Tween(begin: 0.0, end: 1.0)),
      Track("translateX")
          .add(duration, Tween(begin: begin, end: 0), curve: curve)
    ]);

    return ControlledAnimation(
      delay: Duration(milliseconds: (300 * delay).round()),
      duration: tween.duration,
      tween: tween,
      child: child,
      curve: curve,
      builderWithChild: (context, child, animation) => Opacity(
        opacity: animation["opacity"],
        child: Transform.translate(
            offset: isHorizontal
                ? Offset(animation["translateX"], 0)
                : Offset(
                    0,
                    animation["translateX"],
                  ),
            child: child),
      ),
    );
  }
}
