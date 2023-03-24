import 'package:athlete_iq/resources/components/GoBtn.dart';
import 'package:athlete_iq/ui/home/home_view_model_provider.dart';
import 'package:athlete_iq/ui/home/providers/timer_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unicons/unicons.dart';

import '../providers/loading_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final model = ref.watch(homeViewModelProvider);
    final chrono = ref.watch(timerProvider);
    final isLoading = ref.watch(loadingProvider);
    return Scaffold(
      body: Stack(
        children: <Widget>[
          GoogleMap(
            polylines:
                model.courseStart ? model.tempPolylines : model.polylines,
            indoorViewEnabled: true,
            trafficEnabled: model.traffic,
            myLocationButtonEnabled: false,
            mapType: model.defaultMapType,
            myLocationEnabled: true,
            onMapCreated: model.onMapCreated,
            initialCameraPosition: model.initialPosition,
            zoomControlsEnabled: false,
          ),
          Align(
            alignment: const Alignment(0, -1),
            child: AnimatedOpacity(
                duration: const Duration(milliseconds: 500),
                opacity: model.courseStart ? 0.8 : 0,
                child: SafeArea(
                  child: Container(
                    alignment: const Alignment(0, 0),
                    height: height * .03,
                    width: width * .25,
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20))),
                    child: Text(
                      '${chrono.hour} : ${chrono.minute} : ${chrono.seconds} ',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                )),
          ),
          AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              alignment: Alignment(0, !model.courseStart ? 0.71 : 0.9),
              child: const GoBtn()),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: AlignmentDirectional.topEnd,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(width * .007),
                      child: FloatingActionButton(
                        backgroundColor: Theme.of(context).cardColor,
                        heroTag: "modeViewBtn",
                        onPressed: () {
                          model.defaultMapType =
                              model.defaultMapType == MapType.normal
                                  ? MapType.satellite
                                  : MapType.normal;
                        },
                        child: const Icon(UniconsLine.layer_group),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(width * .007),
                      child: FloatingActionButton(
                        backgroundColor: Theme.of(context).cardColor,
                        heroTag: "locateBtn",
                        onPressed: () {
                          model.setLocation();
                        },
                        child: !model.courseStart
                            ? isLoading.loading
                                ? CircularProgressIndicator(
                                    color: Theme.of(context).primaryColor,
                                  )
                                : const Icon(Icons.my_location)
                            : const Icon(Icons.my_location),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(width * .007),
                      child: FloatingActionButton(
                        backgroundColor: Theme.of(context).cardColor,
                        heroTag: "traficBtn",
                        onPressed: () {
                          model.traffic = model.traffic == false ? true : false;
                        },
                        child: Icon(
                          UniconsLine.traffic_light,
                          color: model.traffic ? Colors.lightGreen : Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
