// widget/rotating_arrow_drop_icon.dart
import 'package:flutter/material.dart';

class RotatingArrowDropIcon extends StatefulWidget {
  final bool isExpanded;

  RotatingArrowDropIcon({required this.isExpanded});

  @override
  _RotatingArrowDropIconState createState() => _RotatingArrowDropIconState();
}

class _RotatingArrowDropIconState extends State<RotatingArrowDropIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
      lowerBound: 0,
      upperBound: 0.5,
    );

    if (widget.isExpanded) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  void didUpdateWidget(RotatingArrowDropIcon oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isExpanded != oldWidget.isExpanded) {
      if (widget.isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _controller,
      child: Icon(Icons.arrow_drop_down),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

