import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../home/home_view_model_provider.dart';
import '../home/providers/timer_provider.dart';
import '../providers/loading_provider.dart';

final registerViewModelProvider = ChangeNotifierProvider(
      (ref) => RegisterViewModel(ref.read),
);

class RegisterViewModel extends ChangeNotifier {
  final Reader _reader;
  RegisterViewModel(this._reader);

  Loading get _loading => _reader(loadingProvider);

  TimerClassProvider get _chrono => _reader(timerProvider);

  HomeViewModel get _homeProvier => _reader(homeViewModelProvider);

  String _title = '';
  String get title => _title;
  set title(String title) {
    _title = title;
    notifyListeners();
  }

  CameraPosition _initialPosition =
  const CameraPosition(target: LatLng(0, 0), zoom: 10);
  CameraPosition get initialPosition => _initialPosition;
  set initialPosition(CameraPosition initialPosition) {
    _initialPosition = initialPosition;
    notifyListeners();
  }


  Set<Polyline> _polylines = {};
  Set<Polyline> get polylines => _polylines;
  set polylines(Set<Polyline> polylines) {
    _polylines = polylines;
    notifyListeners();
  }

  List<Position> _coursePosition = [];
  List<Position> get coursePosition => _coursePosition;
  set coursePosition(List<Position> coursePosition) {
    _coursePosition = coursePosition;
    notifyListeners();
  }

  double _totalDistance = 0.0;
  double get totalDistance => _totalDistance;
  set totalDistance(double totalDistance) {
    _totalDistance = totalDistance;
    notifyListeners();
  }

  double _VM = 0.0;
  double get VM => _VM;
  set VM(double VM) {
    _VM = VM;
    notifyListeners();
  }

  late GoogleMapController _controller;

  Future<void> onMapCreated(GoogleMapController controller) async {
    _controller = controller;
    _polylines = _homeProvier.tempPolylines;
    _coursePosition = _homeProvier.coursePosition;
    _setLocation();
    _totalDistance = _calculDistance(_coursePosition.map((e) => LatLng(e.latitude, e.longitude)).toList());
    _VM = _calculVM();
    print(_coursePosition.map((e) => e.altitude));
    notifyListeners();
  }

  void _setLocation() async {
    final middle = _coursePosition.length~/2;
    final middlePosition = _coursePosition.elementAt(middle);
    final camPosition = CameraPosition(
      target: LatLng(middlePosition.latitude, middlePosition.longitude),
      zoom: 12,
    );
    _controller.animateCamera(
      CameraUpdate.newCameraPosition(camPosition),
    );
  }

  double _calculDistance(List<LatLng> listCoord) {
    print(listCoord.map((e) => e.longitude));
    double result = 0;
    List<LatLng> listCoordoRad = List.empty(growable: true);

    for (var y = 0; y < listCoord.length; y++) {
      listCoordoRad.add(LatLng(listCoord[y].latitude * (3.14 / 180),
          listCoord[y].longitude * (3.14 / 180)));
    }
    print(listCoordoRad);

    for (var i = 0; i < listCoordoRad.length - 1; i++) {
      result += acos(sin(listCoordoRad[i].latitude) *
          sin(listCoordoRad[i + 1].latitude) +
          cos(listCoordoRad[i].latitude) *
              cos(listCoordoRad[i + 1].latitude) *
              cos(listCoordoRad[i + 1].longitude -
                  listCoordoRad[i].longitude)) *
          6371;
    }
    print(result);
    return result;
  }

  double _calculVM(){
    final totalInHour = _chrono.hour+_chrono.minute/60+_chrono.seconds/3600;
    print(totalInHour);
    print(_totalDistance);
    final result = _totalDistance/totalInHour;
    print(result);
    return result;
  }

}