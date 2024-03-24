// 1
import 'package:flutter/material.dart';

class CustomPopupRoute extends PopupRoute {
  // 2
  CustomPopupRoute({
    required this.builder,
    super.settings,
  });

  final WidgetBuilder builder;

  // 3
  @override
  Color get barrierColor => Colors.black54.withAlpha(100);
  @override
  bool get barrierDismissible => true;
  @override
  String get barrierLabel => 'customPopupRoute';

  // 4
  @override
  Widget buildPage(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      ) {
    return builder(context);
  }

  @override
  Widget buildTransitions(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Widget child,
      ) {
    return  ScaleTransition(
        scale: animation,
        child: child,
    );
  }

  @override
  Duration get transitionDuration => const Duration(milliseconds: 150);
}