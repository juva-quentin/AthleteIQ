import 'dart:async';

import 'package:athlete_iq/model/Parcour.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../model/Groups.dart';

Widget parcourTile(Parcours parcour, BuildContext context, WidgetRef ref) {
  final height = MediaQuery.of(context).size.height;
  final width = MediaQuery.of(context).size.width;
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  return Card(
    margin: EdgeInsets.only(bottom: height*.02),
    color: Colors.white,
    child:  Padding(
      padding: EdgeInsets.all(height*.015),
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
                        polylineId: const PolylineId("running"),
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
                    initialCameraPosition: CameraPosition(
                      target: LatLng(
                          parcour.allPoints
                              .elementAt(parcour.allPoints.length ~/ 2)
                              .latitude!,
                          parcour.allPoints
                              .elementAt(parcour.allPoints.length ~/ 2)
                              .longitude!),
                      zoom: parcour.totalDistance > 100 ?  4 : parcour.totalDistance > 60 ? 6 : parcour.totalDistance > 2 ? 11 : 14,
                    ),
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
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
                    Text(parcour.title.toString(), style: const TextStyle(color: Colors.black45, fontSize: 20, fontWeight: FontWeight.w600),),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("${parcour.totalDistance.toStringAsFixed(2)}Km", style: const TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w500)),
                        Text("${parcour.VM.toStringAsFixed(2)}Km/h", style: const TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w500)),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                            "${parcour.timer.hours.toString().padLeft(2, '0')}:${parcour.timer.minutes.toString().padLeft(2, '0')}:${parcour.timer.seconds.toString().padLeft(2, '0')}", style: const TextStyle(color: Colors.black, fontSize: 17, fontWeight: FontWeight.w500)),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
      ),
    ),

  );
}
