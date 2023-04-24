import 'package:athlete_iq/ui/parcour-detail/parcour_details_view_model.dart';
import 'package:athlete_iq/ui/register/register_view_model_provider.dart';
import 'package:athlete_iq/utils/visibility.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unicons/unicons.dart';

import '../../utils/utils.dart';
import '../home/providers/timer_provider.dart';
import '../info/provider/user_provider.dart';

class UpdateParcourScreen extends ConsumerWidget {
  UpdateParcourScreen({Key? key}) : super(key: key);
  final _formUpdateKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final model = ref.watch(parcourDetailsViewModel);
    final user = ref.watch(firestoreUserProvider);
    return SafeArea(
      child: AnimatedPadding(
        padding: EdgeInsets.only(right: width * .04, left: width * .04),
        duration: const Duration(milliseconds: 100),
        child: Material(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              40.0,
            ),
          ),
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.only(bottom: height * .02),
            child: SingleChildScrollView(
              child: Form(
                key: _formUpdateKey,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                          width * .03, height * .01, width * .03, height * .01),
                      child: Column(
                        children: [
                          TextFormField(
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                              labelText: "Titre",
                            ),
                          ),
                          SizedBox(
                            width: double.infinity,
                            height: height * .02,
                          ),
                          TextFormField(
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                              labelText: "Description",
                            ),
                            maxLines: 3,
                          ),
                          SizedBox(
                            width: double.infinity,
                            height: height * .02,
                          ),

                          GestureDetector(
                            child: Container(
                              alignment: Alignment.center,
                              width: width * .34,
                              height: height * .12,
                              decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15))),
                              padding: EdgeInsets.fromLTRB(width * .04,
                                  height * .02, width * .04, height * .02),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text("visibility"),
                                  SizedBox(
                                    height: height * .01,
                                  ),
                                  Icon(
                                    Icons.abc,
                                    size: height * .05,
                                  ),
                                ],
                              ),
                            ),
                          ),

                          SizedBox(
                            height: height * .01,
                          ),
                          // model.visibility == ParcourVisibility.Protected
                          //     ? Container(
                          //         padding: const EdgeInsets.all(5),
                          //         decoration: BoxDecoration(
                          //             color: Theme.of(context).primaryColor,
                          //             borderRadius: BorderRadius.circular(30)),
                          //         height: height * .15,
                          //         child: user.when(
                          //           data: (user) {
                          //             return user.friends.isNotEmpty
                          //                 ? ListView.builder(
                          //                     itemCount: user.friends.length,
                          //                     itemBuilder:
                          //                         (BuildContext context,
                          //                             int index) {
                          //                       final friend = ref.watch(
                          //                           firestoreUserFriendsProvider(
                          //                               user.friends[index]));
                          //                       return CheckboxListTile(
                          //                         tileColor: Colors.white,
                          //                         title: friend.when(
                          //                           data: (data) {
                          //                             return Text(data.pseudo);
                          //                           },
                          //                           error: (error,
                          //                                   stackTrace) =>
                          //                               Text(error.toString()),
                          //                           loading: () =>
                          //                               const CircularProgressIndicator(),
                          //                         ),
                          //                         value: model.share.contains(
                          //                             user.friends[index]),
                          //                         onChanged: (bool? value) {
                          //                           model.addRemoveFriend(value,
                          //                               user.friends[index]);
                          //                         },
                          //                       );
                          //                     },
                          //                   )
                          //                 : const Text(
                          //                     'Vous n avez pas encore d amis');
                          //           },
                          //           error: (error, stackTrace) =>
                          //               Text(error.toString()),
                          //           loading: () =>
                          //               const CircularProgressIndicator(),
                          //         ))
                          //     : const SizedBox(),
                          SizedBox(
                            height: height * .01,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              GestureDetector(
                                child: Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.all(width * .05),
                                  decoration: const BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15))),
                                  child: const Text('Annuler'),
                                ),
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              GestureDetector(
                                child: Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.all(width * .05),
                                  decoration: const BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(15))),
                                  child: const Text('Valider'),
                                ),
                                onTap: () async {
                                  try {
                                    Navigator.of(context).pop();
                                  } catch (e) {
                                    Utils.flushBarErrorMessage(
                                        e.toString(), context);
                                  }
                                },
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}