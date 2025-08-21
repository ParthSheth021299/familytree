import 'package:flutter/material.dart';

class AnimatedSectionList extends StatefulWidget {
  final List<Widget> children;

  const AnimatedSectionList({super.key, required this.children});

  @override
  State<AnimatedSectionList> createState() => _AnimatedSectionListState();
}

class _AnimatedSectionListState extends State<AnimatedSectionList>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600), // slower, smoother
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.children.asMap().entries.map((entry) {
        final index = entry.key;
        final child = entry.value;

        // instead of fully separate, let them overlap (0.15 apart)
        final start = index * 0.15;
        final end = start + 0.6;

        final animation = CurvedAnimation(
          parent: _controller,
          curve: Interval(
            start.clamp(0.0, 1.0),
            end.clamp(0.0, 1.0),
            curve: Curves.easeOutQuint,
          ),
        );

        return AnimatedBuilder(
          animation: animation,
          builder: (context, _) {
            return Opacity(
              opacity: animation.value,
              child: Transform.translate(
                offset: Offset(0, 20 * (1 - animation.value)), // softer slide
                child: child,
              ),
            );
          },
        );
      }).toList(),
    );
  }
}
