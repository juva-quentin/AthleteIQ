import 'package:athlete_iq/ui/register/register_view_model_provider.dart';
import 'package:athlete_iq/utils/visibility.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../utils/utils.dart';
import '../home/providers/timer_provider.dart';
import '../info/provider/user_provider.dart';

class RegisterScreen extends ConsumerWidget {
  RegisterScreen({super.key});
  final _formRegisterKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final model = ref.watch(registerViewModelProvider);
    final modelChrono = ref.watch(timerProvider);
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
                key: _formRegisterKey,
                child: Column(
                  children: [
                    SizedBox(
                      height: height * .3,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                          40.0,
                        ),
                        child: GoogleMap(
                          polylines: model.polylines,
                          indoorViewEnabled: true,
                          myLocationButtonEnabled: false,
                          mapType: MapType.normal,
                          onMapCreated: model.onMapCreated,
                          initialCameraPosition: model.initialPosition,
                          scrollGesturesEnabled: false,
                        ),
                      ),
                    ),
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
                            onChanged: (v) => model.title = v,
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
                            onChanged: (v) => model.description = v,
                            maxLines: 3,
                          ),
                          SizedBox(
                            width: double.infinity,
                            height: height * .02,
                          ),
                          Container(
                            padding: EdgeInsets.fromLTRB(width * .05,
                                height * .02, width * .05, height * .02),
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(30),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Theme.of(context)
                                      .shadowColor
                                      .withOpacity(0.15),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: const Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            height: height * .3,
                            width: double.infinity,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      width: width * .34,
                                      height: height * .12,
                                      decoration: const BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15))),
                                      padding: EdgeInsets.fromLTRB(
                                          width * .04,
                                          height * .02,
                                          width * .04,
                                          height * .02),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text("Temps"),
                                          SizedBox(
                                            height: height * .02,
                                          ),
                                          Text(
                                              "${modelChrono.hour.toString().padLeft(2, '0')}:${modelChrono.minute.toString().padLeft(2, '0')}:${modelChrono.seconds.toString().padLeft(2, '0')}"),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      width: width * .34,
                                      height: height * .12,
                                      decoration: const BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15))),
                                      padding: EdgeInsets.fromLTRB(
                                          width * .04,
                                          height * .02,
                                          width * .04,
                                          height * .02),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text("Distance"),
                                          SizedBox(
                                            height: height * .02,
                                          ),
                                          Text(
                                              "${model.totalDistance.toStringAsFixed(2)} KM"),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    GestureDetector(
                                      onTap: model.changeVisibility,
                                      child: Container(
                                        alignment: Alignment.center,
                                        width: width * .34,
                                        height: height * .13,
                                        decoration: const BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(15))),
                                        padding: EdgeInsets.fromLTRB(
                                            width * .04,
                                            height * .02,
                                            width * .04,
                                            height * .02),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(model.switchCaseVisibility()),
                                            SizedBox(
                                              height: height * .01,
                                            ),
                                            Icon(
                                              model.switchCaseIconVisibility(),
                                              size: height * .05,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      width: width * .34,
                                      height: height * .13,
                                      decoration: const BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15))),
                                      padding: EdgeInsets.fromLTRB(
                                          width * .04,
                                          height * .02,
                                          width * .04,
                                          height * .02),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text("V/Moyenne"),
                                          SizedBox(
                                            height: height * .02,
                                          ),
                                          Text(
                                              "${model.VM.toStringAsFixed(1)} Km/h"),
                                        ],
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: height * .01,
                          ),
                          model.visibility == ParcourVisibility.Protected
                              ? Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor,
                                      borderRadius: BorderRadius.circular(30)),
                                  height: height * .15,
                                  child: user.when(
                                    data: (user) {
                                      return user.friends.isNotEmpty
                                          ? ListView.builder(
                                              itemCount: user.friends.length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                final friend = ref.watch(
                                                    firestoreUserFriendsProvider(
                                                        user.friends[index]));
                                                return CheckboxListTile(
                                                  tileColor: Colors.white,
                                                  title: friend.when(
                                                    data: (data) {
                                                      return Text(data.pseudo);
                                                    },
                                                    error: (error,
                                                            stackTrace) =>
                                                        Text(error.toString()),
                                                    loading: () =>
                                                        const CircularProgressIndicator(),
                                                  ),
                                                  value: model.share.contains(
                                                      user.friends[index]),
                                                  onChanged: (bool? value) {
                                                    model.addRemoveFriend(value,
                                                        user.friends[index]);
                                                  },
                                                );
                                              },
                                            )
                                          : const Text(
                                              'Vous n avez pas encore d amis');
                                    },
                                    error: (error, stackTrace) =>
                                        Text(error.toString()),
                                    loading: () =>
                                        const CircularProgressIndicator(),
                                  ))
                              : const SizedBox(),
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
                                  try{
                                    model.register();
                                    Navigator.of(context).pop();
                                  }catch(e){
                                    Utils.flushBarErrorMessage(e.toString(), context);
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
