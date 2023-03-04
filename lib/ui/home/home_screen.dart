import 'package:athlete_iq/resources/components/GoBtn.dart';
import 'package:athlete_iq/ui/home/home_view_model_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unicons/unicons.dart';

import '../providers/loading_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
              indoorViewEnabled: true,
              trafficEnabled: true,
              myLocationButtonEnabled: false,
              compassEnabled: true,
              mapType: model.defaultMapType,
              myLocationEnabled: true,
              onMapCreated: model.onMapCreated,
              initialCameraPosition: model.initialPosition,
            );
          }),
          Consumer(builder: (context, ref, child) {
            var isStart = ref.watch(homeViewModelProvider).courseStart;
            return AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                alignment: Alignment(0, !isStart ? 0.7 : 0.9),
                // bottom: height * .14,
                // left:isStart? width * .5 - optionBtnWidth*.5 : width * .5 - (optionBtnWidth*.26)*.5,
                child: const GoBtn());
          }),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: AlignmentDirectional.topEnd,
                child: Container(
                  width: width * .14,
                  height: height * .15,
                  child: Consumer(builder: (context, ref, child) {
                    ref.watch(provider);
                    final isLoading = ref.watch(loadingProvider);
                    return Column(
                      children: [
                        FloatingActionButton(
                          heroTag: "modeViewBtn",
                          onPressed: () {
                            model.defaultMapType = model.defaultMapType == MapType.normal
                                ? MapType.satellite
                                : MapType.normal;
                          },
                          child: const Icon(UniconsLine.layer_group),
                        ),
                        Spacer(),
                        FloatingActionButton(
                          heroTag: "locateBtn",
                          onPressed: () {
                            model.setLocation();
                          },
                          child: isLoading.loading? CircularProgressIndicator() :const Icon(UniconsLine.location_point),
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