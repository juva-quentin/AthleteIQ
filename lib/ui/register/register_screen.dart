import 'package:athlete_iq/ui/providers/position_provider.dart';
import 'package:athlete_iq/ui/register/register_view_model_provider.dart';
import 'package:athlete_iq/utils/visibility.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unicons/unicons.dart';

import '../home/home_view_model_provider.dart';
import '../home/providers/timer_provider.dart';

class RegisterScreen extends ConsumerWidget {
  RegisterScreen({Key, key}) : super(key: key);
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final model = ref.watch(registerViewModelProvider);
    final provider = registerViewModelProvider;
    final chronoProv = timerProvider;
    final modelChrono = ref.watch(timerProvider);
    final positionProv = positionProvider;
    return SafeArea(
      child: AnimatedPadding(
        padding: EdgeInsets.only(
            right: width * .06, left: width * .06, bottom: height * .03),
        duration: const Duration(milliseconds: 100),
        child: Material(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              40.0,
            ),
          ),
          color: Colors.white,
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
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
                                offset:
                                    Offset(0, 3), // changes position of shadow
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
                                        Consumer(
                                            builder: (context, ref, child) {
                                          ref.watch(chronoProv);
                                          return Text(
                                              "${modelChrono.hour.toString().padLeft(2, '0')}:${modelChrono.minute.toString().padLeft(2, '0')}:${modelChrono.seconds.toString().padLeft(2, '0')}");
                                        }),
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
                                        Consumer(
                                            builder: (context, ref, child) {
                                          ref.watch(provider);
                                          return Text(
                                              "${model.totalDistance.toStringAsFixed(2)} KM");
                                        }),
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
                                    onTap:model.changeVisibility,
                                    child: Container(
                                      alignment: Alignment.center,
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
                                            CrossAxisAlignment.center,
                                        children: [
                                          Consumer(
                                              builder: (context, ref, child) {
                                            ref.watch(provider);
                                            switch (model.visibility){
                                              case ParcourVisibility.Public:
                                                return const Text("Public");
                                              case ParcourVisibility.Private:
                                                return const Text("Privé");
                                              case ParcourVisibility.Protected:
                                                return const Text("Entre amis");
                                              default:
                                                return const Text("Public");
                                            }
                                          }),
                                          SizedBox(
                                            height: height * .01,
                                          ),
                                          Consumer(
                                              builder: (context, ref, child) {
                                            ref.watch(chronoProv);
                                            switch (model.visibility){
                                              case ParcourVisibility.Public:
                                                return Icon(UniconsLine.globe, size: height*.05,);
                                              case ParcourVisibility.Private:
                                                return Icon(UniconsLine.lock, size: height*.05);
                                              case ParcourVisibility.Protected:
                                                return Icon(Icons.shield, size: height*.05);
                                              default:
                                                return Icon(UniconsLine.globe, size: height*.05);
                                            }
                                          }),
                                        ],
                                      ),
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
                                        const Text("V/Moyenne"),
                                        SizedBox(
                                          height: height * .02,
                                        ),
                                        Consumer(
                                            builder: (context, ref, child) {
                                          ref.watch(provider);
                                          return Text(
                                              "${model.VM.toStringAsFixed(1)} Km/h");
                                        }),
                                      ],
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
