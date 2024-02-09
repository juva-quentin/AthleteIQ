import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../resources/components/middleAnimatedBar.dart';
import '../info_screen.dart';
import '../info_view_model_provider.dart';

// Assurez-vous que `middleNav` est défini quelque part dans votre code, car il est référencé ici.

Widget buildMiddleNavInfo() {
  return Consumer(builder: (context, ref, child) {
    final model = ref.watch(infoViewModelProvider);
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal:
              0.03.sw), // Utilisation de ScreenUtil pour le padding horizontal
      child: SizedBox(
        height: 0.05.sh, // Hauteur définie par ScreenUtil
        child: Row(
          children: [
            ...List.generate(
              middleNav.length,
              (index) => GestureDetector(
                onTap: () {
                  if (middleNav[index] != model.selectedBottomNav) {
                    model.selectedBottomNav = middleNav[index];
                    model.selectedIndex = index;
                  }
                },
                child: Padding(
                  padding: EdgeInsets.only(
                      right: 0.04.sw), // Espacement à droite avec ScreenUtil
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Opacity(
                        opacity: middleNav[index] == model.selectedBottomNav
                            ? 1
                            : 0.5,
                        child: Text(middleNav[index],
                            style: TextStyle(
                                fontSize: 14
                                    .sp)), // Taille de police ajustée avec ScreenUtil
                      ),
                      SizedBox(
                          height: 3.h), // Espacement en hauteur avec ScreenUtil
                      MiddleAnimatedBar(
                        isActive: middleNav[index] == model.selectedBottomNav,
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  });
}
