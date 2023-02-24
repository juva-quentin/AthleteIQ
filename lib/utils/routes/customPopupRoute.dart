// 1
import 'package:flutter/material.dart';

class CustomPopupRoute extends PopupRoute {
  // 2
  CustomPopupRoute({
    required this.builder,
    RouteSettings? settings,
  }) : super(settings: settings);

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
  Duration get transitionDuration => const Duration(milliseconds: 300);

  // 5
  @override
  Widget buildPage(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      ) => builder(context);

}
