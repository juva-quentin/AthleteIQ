import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../utils/routes/customPopupRoute.dart';
import '../createGroup_screen.dart';
import '../providers/create_group_view_model_provider.dart';

Widget noGroupWidget(WidgetRef ref, BuildContext context) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 200),
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
            size: 75,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        const Text(
          "Vous n'avez rejoint aucun groupe, tapez sur l'icône pour créer un groupe. Vous pouvez aussi en chercher un depuis le boutton de recherche en haut.",
          textAlign: TextAlign.center,
        )
      ],
    ),
  );
}