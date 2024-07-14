import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoadingWidget extends StatelessWidget {
  final double containerWidth;

  const LoadingWidget({super.key, required this.containerWidth});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: containerWidth,
      child: Center(
        child: LoadingAnimationWidget.twistingDots(
          leftDotColor: const Color(0xFF1A1A3F),
          rightDotColor: const Color(0xFFEA3799),
          size: containerWidth / 8,
        ),
      ),
    );
  }
}
