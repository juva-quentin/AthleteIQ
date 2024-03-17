import 'package:flutter/material.dart';

class MiddleAnimatedBar extends StatelessWidget {
  const MiddleAnimatedBar({
    super.key,
    required this.isActive,
  });

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: 2,
      width: isActive ? 60 : 0,
      decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: const BorderRadius.all(Radius.circular(12))),
    );
  }
}
