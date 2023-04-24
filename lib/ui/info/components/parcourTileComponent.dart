import 'dart:async';

import 'package:athlete_iq/model/Parcour.dart';
import 'package:athlete_iq/ui/parcour-detail/parcour_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/cli_commands.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../utils/map_utils.dart';

Widget parcourTile(Parcours parcour, BuildContext context, WidgetRef ref) {
  final height = MediaQuery.of(context).size.height;
  final width = MediaQuery.of(context).size.width;
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  return GestureDetector(
    onTap: () {
      Navigator.pushNamed(context, ParcourDetails.route, arguments: parcour);
    },
    child: Card(
      margin: EdgeInsets.only(bottom: height * .02),
      color: Colors.white,
      child: Stack(
        children: [
          Positioned.fill(
            child: Align(
              alignment: const Alignment(0.95, -0.90),
              child: Container(
                decoration: BoxDecoration(
                  color: parcour.type == "Public"
                      ? const Color(0xC005FF0C)
                      : parcour.type == "Protected"
                          ? const Color(0xFFFFF200)
                          : const Color(0xFFFF2100),
                  borderRadius: BorderRadius.circular(50),
                ),
                height: 10,
                width: 10,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(height * .015),
            child: IntrinsicHeight(
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 1),
                        borderRadius: BorderRadius.circular(10)),
                    height: 100,
                    width: 100,
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
                              25));
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    width: width * .05,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          parcour.title.capitalize(),
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w600),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                "${parcour.totalDistance.toStringAsFixed(2)}Km",
                                style: const TextStyle(
                                    color: Colors.black45,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500)),
                            Text("${parcour.VM.toStringAsFixed(2)}Km/h",
                                style: const TextStyle(
                                    color: Colors.black45,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500)),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                "${parcour.timer.hours.toString().padLeft(2, '0')}:${parcour.timer.minutes.toString().padLeft(2, '0')}:${parcour.timer.seconds.toString().padLeft(2, '0')}",
                                style: const TextStyle(
                                    color: Colors.black45,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500)),
                            Text(DateFormat.yMd().format(parcour.createdAt),
                                style: const TextStyle(
                                    color: Colors.black45,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500)),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
