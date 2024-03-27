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
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:unicons/unicons.dart';

import '../../app/app.dart';
import '../../model/User.dart';
import '../info/components/caractéristiqueComponent.dart';

class ParcourDetails extends ConsumerStatefulWidget {
  final Object args;

  const ParcourDetails(this.args, {super.key});

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
    final model = ref.watch(parcourDetailsViewModel);
    final AsyncValue<UserModel> userAsyncValue =
        ref.watch(firestoreUserProvider);
    final Parcours parcour = widget.args as Parcours;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          parcour.title.capitalize(),
          style: const TextStyle(color: Colors.black),
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
        actions: <Widget>[
          userAsyncValue.when(
            data: (user) => IconButton(
              icon: Icon(
                user.fav.contains(parcour.id)
                    ? MdiIcons.heart
                    : MdiIcons.heartOutline,
                size: 24.w,
                color:
                    user.fav.contains(parcour.id) ? Colors.blue : Colors.blue,
              ),
              onPressed: () {
                if (user.fav.contains(parcour.id)) {
                  model.removeToFav(parcour);
                } else {
                  model.addToFav(parcour);
                }
              },
            ),
            loading: () => const CircularProgressIndicator(),
            error: (_, __) => Icon(UniconsLine.circle, size: 24.w),
          ),
          userAsyncValue.when(
            data: (user) {
              return user.id == parcour.owner
                  ? IconButton(
                      icon: Icon(
                        Icons.more_vert,
                        size: 24.w,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Dialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0)),
                              elevation: 5,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20.0),
                                child: Container(
                                  color: Colors.white,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).primaryColor,
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(20),
                                            topRight: Radius.circular(20),
                                          ),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 15, horizontal: 20),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text(
                                              'Options',
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                            InkWell(
                                              onTap: () =>
                                                  Navigator.of(context).pop(),
                                              child: const Icon(Icons.close,
                                                  color: Colors.white),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10),
                                        child: Column(
                                          children: [
                                            ListTile(
                                              leading: const Icon(UniconsLine.edit, color: Colors.blue),
                                              title: const Text("Modifier"),
                                              onTap: () {
                                                Navigator.of(context).push(
                                                  CustomPopupRoute(
                                                    builder: (BuildContext context) {
                                                      return UpdateParcourScreen();
                                                    },
                                                  ),
                                                );
                                              },
                                            ),
                                            ListTile(
                                              leading: const Icon(UniconsLine.trash_alt, color: Colors.red),
                                              title: const Text("Supprimer"),
                                              onTap: () {
                                                showDialog(
                                                  context: context,
                                                  builder: (BuildContext context) {
                                                    return Dialog(
                                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                                                      elevation: 5,
                                                      child: ClipRRect(
                                                        borderRadius: BorderRadius.circular(20.0),
                                                        child: Container(
                                                          color: Colors.white,
                                                          child: IntrinsicHeight( // Assurez-vous que le widget prend la hauteur de son contenu
                                                            child: Column(
                                                              mainAxisSize: MainAxisSize.min,
                                                              children: [
                                                                Container(
                                                                  width: double.infinity,
                                                                  decoration: BoxDecoration(
                                                                    color: Theme.of(context).errorColor, // Couleur rouge pour l'en-tête
                                                                    borderRadius: const BorderRadius.only(
                                                                      topLeft: Radius.circular(20),
                                                                      topRight: Radius.circular(20),
                                                                    ),
                                                                  ),
                                                                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20), // Augmentation de l'espace vertical
                                                                  child: const Text(
                                                                    "Supprimer le parcours",
                                                                    style: TextStyle(
                                                                      fontSize: 20,
                                                                      fontWeight: FontWeight.bold,
                                                                      color: Colors.white,
                                                                    ),
                                                                    textAlign: TextAlign.center,
                                                                  ),
                                                                ),
                                                                const Padding(
                                                                  padding: EdgeInsets.all(20), // Augmentation de l'espace autour du texte
                                                                  child: Text(
                                                                    "Êtes-vous sûr de vouloir supprimer ce parcours ? Cette action est irréversible.",
                                                                    style: TextStyle(fontSize: 16),
                                                                    textAlign: TextAlign.center,
                                                                  ),
                                                                ),
                                                                Padding( // Ajout de Padding pour créer plus d'espace
                                                                  padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20), // Ajustez selon le besoin
                                                                  child: Row(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                    children: [
                                                                      TextButton(
                                                                        onPressed: () => Navigator.pop(context),
                                                                        child: Text("Annuler", style: TextStyle(color: Theme.of(context).primaryColor)), // Couleur bleue pour annuler
                                                                      ),
                                                                      TextButton(
                                                                        onPressed: () async {
                                                                          try {
                                                                            await model.deleteParcour();
                                                                            Navigator.pushNamed(context, App.route);
                                                                          } catch (e) {
                                                                            Utils.flushBarErrorMessage(e.toString(), context);
                                                                          }
                                                                        },
                                                                        child: Text("Supprimer", style: TextStyle(color: Colors.red)), // Texte Supprimer en rouge
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                );
                                              },
                                            ),
                                            ListTile(
                                              leading: const Icon(UniconsLine.share_alt, color: Colors.blue),
                                              title: const Text("Partager"),
                                              onTap: () {
                                                model.shareParcour(context, parcour);
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 250.h,
              child: GoogleMap(
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
                      polylineId: const PolylineId('parcourLine'),
                      points: parcour.allPoints
                          .map((e) => LatLng(e.latitude!, e.longitude!))
                          .toList(),
                      color: Colors.blue,
                      width: 5),
                },
                onMapCreated: (GoogleMapController controller) async {
                  _controller.complete(controller);
                  await Future.delayed(const Duration(
                      milliseconds: 100)); // Allow time for the map to render
                  controller.animateCamera(CameraUpdate.newLatLngBounds(
                      MapUtils.boundsFromLatLngList(parcour.allPoints
                          .map((e) => LatLng(e.latitude!, e.longitude!))
                          .toList()),
                      100));
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Description",
                    style:
                        TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    parcour.description.isNotEmpty
                        ? parcour.description
                        : "Aucune description disponible",
                    style: TextStyle(fontSize: 16.sp),
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    "Caractéristiques",
                    style:
                        TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
                  ),
                  CaracteristiqueWidget(
                    iconData: UniconsLine.mouse,
                    label: "Distance",
                    value: "${parcour.totalDistance.toStringAsFixed(2)}",
                    unit: 'Km',
                  ),
                  CaracteristiqueWidget(
                    iconData: UniconsLine.clock,
                    label: "Durée",
                    value: "${parcour.totalDistance}",
                    unit: '',
                  ),
                  // Add more caracteristique widgets as needed
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
