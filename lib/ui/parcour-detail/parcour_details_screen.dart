import 'dart:async';
import 'package:athlete_iq/model/Parcour.dart';
import 'package:athlete_iq/ui/parcour-detail/parcour_details_view_model.dart';
import 'package:athlete_iq/ui/info/provider/user_provider.dart';
import 'package:athlete_iq/ui/parcour-detail/update_parcour_screen.dart';
import 'package:athlete_iq/utils/map_utils.dart';
import 'package:athlete_iq/utils/routes/customPopupRoute.dart';
import 'package:athlete_iq/utils/stringCapitalize.dart';
import 'package:athlete_iq/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unicons/unicons.dart';

import '../../app/app.dart';
import '../../model/User.dart';
import '../info/components/caractéristiqueComponent.dart';

class ParcourDetails extends ConsumerStatefulWidget {
  final Object args;
  const ParcourDetails(this.args, {Key? key}) : super(key: key);
  static const route = "/parcours/details";

  @override
  ParcourDetailsState createState() => ParcourDetailsState();
}

class ParcourDetailsState extends ConsumerState<ParcourDetails> {
  late final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  @override
  void initState() {
    super.initState();
    final Parcours parcour = widget.args as Parcours;
    ref.read(parcourDetailsViewModel.notifier).initValue(parcour);
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context,
        designSize: const Size(360, 690), minTextAdapt: true);
    final model = ref.watch(parcourDetailsViewModel);
    final AsyncValue<UserModel> userAsyncValue =
        ref.watch(firestoreUserProvider);
    final Parcours parcour = widget.args as Parcours;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300.h,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              titlePadding: EdgeInsets.only(bottom: 13.h),
              title: Container(
                width: double.infinity,
                alignment: Alignment.bottomCenter,
                child: Text(
                  model.title.capitalize(),
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
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
                initialCameraPosition: CameraPosition(
                  target: LatLng(parcour.allPoints.first.latitude!,
                      parcour.allPoints.first.longitude!),
                  zoom: 14,
                ),
                polylines: {
                  Polyline(
                      polylineId: PolylineId('parcourLine'),
                      points: parcour.allPoints
                          .map((e) => LatLng(e.latitude!, e.longitude!))
                          .toList(),
                      color: Colors.blue,
                      width: 5),
                },
                onMapCreated: (GoogleMapController controller) async {
                  _controller.complete(controller);
                  await Future.delayed(Duration(
                      milliseconds: 100)); // Allow time for the map to render
                  controller.animateCamera(CameraUpdate.newLatLngBounds(
                      MapUtils.boundsFromLatLngList(parcour.allPoints
                          .map((e) => LatLng(e.latitude!, e.longitude!))
                          .toList()),
                      100));
                },
              ),
            ),
            leading: IconButton(
                icon: Icon(UniconsLine.arrow_left, size: 24.w),
                onPressed: () => Navigator.of(context).pop()),
            actions: <Widget>[
              userAsyncValue.when(
                data: (user) => IconButton(
                  icon: Icon(
                      user.fav.contains(parcour.id)
                          ? UniconsLine.heart
                          : UniconsLine.heart_alt,
                      size: 24.w,
                      color: user.fav.contains(parcour.id)
                          ? Colors.red
                          : Colors.white),
                  onPressed: () {
                    if (user.fav.contains(parcour.id)) {
                      model.removeToFav(parcour);
                    } else {
                      model.addToFav(parcour);
                    }
                  },
                ),
                loading: () => CircularProgressIndicator(),
                error: (_, __) => Icon(UniconsLine.circle, size: 24.w),
              ),
              userAsyncValue.when(
                data: (user) {
                  return user.id == parcour.owner
                      ? IconButton(
                          icon: Icon(
                            Icons.menu,
                            size: 38.w,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            final RenderBox overlay = Overlay.of(context)!
                                .context
                                .findRenderObject() as RenderBox;
                            showMenu(
                              context: context,
                              position: RelativeRect.fromRect(
                                Rect.fromPoints(
                                  overlay.localToGlobal(Offset(0.95.sw - 48.w,
                                      5.h)), // Ajustement pour le bouton menu en haut à droite
                                  overlay.localToGlobal(Offset(
                                      0.95.sw,
                                      kToolbarHeight
                                          .h)), // Ajustement pour la hauteur de la toolbar
                                ),
                                Offset.zero & overlay.size,
                              ),
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
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Description',
                      style: TextStyle(
                          fontSize: 18.sp, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10.h),
                  Text(
                      model.description.isNotEmpty
                          ? model.description
                          : 'Aucune description disponible',
                      style: TextStyle(fontSize: 16.sp)),
                  SizedBox(height: 20.h),
                  Text('Caractéristiques',
                      style: TextStyle(
                          fontSize: 18.sp, fontWeight: FontWeight.bold)),
                  CaracteristiqueWidget(
                      iconData: Icons.speed,
                      label: 'Vitesse moyenne',
                      value:
                          model.caculatMaxSpeed(parcour)?.toStringAsFixed(2) ??
                              'N/A',
                      unit: 'km/h'),
                  Divider(),
                  CaracteristiqueWidget(
                      iconData: Icons.speed,
                      label: 'Vitesse maximale',
                      value:
                          model.calculatMinSpeed(parcour)?.toStringAsFixed(2) ??
                              'N/A',
                      unit: 'km/h'),
                  Divider(),
                  CaracteristiqueWidget(
                      iconData: Icons.terrain,
                      label: 'Altitude maximale',
                      value: model
                              .caculatMaxAltitude(parcour)
                              ?.toStringAsFixed(2) ??
                          'N/A',
                      unit: 'm'),
                  Divider(),
                  CaracteristiqueWidget(
                      iconData: Icons.terrain,
                      label: 'Altitude minimale',
                      value: model
                              .calculatMinAltitude(parcour)
                              ?.toStringAsFixed(2) ??
                          'N/A',
                      unit: 'm'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
