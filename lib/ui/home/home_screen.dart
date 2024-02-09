import 'package:athlete_iq/resources/components/GoBtn.dart';
import 'package:athlete_iq/ui/home/home_view_model_provider.dart';
import 'package:athlete_iq/ui/home/providers/timer_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unicons/unicons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/utils.dart';
import '../providers/loading_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final model = ref.watch(homeViewModelProvider);
    final chrono = ref.watch(timerProvider);
    final isLoading = ref.watch(loadingProvider);
    return Stack(
      children: <Widget>[
        GoogleMap(
          polylines: model.polylines,
          markers: model.markers,
          indoorViewEnabled: true,
          trafficEnabled: model.traffic,
          myLocationButtonEnabled: false,
          mapType: model.defaultMapType,
          myLocationEnabled: true,
          onMapCreated: (controller) {
            try {
              model.onMapCreated(controller);
            } catch (e) {
              Utils.flushBarErrorMessage(e.toString(), context);
            }
          },
          initialCameraPosition: model.initialPosition,
          zoomControlsEnabled: false,
        ),
        Align(
          alignment: Alignment(0, -1),
          child: AnimatedOpacity(
            duration: Duration(milliseconds: 500),
            opacity: model.courseStart ? 0.8 : 0,
            child: SafeArea(
              child: Container(
                alignment: Alignment.center,
                height: 60.h, // Hauteur ajustée pour plus de visibilité
                width: 150.w, // Largeur ajustée pour plus de visibilité
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.all(Radius.circular(
                      25.r)), // Bords arrondis pour une apparence moderne
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black
                          .withOpacity(0.2), // Ombre pour la profondeur
                      spreadRadius: 0,
                      blurRadius: 10.r, // Flou de l'ombre
                      offset: Offset(0, 4.h), // Position de l'ombre
                    ),
                  ],
                ),
                child: Text(
                  '${chrono.hour.toString().padLeft(2, '0')} : ${chrono.minute.toString().padLeft(2, '0')} : ${chrono.seconds.toString().padLeft(2, '0')} ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize:
                        16.sp, // Taille de police ajustée pour l'équilibre
                    fontWeight:
                        FontWeight.bold, // Gras pour une meilleure lisibilité
                  ),
                ),
              ),
            ),
          ),
        ),
        AnimatedContainer(
          duration: Duration(milliseconds: 300),
          alignment: Alignment(0, !model.courseStart ? 0.71 : 0.9),
          child: const GoBtn(),
        ),
        SafeArea(
          child: Align(
            alignment: Alignment(-0.97, -1),
            child: Padding(
              padding: EdgeInsets.all(8.w), // Adjusted for responsiveness
              child: FloatingActionButton(
                backgroundColor: Theme.of(context).cardColor,
                heroTag: "modeParcourBtn",
                onPressed: () async {
                  try {
                    await model.changeFilterParcour();
                    Utils.toastMessage(
                        "Chargement des parcours ${model.typeFilter == "public" ? 'public' : model.typeFilter == "protected" ? "protégé" : model.typeFilter == "private" ? "privé" : "public"}");
                  } catch (e) {
                    Utils.flushBarErrorMessage(e.toString(), context);
                  }
                },
                child: Icon(model.filterParcourIcon,
                    size: 24.r), // Adjusted for responsiveness
              ),
            ),
          ),
        ),
        SafeArea(
          child: Align(
            alignment: Alignment(0.97, 0),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(8.w), // Adjusted for responsiveness
                  child: FloatingActionButton(
                    backgroundColor: Theme.of(context).cardColor,
                    heroTag: "modeViewBtn",
                    onPressed: () {
                      model.defaultMapType =
                          model.defaultMapType == MapType.normal
                              ? MapType.satellite
                              : MapType.normal;
                      Utils.toastMessage(
                          "Mode ${model.defaultMapType == MapType.normal ? 'normal' : 'satellite'} activé");
                    },
                    child: const Icon(UniconsLine.layer_group,
                        size: 24), // Adjusted for responsiveness
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.w), // Adjusted for responsiveness
                  child: FloatingActionButton(
                    backgroundColor: Theme.of(context).cardColor,
                    heroTag: "locateBtn",
                    onPressed: () {
                      model.setLocation();
                      Utils.toastMessage("Localisation en cours...");
                    },
                    child: !model.courseStart
                        ? isLoading.loading
                            ? CircularProgressIndicator(
                                color: Theme.of(context).primaryColor)
                            : const Icon(Icons.my_location,
                                size: 24) // Adjusted for responsiveness
                        : const Icon(Icons.my_location,
                            size: 24), // Adjusted for responsiveness
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.w), // Adjusted for responsiveness
                  child: FloatingActionButton(
                    backgroundColor: Theme.of(context).cardColor,
                    heroTag: "traficBtn",
                    onPressed: () {
                      model.traffic = !model.traffic;
                      Utils.toastMessage(
                          "Trafic ${model.traffic ? 'activé' : 'désactivé'}");
                    },
                    child: Icon(
                      UniconsLine.traffic_light,
                      color: model.traffic ? Colors.lightGreen : Colors.red,
                      size: 24.r, // Adjusted for responsiveness
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
