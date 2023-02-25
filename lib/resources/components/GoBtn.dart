import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/riverpods/variable_pod.dart';

class GoBtn extends StatelessWidget {
  const GoBtn({Key? key, required this.optionBtnHeigth, required this.optionBtnWidth, required this.onPress}) : super (key: key);
  final double optionBtnHeigth;
  final double optionBtnWidth;
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    final optionBtnHeigth =  this.optionBtnHeigth ;
    final optionBtnWidth = this.optionBtnWidth;

    return Consumer(builder: (context, ref, _) {
      var isActive = ref.watch(courseStart);
      return GestureDetector(
          onTap: onPress,
          child: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              decoration: BoxDecoration(
                color: !isActive? Theme.of(context).primaryColor.withOpacity(0.85) : Colors.red.withOpacity(0.85),
                borderRadius: BorderRadius.circular(!isActive? 30 : 10),
              ),
              height: optionBtnHeigth,
              width:!isActive? optionBtnWidth*.26 : optionBtnWidth,
              child:  Center(child: Text (!isActive? 'GO' : 'STOP', style: const TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.bold),))
          ),
        );
      }
    );
  }
}