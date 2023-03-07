import 'package:athlete_iq/ui/register/register_view_model_provider.dart';
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
                    padding: EdgeInsets.only(
                        top: height * .01, left: width * .03, right: width * .03),
                    child: TextFormField(
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        labelText: "Titre",
                      ),
                      onChanged: (v) => model.title = v,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(
                        width * .03, height * .03, width * .03, 0),
                    child: Container(
                      padding: EdgeInsets.all(width * .05),
                      width: double.infinity,
                      height: height * .3,
                      decoration: BoxDecoration(
                        color: const Color(0xFF72B0EA),
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 6,
                            color: Color(0x8757636C),
                            offset: Offset(0, 1),
                          )
                        ],
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    15, 10, 10, 0),
                                width: 150,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("Temps",
                                        style: TextStyle(
                                          color:
                                              Color.fromARGB(255, 176, 176, 176),
                                        )),
                                    const SizedBox(height: 3),
                                    Consumer(builder: (context, ref, child) {
                                      final chrono = ref.watch(timerProvider);
                                      return Text(
                                        '${chrono.hour}h : ${chrono.minute}m : ${chrono.seconds}s ',
                                        style: GoogleFonts.inter(
                                          textStyle: const TextStyle(
                                              letterSpacing: .5,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      );
                                    }),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    15, 10, 10, 0),
                                width: 130,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("Distance",
                                        style: TextStyle(
                                          color:
                                              Color.fromARGB(255, 176, 176, 176),
                                        )),
                                    const SizedBox(height: 3),
                                    Text(
                                      "${model.totalDistance.toStringAsFixed(2)} Km",
                                      style: GoogleFonts.inter(
                                        textStyle: const TextStyle(
                                            letterSpacing: .5,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Column(children: [
                                Container(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      10, 0, 10, 0),
                                  width: 150,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      const Text("D+",
                                          style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 176, 176, 176),
                                          )),
                                      Text(
                                        "0.0m",
                                        style: GoogleFonts.inter(
                                          textStyle: const TextStyle(
                                              letterSpacing: .5,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      10, 0, 10, 0),
                                  width: 150,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      const Text("D-",
                                          style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 176, 176, 176),
                                          )),
                                      Text(
                                        "0.0m",
                                        style: GoogleFonts.inter(
                                          textStyle: const TextStyle(
                                              letterSpacing: .5,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ]),
                              Container(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    15, 10, 10, 0),
                                width: 130,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("V/Moyenne",
                                        style: TextStyle(
                                          color:
                                              Color.fromARGB(255, 176, 176, 176),
                                        )),
                                    const SizedBox(height: 3),
                                    Consumer(builder: (context, ref, child) {
                                      return Text(
                                        "${model.VM.toStringAsFixed(0)} Km/h",
                                        style: GoogleFonts.inter(
                                          textStyle: const TextStyle(
                                              letterSpacing: .5,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      );
                                    })
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
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
