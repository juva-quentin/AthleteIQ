import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../ui/home/home_view_model_provider.dart';
import '../size.dart';

class GoBtn extends ConsumerWidget {
  const GoBtn({Key? key}) : super (key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppSize appSize = AppSize(context);
    final height = appSize.globalHeight;
    final width = appSize.globalWidth;
    final optionBtnHeigth =  height * .06;
    final optionBtnWidth = width * .5;
    final provider = homeViewModelProvider;
    final model = ref.read(homeViewModelProvider);
    return Consumer( builder: (context, ref, child)  {
      ref.watch(
          provider.select((value) => value.courseStart));
      return GestureDetector(
          onTap: (){model.courseStart = !model.courseStart; model.register();},
          child: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              decoration: BoxDecoration(
                color: !model.courseStart? Theme.of(context).primaryColor.withOpacity(0.85) : Colors.red.withOpacity(0.85),
                borderRadius: BorderRadius.circular(!model.courseStart? 30 : 10),
              ),
              height: optionBtnHeigth,
              width:!model.courseStart? optionBtnWidth*.26 : optionBtnWidth,
              child:  Center(child: Text (!model.courseStart? 'GO' : 'STOP', style: const TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.bold),))
          ),
        );
      }
    );
  }
}