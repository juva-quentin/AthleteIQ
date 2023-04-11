import 'dart:async';

import 'package:athlete_iq/model/Parcour.dart';
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
  const ParcourDetails(this.args, {Key, key}) : super(key: key);
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
      body: SafeArea(
          top: false,
          child: Container(
            width: width,
            height: height,
            child: Column(
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
                Text(
                  parcour.title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 23),
                ),
                Text(parcour.description.isEmpty
                    ? "Pas de description"
                    : parcour.description),
                FutureBuilder<UserModel>(
                    future: userRepo.getUserWithId(userId: parcour.owner),
                    builder: (context, AsyncSnapshot<UserModel> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.connectionState ==
                          ConnectionState.done) {
                        if (snapshot.hasError) {
                          return const Text('Erreur');
                        } else if (snapshot.hasData) {
                          return Text("Crée par: ${snapshot.data?.pseudo}");
                        } else {
                          return const Text('Empty data');
                        }
                      } else {
                        return Text('State: ${snapshot.connectionState}');
                      }
                    }),
                Text("Type: ${parcour.type}"),
                Text(
                    "Temps total: ${parcour.timer.hours.toString().padLeft(2, '0')}:${parcour.timer.minutes.toString().padLeft(2, '0')}:${parcour.timer.seconds.toString().padLeft(2, '0')}"),
                Text("Distance totale: ${parcour.totalDistance.toStringAsFixed(2)}Km"),
                Text("Vitesse moyenne: ${parcour.VM.toStringAsFixed(2)}Km/h"),
                Text("Vitesse maximale: ${parcour.VM.toStringAsFixed(2)}Km/h"),
                Text("Vitesse minimum: ${parcour.VM.toStringAsFixed(2)}Km/h"),
                Text("Altitude maximum: ${parcour.VM.toStringAsFixed(2)}m"),
                Text("Altitude minimum: ${parcour.VM.toStringAsFixed(2)}m"),
              ],
            ),
          )),
    );
  }
}
