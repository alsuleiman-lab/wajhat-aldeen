import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

/// AMOLED burn-in prevention: shifts content by 1-3 pixels every 5 minutes
class AnimatedPixelShift extends StatefulWidget {
  final Widget child;
  final int shiftIntervalMinutes;
  final int maxShiftPixels;

  const AnimatedPixelShift({
    super.key,
    required this.child,
    this.shiftIntervalMinutes = 5,
    this.maxShiftPixels = 3,
  });

  @override
  State<AnimatedPixelShift> createState() => _AnimatedPixelShiftState();
}

class _AnimatedPixelShiftState extends State<AnimatedPixelShift> {
  double _offsetX = 0;
  double _offsetY = 0;
  Timer? _timer;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _startShiftTimer();
  }

  void _startShiftTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(
      Duration(minutes: widget.shiftIntervalMinutes),
      (_) => _shift(),
    );
  }

  void _shift() {
    final max = widget.maxShiftPixels.toDouble();
    setState(() {
      _offsetX = (_random.nextDouble() * max * 2) - max;
      _offsetY = (_random.nextDouble() * max * 2) - max;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(seconds: 2),
      curve: Curves.easeInOut,
      transform: Matrix4.translationValues(_offsetX, _offsetY, 0),
      child: widget.child,
    );
  }
}
