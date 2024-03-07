import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';

class AnimatedDialog extends StatefulWidget {
  const AnimatedDialog({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  State<StatefulWidget> createState() => AnimatedDialogState();
}

class AnimatedDialogState extends State<AnimatedDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> opacityAnimation;
  late Animation<double> scaleAnimation;
  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    scaleAnimation =
        CurvedAnimation(parent: controller, curve: Curves.easeOutExpo);
    opacityAnimation = Tween<double>(begin: 0.0, end: 0.6).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeOutExpo));
    controller.forward();
  }
  @override
  void dispose() {
    controller.dispose();
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black.withOpacity(opacityAnimation.value),
      child: Center(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5,sigmaY:5),
          child: FadeTransition(
            opacity: scaleAnimation,
            child: ScaleTransition(
              scale: scaleAnimation,
              child: widget.child,
            ),
          ),
        ),
      ),
    );
  }
}