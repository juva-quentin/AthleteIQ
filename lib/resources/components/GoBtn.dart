import 'package:athlete_iq/ui/register/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../ui/home/home_view_model_provider.dart';
import '../../utils/routes/customPopupRoute.dart';
import '../../utils/utils.dart';

class GoBtn extends ConsumerWidget {
  const GoBtn({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final optionBtnheight = height * .06;
    final optionBtnWidth = height * .06;
    final provider = homeViewModelProvider;
    final model = ref.read(homeViewModelProvider);
    return Consumer(builder: (context, ref, child) {
      ref.watch(provider.select((value) => value.courseStart));
      return GestureDetector(
        onTap: () async {
          if (!model.courseStart) {
            try {
              await model.register();
            } catch (e) {
              Utils.flushBarErrorMessage(e.toString(), context);
            }
          } else {
            try {
              await model.register().then(
                    (value) => Navigator.of(context).push(
                      CustomPopupRoute(
                        builder: (BuildContext context) {
                          return RegisterScreen();
                        },
                      ),
                    ),
                  );
            } catch (e) {
              Utils.flushBarErrorMessage(e.toString(), context);
            }
          }
        },
        child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              color: !model.courseStart
                  ? Theme.of(context).primaryColor.withOpacity(0.9)
                  : Colors.red.withOpacity(1),
              borderRadius: BorderRadius.circular(!model.courseStart ? 30 : 10),
            ),
            height: optionBtnheight,
            width: !model.courseStart ? optionBtnWidth : width * .50,
            child: Center(
                child: Text(
              !model.courseStart ? 'GO' : 'STOP',
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 19,
                  fontWeight: FontWeight.bold),
            ))),
      );
    });
  }
}
