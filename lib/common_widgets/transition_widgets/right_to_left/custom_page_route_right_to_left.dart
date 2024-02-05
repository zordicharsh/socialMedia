import 'package:flutter/material.dart';

class CustomPageRouteRightToLeft extends PageRouteBuilder {
  final Widget child;

  CustomPageRouteRightToLeft({
    required this.child,
  }) : super(pageBuilder: (context, animation, secondaryAnimation) => child,barrierColor: Colors.black45,transitionDuration: const Duration(milliseconds: 200),reverseTransitionDuration: const Duration(milliseconds: 200));

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return SlideTransition(
        position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
            .animate(animation),
        child: child);
  }

}
