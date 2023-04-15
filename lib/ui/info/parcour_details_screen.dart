import 'dart:async';

import 'package:athlete_iq/model/Parcour.dart';
import 'package:athlete_iq/ui/info/parcour_details_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unicons/unicons.dart';

import '../../app/app.dart';
import '../../data/network/userRepository.dart';
import '../../model/User.dart';
import '../../utils/map_utils.dart';

class ParcourDetails extends ConsumerWidget {
  const ParcourDetails(this.args, {Key? key}) : super(key: key);
  final Object args;

  static const route = "/parcours/details";
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final userRepo = ref.watch(userRepositoryProvider);
    final Completer<GoogleMapController> _controller =
        Completer<GoogleMapController>();
    final Parcours parcour = args as Parcours;
    final model = ref.watch(parcourDetailsViewModel);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(UniconsLine.arrow_left, size: width * .1),
            onPressed: () =>
                Navigator.pushReplacementNamed(context, App.route)),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      extendBodyBehindAppBar: true,
      body: ListView(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 1),
                    borderRadius: BorderRadius.circular(10)),
                height: height * .5,
                width: width,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                    10.0,
                  ),
                  child: GoogleMap(
                    polylines: {
                      Polyline(
                        polylineId: PolylineId(parcour.title),
                        points: parcour.allPoints
                            .map((e) => LatLng(e.latitude!, e.longitude!))
                            .toList(),
                        width: 4,
                        color: Colors.blue,
                      )
                    },
                    compassEnabled: false,
                    mapToolbarEnabled: false,
                    zoomControlsEnabled: false,
                    zoomGesturesEnabled: false,
                    scrollGesturesEnabled: false,
                    myLocationButtonEnabled: false,
                    mapType: MapType.normal,
                    initialCameraPosition: const CameraPosition(
                      target: LatLng(0, 0),
                      zoom: 11,
                    ),
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                      controller.animateCamera(CameraUpdate.newLatLngBounds(
                          MapUtils.boundsFromLatLngList(parcour.allPoints
                              .map((e) => LatLng(e.latitude!, e.longitude!))
                              .toList()),
                          50));
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  parcour.title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 23),
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 15, 0, 0),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.903,
                  height: MediaQuery.of(context).size.height * 0.07,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Card(
                          color: Colors.white,
                          elevation: 3,
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              FutureBuilder<UserModel>(
                                  future: userRepo.getUserWithId(
                                      userId: parcour.owner),
                                  builder: (context,
                                      AsyncSnapshot<UserModel> snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const CircularProgressIndicator();
                                    } else if (snapshot.connectionState ==
                                        ConnectionState.done) {
                                      if (snapshot.hasError) {
                                        return const Text('Erreur');
                                      } else if (snapshot.hasData) {
                                        return Column(
                                          children: [
                                            const Text(
                                              "Créateur",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text("${snapshot.data?.pseudo}"),
                                          ],
                                        );
                                      } else {
                                        return const Text('Empty data');
                                      }
                                    } else {
                                      return Text(
                                          'State: ${snapshot.connectionState}');
                                    }
                                  }),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Card(
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          color: Colors.white,
                          elevation: 3,
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Temps total',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '${parcour.timer.hours.toString().padLeft(2, '0')}:${parcour.timer.minutes.toString().padLeft(2, '0')}:${parcour.timer.seconds.toString().padLeft(2, '0')}',
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                          child: Card(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        color: Colors.white,
                        elevation: 3,
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Distance',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "${parcour.totalDistance.toStringAsFixed(2)}Km",
                            ),
                          ],
                        ),
                      ),)
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 25, 0, 0),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(10),
                    shape: BoxShape.rectangle,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  5, 5, 5, 5),
                              child: Card(
                                color: Colors.white,
                                elevation: 3,
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      5, 5, 5, 5),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'Vitesse maximale',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                          "${model.caculatMaxSpeed(parcour)?.toStringAsFixed(2)}Km/h"),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  5, 5, 5, 5),
                              child: Card(
                                color: Colors.white,
                                elevation: 3,
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      5, 5, 5, 5),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'Vitesse minimum',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                          "${model.calculatMinSpeed(parcour)! >= 0.0 ? model.calculatMinSpeed(parcour) : 0.0 .toStringAsFixed(2)}Km/h"),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  5, 5, 5, 5),
                              child: Card(
                                color: Colors.white,
                                elevation: 3,
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      5, 5, 5, 5),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'Vitesse moyenne',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                          "${parcour.VM.toStringAsFixed(2)}Km/h"),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  5, 5, 5, 5),
                              child: Card(
                                color: Colors.white,
                                elevation: 3,
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      5, 5, 5, 5),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'Distance Totale',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                          "${parcour.totalDistance.toStringAsFixed(2)}Km"),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 25, 0, 0),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(10),
                    shape: BoxShape.rectangle,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  5, 5, 5, 5),
                              child: Card(
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      5, 5, 5, 5),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'Altitude maximal',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        '${model.caculatMaxAltitude(parcour)?.toStringAsFixed(2)}m',
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  5, 5, 5, 5),
                              child: Card(
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      5, 5, 5, 5),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'Altitude minimale',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        '${model.calculatMinAltitude(parcour)?.toStringAsFixed(2)}m',
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 15, 0, 15),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Color(0xFFEFEFEF),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsetsDirectional.fromSTEB(10, 10, 10, 10),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Description',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                          child: Text(parcour.description.isEmpty
                              ? "Pas de description"
                              : parcour.description),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
