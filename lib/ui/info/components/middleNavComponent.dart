import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../resources/components/middleAnimatedBar.dart';
import '../info_screen.dart';
import '../info_view_model_provider.dart';

Widget buildMiddleNavInfo(double height, double width) {
  return SizedBox(
    height: height * .05,
    child: Consumer(builder: (context, ref, child) {
      final model = ref.watch(infoViewModelProvider);
      return Padding(
        padding: EdgeInsets.only(
            right: width * .03, left: width * .03),
        child: Row(
          children: [
            ...List.generate(
              middleNav.length,
                  (index) => GestureDetector(
                onTap: () {
                  if (middleNav[index] !=
                      model.selectedBottomNav) {
                    model.selectedBottomNav = middleNav[index];
                    model.selectedIndex = index;
                  }
                },
                child: Padding(
                  padding: EdgeInsets.only(right: width * .04),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Opacity(
                          opacity: middleNav[index] ==
                              model.selectedBottomNav
                              ? 1
                              : 0.5,
                          child: Text(middleNav[index])),
                      const SizedBox(height: 3),
                      MiddleAnimatedBar(
                          isActive: middleNav[index] ==
                              model.selectedBottomNav),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      );
    }),
  );
}