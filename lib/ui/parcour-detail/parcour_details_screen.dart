import 'dart:async';

import 'package:athlete_iq/model/Parcour.dart';
import 'package:athlete_iq/ui/parcour-detail/parcour_details_view_model.dart';
import 'package:athlete_iq/ui/info/provider/user_provider.dart';
import 'package:athlete_iq/ui/parcour-detail/update_parcour_screen.dart';
import 'package:athlete_iq/utils/stringCapitalize.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unicons/unicons.dart';

import '../../app/app.dart';
import '../../utils/map_utils.dart';
import '../../utils/routes/customPopupRoute.dart';
import '../../utils/utils.dart';
import '../info/components/caractéristiqueComponent.dart';

class ParcourDetails extends ConsumerStatefulWidget {
  const ParcourDetails(this.args, {Key? key}) : super(key: key);
  final Object args;
  static const route = "/parcours/details";

  @override
  ParcourDetailsState createState() => ParcourDetailsState();
}

class ParcourDetailsState extends ConsumerState<ParcourDetails> {
  @override
  void initState() {
    super.initState();
    ref.read(parcourDetailsViewModel).initValue(widget.args as Parcours);
  }

  @override
  Widget build(BuildContext context) {
    final height = 1.sh;
    final width = 1.sw;
    final Completer<GoogleMapController> _controller =
        Completer<GoogleMapController>();
    final Parcours parcour = widget.args as Parcours;
    final model = ref.watch(parcourDetailsViewModel);
    final user = ref.watch(firestoreUserProvider);
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
                  model.title.capitalize(),
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 18.sp,
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
                    polylineId: PolylineId(model.title),
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
              icon: Icon(UniconsLine.arrow_left, size: 38.w),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              user.when(
                data: (user) {
                  return IconButton(
                    icon: user.fav.contains(parcour.id)
                        ? Icon(
                            UniconsLine.heart,
                            size: 38.w,
                            color: Colors.red,
                          )
                        : Icon(UniconsLine.heart, size: 38.w),
                    onPressed: () {
                      user.fav.contains(parcour.id)
                          ? model.removeToFav(parcour)
                          : model.addToFav(parcour);
                    },
                  );
                },
                error: (error, stackTrace) {
                  if (kDebugMode) {
                    print(error.toString());
                  }
                  return Text(error.toString());
                },
                loading: () => const CircularProgressIndicator(),
              ),
              user.when(
                data: (user) {
                  return user.id == parcour.owner
                      ? IconButton(
                          icon: Icon(Icons.menu, size: 38.w),
                          onPressed: () {
                            showMenu(
                              context: context,
                              position: RelativeRect.fromLTRB(width, 100, 0, 0),
                              items: [
                                PopupMenuItem(
                                  value: "modifier",
                                  child: Row(
                                    children: [
                                      Icon(Icons.edit),
                                      SizedBox(width: 10.w),
                                      Text("Modifier"),
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  value: "supprimer",
                                  child: Row(
                                    children: [
                                      Icon(Icons.delete),
                                      SizedBox(width: 10.w),
                                      Text("Supprimer"),
                                    ],
                                  ),
                                ),
                              ],
                              elevation: 8.0.h,
                            ).then((value) {
                              if (value == "modifier") {
                                Navigator.of(context).push(
                                  CustomPopupRoute(
                                    builder: (BuildContext context) {
                                      return UpdateParcourScreen();
                                    },
                                  ),
                                );
                              } else if (value == "supprimer") {
                                showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title:
                                            const Text("Supprimer le parcour"),
                                        content: const Text(
                                            "Êtes-vous sur de vouloir supprimer le parcour ?"),
                                        actions: [
                                          IconButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            icon: const Icon(
                                              Icons.cancel,
                                              color: Colors.red,
                                            ),
                                          ),
                                          IconButton(
                                            icon: const Icon(
                                              Icons.done,
                                              color: Colors.green,
                                            ),
                                            onPressed: () async {
                                              try {
                                                await model.deleteParcour();
                                              } catch (e) {
                                                Utils.flushBarErrorMessage(
                                                    e.toString(), context);
                                              }
                                              Navigator.pushNamed(
                                                  context, App.route);
                                            },
                                          ),
                                        ],
                                      );
                                    });
                              }
                            });
                          },
                        )
                      : Container();
                },
                error: (error, stackTrace) {
                  if (kDebugMode) {
                    print(error.toString());
                  }
                  return Text(error.toString());
                },
                loading: () => const CircularProgressIndicator(),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.all(width * .04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Description',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24.0.sp,
                        ),
                      ),
                      Text(
                        "${parcour.totalDistance.toStringAsFixed(2)} km",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24.0.sp,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: height * .02),
                  Text(
                    model.description.isNotEmpty
                        ? model.description.capitalize()
                        : 'Aucune description',
                    style: const TextStyle(
                      fontSize: 16.0,
                    ),
                  ),
                  SizedBox(height: height * .04),
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
                      SizedBox(height: height * .007),
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
                      SizedBox(height: height * .02),
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
