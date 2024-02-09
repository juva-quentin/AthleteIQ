import 'package:athlete_iq/model/User.dart';
import 'package:athlete_iq/ui/info/friend-list/friends_view_model_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/utils.dart';

Widget userTile(
    UserModel user, BuildContext context, WidgetRef ref, bool friendRequest) {
  return Padding(
    padding: EdgeInsets.only(top: 10.h), // Ajusté pour la responsivité
    child: Material(
      elevation: 3.0,
      shadowColor: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(15.r), // Ajusté pour la responsivité
      ),
      child: ListTile(
        onTap: () {},
        leading: user.image.isNotEmpty
            ? CircleAvatar(
                backgroundImage: NetworkImage(user.image),
                radius: 33.r, // Ajusté pour la responsivité
              )
            : null,
        title: Text(
          user.pseudo,
          style: TextStyle(
              fontSize: 17.sp,
              fontWeight: FontWeight.w500), // Ajusté pour la responsivité
        ),
        subtitle: Text(
          friendRequest
              ? "Vous demande en ami"
              : "Depuis lundi ${user.totalDist.toStringAsFixed(2)} Km",
          style: TextStyle(fontSize: 14.sp), // Ajusté pour la responsivité
        ),
        trailing: friendRequest
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () {
                      ref
                          .read(friendsViewModelProvider)
                          .valideInvalideFriend(user, true);
                    },
                    icon: Icon(MdiIcons.accountCheck,
                        size: 24.r), // Ajusté pour la responsivité
                  ),
                  IconButton(
                    onPressed: () {
                      ref
                          .read(friendsViewModelProvider)
                          .valideInvalideFriend(user, false);
                    },
                    icon: Icon(MdiIcons.accountCancel,
                        size: 24.r), // Ajusté pour la responsivité
                  )
                ],
              )
            : IconButton(
                onPressed: () {
                  showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text("Supprimer cet ami",
                            style: TextStyle(
                                fontSize:
                                    16.sp)), // Ajusté pour la responsivité
                        content: Text(
                          "Êtes-vous sur de vouloir supprimer cet ami ?",
                          style: TextStyle(
                              fontSize: 14.sp), // Ajusté pour la responsivité
                        ),
                        actions: [
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(Icons.cancel,
                                color: Colors.red,
                                size: 24.r), // Ajusté pour la responsivité
                          ),
                          IconButton(
                            onPressed: () async {
                              try {
                                await ref
                                    .read(friendsViewModelProvider)
                                    .removeFriend(user)
                                    .then((value) => Navigator.pop(context));
                              } catch (e) {
                                Utils.flushBarErrorMessage(
                                    e.toString(), context);
                              }
                            },
                            icon: Icon(Icons.done,
                                color: Colors.green,
                                size: 24.r), // Ajusté pour la responsivité
                          ),
                        ],
                      );
                    },
                  );
                },
                icon: Icon(MdiIcons.accountCancel,
                    size: 24.r), // Ajusté pour la responsivité
              ),
      ),
    ),
  );
}
