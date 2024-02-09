import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../utils/routes/customPopupRoute.dart';
import '../create-group-screen/createGroup_screen.dart';
import '../create-group-screen/create_group_view_model_provider.dart';

Widget noGroupWidget(WidgetRef ref, BuildContext context) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 200.h),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () async {
            await Navigator.of(context).push(
              CustomPopupRoute(
                builder: (BuildContext context) {
                  return CreateGroupScreen();
                },
              ),
            );
            ref.read(creatGroupViewModelProvider).clear();
          },
          child: Icon(
            Icons.add_circle,
            color: Colors.grey[700],
            size: 75.r, // Ajusté pour la responsivité
          ),
        ),
        SizedBox(
          height: 20.h, // Ajusté pour la responsivité
        ),
        Text(
          "Vous n'avez rejoint aucun groupe, tapez sur l'icône pour créer un groupe. Vous pouvez aussi en chercher un depuis le bouton de recherche en haut.",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14.sp, // Ajusté pour la responsivité
          ),
        )
      ],
    ),
  );
}
