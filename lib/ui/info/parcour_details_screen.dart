import 'dart:async';

import 'package:athlete_iq/model/Parcour.dart';
import 'package:athlete_iq/ui/info/parcour_details_view_model.dart';
import 'package:athlete_iq/utils/stringCapitalize.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unicons/unicons.dart';

import '../../utils/map_utils.dart';
import 'components/caractéristiqueComponent.dart';

class ParcourDetails extends ConsumerWidget {
  const ParcourDetails(this.args, {Key? key}) : super(key: key);
  final Object args;
  static const route = "/parcours/details";
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final Completer<GoogleMapController> _controller =
        Completer<GoogleMapController>();
    final Parcours parcour = args as Parcours;
    final model = ref.watch(parcourDetailsViewModel);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300.0,
            flexibleSpace: FlexibleSpaceBar(
              title: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.9),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Text(
                  parcour.title.capitalize(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              background: GoogleMap(
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
            pinned: true,
            leading: IconButton(
              icon: Icon(UniconsLine.arrow_left, size: width * .1),
              onPressed: () =>
                  Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: Icon(UniconsLine.heart, size: width * .1),
                onPressed: () =>print("add to favori"),
              ),
              IconButton(
                icon: Icon(Icons.menu, size: width * .1),
                onPressed: () {
                  showMenu(
                    context: context,
                    position: RelativeRect.fromLTRB(
                      width, 100, 0,0
                    ),
                    items: [
                      PopupMenuItem(
                        value: "modifier",
                        child: Row(
                          children: const [
                            Icon(Icons.edit),
                            SizedBox(width: 10),
                            Text("Modifier"),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: "supprimer",
                        child: Row(
                          children: const [
                            Icon(Icons.delete),
                            SizedBox(width: 10),
                            Text("Supprimer"),
                          ],
                        ),
                      ),
                    ],
                    elevation: 8.0,
                  ).then((value) {
                    if (value == "Modifier") {
                      // Gérer l'action de modification
                    } else if (value == "Supprimer") {
                      // Gérer l'action de suppression
                    }
                  });
                },
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.all(width *.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24.0,
                    ),
                  ),
                  SizedBox(height: height *.02),
                  Text(
                    parcour.description.isNotEmpty ? parcour.description : 'Aucune description',
                    style: const TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                  SizedBox(height: height *.04),
                  const Text(
                    'Caractéristiques',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24.0,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: height *.007),
                      CaracteristiqueWidget(
                        iconData: Icons.speed,
                        label: 'Vitesse moyenne',
                        value: parcour.VM.toStringAsFixed(2),
                        unit: 'km/h',
                      ),
                      const Divider(),
                      CaracteristiqueWidget(
                        iconData: Icons.speed,
                        label: 'Vitesse maximale',
                        value:
                            model.caculatMaxSpeed(parcour)!.toStringAsFixed(2),
                        unit: 'km/h',
                      ),
                      const Divider(),
                      CaracteristiqueWidget(
                        iconData: Icons.speed,
                        label: 'Vitesse minimale',
                        value:
                            model.calculatMinSpeed(parcour)!.toStringAsFixed(2),
                        unit: 'km/h',
                      ),
                      const Divider(),
                      CaracteristiqueWidget(
                        iconData: Icons.terrain,
                        label: 'Altitude maximale',
                        value: model
                            .caculatMaxAltitude(parcour)!
                            .toStringAsFixed(2),
                        unit: 'm',
                      ),
                      const Divider(),
                      CaracteristiqueWidget(
                        iconData: Icons.terrain,
                        label: 'Altitude minimale',
                        value: model
                            .calculatMinAltitude(parcour)!
                            .toStringAsFixed(2),
                        unit: 'm',
                      ),
                      SizedBox(height: height *.02),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
