import 'dart:async';

import 'package:athlete_iq/data/riverpods/variable_pod.dart';
import 'package:athlete_iq/resources/components/GoBtn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../data/riverpods/auth_pod.dart';
import '../resources/size.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final Set<Marker> _markers = Set();

  @override
  void initState() {
    super.initState();
    ref.read(courseStart);
  }


  CameraPosition _initialPosition =
      CameraPosition(target: LatLng(26.8206, 30.8025));
  MapType _defaultMapType = MapType.normal;
  Completer<GoogleMapController> _controller = Completer();

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  void _changeMapType() {
    setState(() {
      _defaultMapType = _defaultMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }

  @override
  Widget build(BuildContext context) {
    final AppSize appSize = AppSize(context);
    final height = appSize.globalHeight;
    final width = appSize.globalWidth;
    final optionBtnHeigth =  height * .06;
    final optionBtnWidth = width * .5;
    StateController<bool> _courseIsStart = ref.watch(courseStart.notifier);
    return Scaffold(
      body: Stack(
          children: <Widget>[
            GoogleMap(
              markers: _markers,
              mapType: _defaultMapType,
              myLocationEnabled: true,
              onMapCreated: _onMapCreated,
              initialCameraPosition: _initialPosition,
            ),
            Consumer(builder: (context, ref, _) {
              var isStart = ref.watch(courseStart);
              return AnimatedContainer(
                  duration: Duration(milliseconds: 500),
                  alignment: Alignment(0,!isStart? 0.7 : 0.9),
                  // bottom: height * .14,
                  // left:isStart? width * .5 - optionBtnWidth*.5 : width * .5 - (optionBtnWidth*.26)*.5,
                  child: GoBtn(
                        optionBtnHeigth: optionBtnHeigth,
                        optionBtnWidth: optionBtnWidth,
                        onPress: (){
                            _courseIsStart.state = !_courseIsStart.state;
                        }
                    )
                );
              }
            ),
            Container(
              margin: EdgeInsets.only(top: 80, right: 10),
              alignment: Alignment.topRight,
              child: Column(
                children: <Widget>[
                  FloatingActionButton(
                      child: Icon(Icons.layers),
                      elevation: 5,
                      backgroundColor: Colors.teal[200],
                      onPressed: () {
                        _changeMapType();
                      }),
                ],
              ),
            ),
          ],
      ),
    );
  }
}
