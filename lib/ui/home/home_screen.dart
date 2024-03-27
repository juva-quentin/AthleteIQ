import 'package:athlete_iq/resources/components/GoBtn.dart';
import 'package:athlete_iq/ui/home/home_view_model_provider.dart';
import 'package:athlete_iq/ui/home/providers/timer_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unicons/unicons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/utils.dart';
import '../parcour-detail/parcour_details_screen.dart';
import '../parcour-detail/parcour_overlay_widget.dart.dart';
import '../providers/loading_provider.dart';
import 'cluster/components/cluster_item_dialog.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeViewModel = ref.watch(homeViewModelProvider);
    final chrono = ref.watch(timerProvider);
    final isLoading = ref.watch(loadingProvider);

    homeViewModel.setOnClusterTapCallback((clusterItems) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return ClusterItemsDialog(
            clusterItems: clusterItems,
            onSelectParcour: homeViewModel.highlightAndZoomToParcour,
          );
        },
      );
    });

    return Stack(
      children: <Widget>[
        GoogleMap(
          polylines: homeViewModel.polylines,
          markers: homeViewModel.markers,
          indoorViewEnabled: true,
          trafficEnabled: homeViewModel.traffic,
          myLocationButtonEnabled: false,
          mapType: homeViewModel.defaultMapType,
          myLocationEnabled: true,
          onMapCreated: (controller) {
            try {
              homeViewModel.onMapCreated(controller);
            } catch (e) {
              Utils.flushBarErrorMessage(e.toString(), context);
            }
          },
          onCameraMove: (CameraPosition position) {
            homeViewModel.clusterManager.onCameraMove(
                position); // Informe le clusterManager du mouvement de la caméra
            homeViewModel.handleCameraMove(position); // Ajoutez cette ligne
          },
          onCameraIdle: () {
            homeViewModel.clusterManager
                .updateMap(); // Recalcule et met à jour les clusters lorsque l'utilisateur a fini de bouger la caméra
          },
          initialCameraPosition: homeViewModel.initialPosition,
          zoomControlsEnabled: false,
        ),
        if (homeViewModel.showParcourOverlay &&
            homeViewModel.selectedParcourForOverlay != null && !homeViewModel.courseStart)
          ParcourOverlayWidget(
            title: homeViewModel.selectedParcourForOverlay!.title,
            ownerName: homeViewModel.ownerNameForOverlay,
            onViewDetails: () {
              Navigator.pushNamed(
                context,
                ParcourDetails.route,
                arguments: homeViewModel.selectedParcourForOverlay,
              );
              homeViewModel.hideParcourDetailsOverlay();
            },
          ),
        Align(
          alignment: const Alignment(0, -1),
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 500),
            opacity: homeViewModel.courseStart ? 1 : 0,
            child: SafeArea(
              child: Container(
                alignment: Alignment.center,
                height: 50.h,
                width: 130.w,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 4,
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Text(
                  '${chrono.hour.toString().padLeft(2, '0')} : ${chrono.minute.toString().padLeft(2, '0')} : ${chrono.seconds.toString().padLeft(2, '0')} ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize:
                        16.sp,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          alignment: Alignment(0, !homeViewModel.courseStart ? 0.71 : 0.9),
          child: const GoBtn(),
        ),
        SafeArea(
          child: Align(
            alignment: const Alignment(-0.97, -1),
            child: Padding(
              padding: EdgeInsets.all(8.w),
              child: FloatingActionButton(
                backgroundColor: Theme.of(context).cardColor,
                heroTag: "modeParcourBtn",
                onPressed: () async {
                  try {
                    await homeViewModel.changeFilterParcour();
                    Utils.toastMessage(
                        "Chargement des parcours ${homeViewModel.typeFilter == "public" ? 'public' : homeViewModel.typeFilter == "protected" ? "protégé" : homeViewModel.typeFilter == "private" ? "privé" : "public"}");
                  } catch (e) {
                    Utils.flushBarErrorMessage(e.toString(), context);
                  }
                },
                child: Icon(homeViewModel.filterParcourIcon,
                    size: 24.r), // Adjusted for responsiveness
              ),
            ),
          ),
        ),
        SafeArea(
          child: Align(
            alignment: const Alignment(0.97, 0),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(8.w), // Adjusted for responsiveness
                  child: FloatingActionButton(
                    backgroundColor: Theme.of(context).cardColor,
                    heroTag: "modeViewBtn",
                    onPressed: () {
                      homeViewModel.defaultMapType =
                          homeViewModel.defaultMapType == MapType.normal
                              ? MapType.satellite
                              : MapType.normal;
                      Utils.toastMessage(
                          "Mode ${homeViewModel.defaultMapType == MapType.normal ? 'normal' : 'satellite'} activé");
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
                      homeViewModel.setLocation();
                      Utils.toastMessage("Localisation en cours...");
                    },
                    child: !homeViewModel.courseStart
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
                      homeViewModel.traffic = !homeViewModel.traffic;
                      Utils.toastMessage(
                          "Trafic ${homeViewModel.traffic ? 'activé' : 'désactivé'}");
                    },
                    child: Icon(
                      UniconsLine.traffic_light,
                      color: homeViewModel.traffic
                          ? Colors.lightGreen
                          : Colors.red,
                      size: 24.r,
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
