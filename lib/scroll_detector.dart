import 'package:flutter/material.dart';

class ScrollDetector extends StatefulWidget {
  const ScrollDetector({
    required this.builder,
    required this.loadNext,
    required this.threshold,
    required this.scrollController,
  });

  final Widget Function(BuildContext) builder;
  final VoidCallback loadNext;
  final double threshold;
  final ScrollController scrollController;

  @override
  _ScrollDetectorState createState() => _ScrollDetectorState();
}

class _ScrollDetectorState extends State<ScrollDetector> {
  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(() {
      final scrollValue = widget.scrollController.offset /
          widget.scrollController.position.maxScrollExtent;
      if (scrollValue > widget.threshold) {
        widget.loadNext();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context);
  }

  @override
  void dispose() {
    print('dispose!');
    widget.scrollController.dispose();
    super.dispose();
  }
}
