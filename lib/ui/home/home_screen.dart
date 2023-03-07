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
    final provider = homeViewModelProvider;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Consumer(builder: (context, ref, child) {
            ref.watch(provider);
            return GoogleMap(
              polylines: model.polylines,
              indoorViewEnabled: true,
              trafficEnabled: true,
              myLocationButtonEnabled: false,
              compassEnabled: true,
              mapType: model.defaultMapType,
              myLocationEnabled: true,
              onMapCreated: model.onMapCreated,
              initialCameraPosition: model.initialPosition,
                zoomControlsEnabled : false
            );
          }),
          Consumer(builder: (context, ref, child) {
            final isStart = ref.watch(homeViewModelProvider).courseStart;
            final chrono = ref.watch(timerProvider);
            return Align(
              alignment: const Alignment(0, -1),
              child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 500),
                  opacity: isStart ? 0.8 : 0,
                  child: SafeArea(
                    child: Container(
                      alignment: const Alignment(0, 0),
                      height: height*.03,
                      width: width*.25,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: const BorderRadius.all(Radius.circular(20))
                      ),
                      child: Text(
                        '${chrono.hour} : ${chrono.minute} : ${chrono.seconds} ',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  )),
            );
          }),
          Consumer(builder: (context, ref, child) {
            var isStart = ref.watch(homeViewModelProvider).courseStart;
            return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                alignment: Alignment(0, !isStart ? 0.71 : 0.9),
                child: const GoBtn());
          }),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: AlignmentDirectional.topEnd,
                child: SizedBox(
                  width: width * .14,
                  height: height * .20,
                  child: Consumer(builder: (context, ref, child) {
                    ref.watch(provider);
                    final isLoading = ref.watch(loadingProvider);
                    return Column(
                      children: [
                        FloatingActionButton(
                          backgroundColor: Theme.of(context).primaryColor,
                          heroTag: "modeViewBtn",
                          onPressed: () {
                            model.defaultMapType =
                                model.defaultMapType == MapType.normal
                                    ? MapType.satellite
                                    : MapType.normal;
                          },
                          child: const Icon(UniconsLine.layer_group),
                        ),
                        const Spacer(),
                        FloatingActionButton(
                          backgroundColor: Theme.of(context).primaryColor,
                          heroTag: "locateBtn",
                          onPressed: () {
                            model.setLocation();
                          },
                          child: !model.courseStart?
                          isLoading.loading
                              ? const CircularProgressIndicator()
                              : const Icon(Icons.my_location) : const Icon(Icons.my_location),
                        ),
                      ],
                    );
                  }),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
