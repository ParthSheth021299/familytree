import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RandomDigitAnimation extends StatefulWidget {
  final int targetCount;
  final Color color;
  final Duration duration;

  const RandomDigitAnimation({
    super.key,
    required this.targetCount,
    required this.color,
    this.duration = const Duration(seconds: 2),
  });

  @override
  State<RandomDigitAnimation> createState() => _RandomDigitAnimationState();
}

class _RandomDigitAnimationState extends State<RandomDigitAnimation> {
  late int _currentDisplay;
  late Timer _timer;
  final _random = Random();

  @override
  void initState() {
    super.initState();
    _currentDisplay = _random.nextInt(9); // start with random digit
    _startAnimation();
  }

  void _startAnimation() {
    final endTime = DateTime.now().add(widget.duration);

    _timer = Timer.periodic(const Duration(milliseconds: 2), (timer) {
      if (DateTime.now().isAfter(endTime)) {
        // stop and show the actual target value
        setState(() {
          _currentDisplay = widget.targetCount;
        });
        _timer.cancel();
      } else {
        // keep shuffling
        setState(() {
          _currentDisplay = _random.nextInt(10);
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      '$_currentDisplay',
      style: GoogleFonts.poppins(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: widget.color,
      ),
    );
  }
}
