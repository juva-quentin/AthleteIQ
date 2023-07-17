
import 'package:athlete_iq/model/User.dart';
import 'package:athlete_iq/ui/info/friend-list/friends_view_model_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../utils/utils.dart';

Widget userTile(
    UserModel user, BuildContext context, WidgetRef ref, bool friendRequest) {
  final height = MediaQuery.of(context).size.height;
  final width = MediaQuery.of(context).size.width;

  return Padding(
    padding: const EdgeInsets.only(top: 10.0),
    child: Material(
      elevation: 3.0,
      shadowColor: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
          onTap: () {},
          leading: user.image.isNotEmpty
              ? CircleAvatar(
                  backgroundImage: NetworkImage(user.image),
                  radius: 33,
                )
              : null,
          title: Text(user.pseudo,
              style:
                  const TextStyle(fontSize: 17, fontWeight: FontWeight.w500)),
          subtitle: Text(friendRequest
              ? "Vous demande en ami"
              : "Depuis lundi ${user.totalDist.toStringAsFixed(2)} Km"),
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
                        icon: Icon(MdiIcons.accountCheck)),
                    IconButton(
                        onPressed: () {
                          ref
                              .read(friendsViewModelProvider)
                              .valideInvalideFriend(user, false);
                        },
                        icon: Icon(MdiIcons.accountCancel))
                  ],
                )
              : IconButton(
                  onPressed: () {
                    showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text("Supprimer cet ami"),
                            content: const Text(
                                "Êtes-vous sur de vouloir supprimer cet ami ?"),
                            actions: [
                              IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: const Icon(
                                  Icons.cancel,
                                  color: Colors.red,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.done,
                                  color: Colors.green,
                                ),
                                onPressed: () async {
                                  try {
                                    await ref.read(friendsViewModelProvider).removeFriend(user).then((value) => Navigator.pop(context));
                                    
                                  } catch (e) {
                                    Utils.flushBarErrorMessage(
                                        e.toString(), context);
                                  }
                                },
                              ),
                            ],
                          );
                        });

                  },
                  icon: Icon(MdiIcons.accountCancel))),
    ),
  );
}
