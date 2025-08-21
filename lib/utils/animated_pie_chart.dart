// import 'dart:ui';

// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';

// class AnimatedGenderPieChart extends StatefulWidget {
//   final int maleCount;
//   final int femaleCount;

//   const AnimatedGenderPieChart({
//     super.key,
//     required this.maleCount,
//     required this.femaleCount,
//   });

//   @override
//   State<AnimatedGenderPieChart> createState() => _AnimatedGenderPieChartState();
// }

// class _AnimatedGenderPieChartState extends State<AnimatedGenderPieChart>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _animation;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1200),
//     );

//     _animation = CurvedAnimation(
//       parent: _controller,
//       curve: Curves.easeOutCubic,
//     );

//     _controller.forward();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final total = (widget.maleCount + widget.femaleCount).toDouble();

//     return AnimatedBuilder(
//       animation: _animation,
//       builder: (context, _) {
//         final maleValue = widget.maleCount * _animation.value;
//         final femaleValue = widget.femaleCount * _animation.value;

//         return PieChart(
//           PieChartData(
//             sections: [
//               PieChartSectionData(
//                 color: Colors.blueAccent,
//                 value: maleValue,
//                 title: total == 0
//                     ? "0%"
//                     : "${((maleValue / (maleValue + femaleValue)) * 100).toStringAsFixed(1)}%",
//                 titleStyle: const TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 12,
//                 ),
//               ),
//               PieChartSectionData(
//                 color: Colors.pinkAccent,
//                 value: femaleValue,
//                 title: total == 0
//                     ? "0%"
//                     : "${((femaleValue / (maleValue + femaleValue)) * 100).toStringAsFixed(1)}%",
//                 titleStyle: const TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.bold,
//                   fontSize: 12,
//                 ),
//               ),
//             ],
//             sectionsSpace: 4,
//             centerSpaceRadius: 40,
//           ),
//         );
//       },
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:visibility_detector/visibility_detector.dart';

class AnimatedGenderPieChart extends StatefulWidget {
  final int maleCount;
  final int femaleCount;

  const AnimatedGenderPieChart({
    super.key,
    required this.maleCount,
    required this.femaleCount,
  });

  @override
  State<AnimatedGenderPieChart> createState() => _AnimatedGenderPieChartState();
}

class _AnimatedGenderPieChartState extends State<AnimatedGenderPieChart> {
  bool _shouldAnimate = false;

  @override
  Widget build(BuildContext context) {
    final total = (widget.maleCount + widget.femaleCount).toDouble();

    return VisibilityDetector(
      key: const Key('pie_chart_visibility'),
      onVisibilityChanged: (info) {
        if (info.visibleFraction > 0.3 && !_shouldAnimate) {
          setState(() {
            _shouldAnimate = true;
          });
        }
      },
      child: _shouldAnimate
          ? TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              duration: const Duration(seconds: 2),
              curve: Curves.easeInOutCubic,
              builder: (context, value, _) {
                final maleValue = widget.maleCount * value;
                final femaleValue = widget.femaleCount * value;

                return PieChart(
                  PieChartData(
                    sections: [
                      PieChartSectionData(
                        color: Colors.blueAccent,
                        value: maleValue,
                        title: total == 0
                            ? "0%"
                            : "${((maleValue / (maleValue + femaleValue)) * 100).toStringAsFixed(1)}%",
                        titleStyle: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      PieChartSectionData(
                        color: Colors.pinkAccent,
                        value: femaleValue,
                        title: total == 0
                            ? "0%"
                            : "${((femaleValue / (maleValue + femaleValue)) * 100).toStringAsFixed(1)}%",
                        titleStyle: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                    sectionsSpace: 4,
                    centerSpaceRadius: 40,
                  ),
                );
              },
            )
          : const SizedBox(height: 150, width: 150), // placeholder while hidden
    );
  }
}
