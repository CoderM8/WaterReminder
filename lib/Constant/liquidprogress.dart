import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:water_tracker/Constant/constant.dart';

class LiquidProgressIndicator extends ProgressIndicator {
  final Widget? center;
  final Axis direction;

  const LiquidProgressIndicator({
    super.key,
    double super.value = 0.5,
    this.center,
    this.direction = Axis.vertical,
  });

  @override
  State<StatefulWidget> createState() => _LiquidCircularProgressIndicatorState();
}

class _LiquidCircularProgressIndicatorState extends State<LiquidProgressIndicator> {
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: SquareClipper(),
      child: Stack(
        children: [
          Wave(
            value: widget.value,
            color: blueColor.withOpacity(0.8),
            direction: widget.direction,
            time: 2,
          ),
          Wave(
            value: widget.value,
            color: lightBlueColor,
            direction: widget.direction,
            time: 3,
          ),
          if (widget.center != null) Center(child: widget.center),
        ],
      ),
    );
  }
}

class SquareClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class Wave extends StatefulWidget {
  final double? value;
  final Color color;
  final Axis direction;
  final int time;

  const Wave({
    super.key,
    required this.value,
    required this.color,
    required this.direction,
    required this.time,
  });

  @override
  WaveState createState() => WaveState();
}

class WaveState extends State<Wave> with SingleTickerProviderStateMixin {
  late AnimationController animationController;

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.time),
    );
    animationController.repeat();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: CurvedAnimation(
        parent: animationController,
        curve: Curves.easeInOut,
      ),
      builder: (context, child) => ClipPath(
        clipper: WaveClipper(
          animationValue: animationController.value,
          value: widget.value,
          direction: widget.direction,
        ),
        child: Container(
          color: widget.color,
        ),
      ),
    );
  }
}

class WaveClipper extends CustomClipper<Path> {
  final double animationValue;
  final double? value;
  final Axis direction;

  WaveClipper({
    required this.animationValue,
    required this.value,
    required this.direction,
  });

  @override
  Path getClip(Size size) {
    if (direction == Axis.horizontal) {
      Path path = Path()
        ..addPolygon(generateHorizontalWavePath(size), false)
        ..lineTo(0.0, size.height)
        ..lineTo(0.0, 0.0)
        ..close();
      return path;
    }

    Path path = Path()
      ..addPolygon(generateVerticalWavePath(size), false)
      ..lineTo(size.width, size.height)
      ..lineTo(0.0, size.height)
      ..close();
    return path;
  }

  List<Offset> generateHorizontalWavePath(Size size) {
    final waveList = <Offset>[];
    for (int i = -2; i <= size.height.toInt() + 2; i++) {
      final waveHeight = (size.width / 10);
      final dx = math.sin((animationValue * 360 - i) % 360 * (math.pi / 180)) * waveHeight + (size.width * value!);
      waveList.add(Offset(dx, i.toDouble()));
    }
    return waveList;
  }

  List<Offset> generateVerticalWavePath(Size size) {
    final waveList = <Offset>[];
    for (int i = -2; i <= size.width.toInt() + 2; i++) {
      final waveHeight = (size.height / 70);
      final dy = math.sin((animationValue * 360 - i) % 360 * (math.pi / 180)) * waveHeight + (size.height - (size.height * value!));
      waveList.add(Offset(i.toDouble(), dy));
    }
    return waveList;
  }

  @override
  bool shouldReclip(WaveClipper oldClipper) => animationValue != oldClipper.animationValue;
}
