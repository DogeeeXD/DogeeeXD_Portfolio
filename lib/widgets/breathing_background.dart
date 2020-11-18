import 'dart:math';

import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:supercharged/supercharged.dart';

class BreathingBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return Stack(
      children: <Widget>[
        Positioned.fill(child: AnimatedBackground()),
        onBottom(AnimatedWave(
          height: mediaQuery.size.height * 0.25,
          speed: 0.5,
        )),
        onBottom(AnimatedWave(
          height: mediaQuery.size.height * 0.2,
          speed: 0.2,
          offset: pi,
        )),
      ],
    );
  }

  Widget onBottom(Widget child) => Positioned.fill(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: child,
        ),
      );
}

enum _BgProps {
  color1,
  color2,
}

class AnimatedBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Color firstColor = Color(0xFFF3F2F7);
    Color secondColor = Theme.of(context).accentColor;
    Color thirdColor = Theme.of(context).backgroundColor;
    // background color animations
    final tween = MultiTween<_BgProps>()
      ..add(_BgProps.color1, firstColor.tweenTo(secondColor))
      ..add(_BgProps.color2, secondColor.tweenTo(thirdColor));

    return MirrorAnimation<MultiTweenValues<_BgProps>>(
      tween: tween,
      duration: 3.seconds,
      builder: (context, child, value) {
        return Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                value.get(_BgProps.color1),
                value.get(_BgProps.color2),
              ])),
        );
      },
    );
  }
}

class CurvePainter extends CustomPainter {
  final double value;

  CurvePainter(this.value);

  @override
  void paint(Canvas canvas, Size size) {
    final _color = Paint()..color = Color(0xFF111f9b).withAlpha(10);
    final path = Path();

    final y1 = 0.5 * sin(value + pi * 2);
    final y2 = 0.5 * sin(value + pi / 2);
    final y3 = 0.3 * sin(value + pi);

    final startPointY = size.height * (0.5 + 0.4 * y1);
    final controlPointY = size.height * (0.5 + 0.4 * y2);
    final endPointY = size.height * (0.5 + 0.4 * y3);

    path.moveTo(size.width * 0, startPointY);
    path.quadraticBezierTo(
        size.width * 0.5, controlPointY, size.width, endPointY);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    canvas.drawPath(path, _color);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class AnimatedWave extends StatelessWidget {
  final double height;
  final double speed;
  final double offset;

  AnimatedWave({this.height, this.speed, this.offset = 0.0});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        height: height,
        width: constraints.biggest.width,
        child: LoopAnimation<double>(
            duration: (5000 / speed).round().milliseconds,
            tween: 0.0.tweenTo(2 * pi),
            builder: (context, child, value) {
              return CustomPaint(
                foregroundPainter: CurvePainter(value + offset),
              );
            }),
      );
    });
  }
}
