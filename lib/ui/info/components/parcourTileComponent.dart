import 'dart:async';

import 'package:athlete_iq/model/Parcour.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../model/Groups.dart';

Widget parcourTile(Parcours parcour, BuildContext context, WidgetRef ref) {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  return Padding(
    padding: const EdgeInsets.only(top: 10.0),
    child: Card(
      color: Colors.white,
      child: ListTile(
        onTap: () {},
        leading: Container(
          height: 100,
          width: 90,
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
            mapType: MapType.hybrid,
            initialCameraPosition: CameraPosition(
              target: LatLng(
                  parcour.allPoints
                      .elementAt(parcour.allPoints.length ~/ 2)
                      .latitude!,
                  parcour.allPoints
                      .elementAt(parcour.allPoints.length ~/ 2)
                      .longitude!),
              zoom: 5,
            ),
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),
        ),
        title: Text(parcour.title,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500)),
        subtitle: Text(
          parcour.description.length >= 30
              ? parcour.description.substring(0, 30)
              : parcour.description,
          style: TextStyle(color: Colors.grey),
        ),
        trailing: Text("${DateFormat.yMd().format(parcour.createdAt)}"),
      ),
    ),
  );
}
