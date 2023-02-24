import 'dart:async';

import 'package:athlete_iq/resources/components/toolBoxBtn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../data/riverpods/auth_pod.dart';
import '../resources/size.dart';
import '../utils/routes/routes_name.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {


  @override
  void initState() {
    super.initState();
    ref.read(authProvider);
  }

  final Set<Marker> _markers = Set();
  final double _zoom = 10;
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
    final optionBtnHeigth =  height * .13;
    final optionBtnWidth = width * .6;
    final authNotifier = ref.read(authProvider);
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
            Positioned(
              bottom: height * .14,
              left: width * .5 - optionBtnWidth*.5,
              child: ToolBoxBtn(optionBtnHeigth: optionBtnHeigth, optionBtnWidth: optionBtnWidth)
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
                        print('Changing the Map Type');
                      }),
                  IconButton(
                    icon: const Icon(Icons.logout_outlined),
                    onPressed: () {
                      authNotifier.logoutUser();
                      Navigator.pushNamed(context, RoutesName.login);
                    },
                  ),
                ],
              ),
            ),
          ],
      ),
    );
  }
}
