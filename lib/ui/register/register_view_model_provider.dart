import 'dart:math';

import 'package:athlete_iq/ui/providers/position_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:location/location.dart';

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

  PositionModel get _position => _reader(positionProvider);

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

  List<LocationData> _coursePosition = [];
  List<LocationData> get coursePosition => _coursePosition;
  set coursePosition(List<LocationData> coursePosition) {
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
    _coursePosition = _position.allPostion!;
    _setLocation();
    _totalDistance = _calculeTotaleDistance(_coursePosition.map((e) => LatLng(e.latitude!, e.longitude!)).toList());
    _VM = _calculVM();
    notifyListeners();
  }

  void _setLocation() async {
    final middle = _coursePosition.length~/2;
    final middlePosition = _coursePosition.elementAt(middle);
    final camPosition = CameraPosition(
      target: LatLng(middlePosition.latitude!, middlePosition.longitude!),
      zoom: _totalDistance> 10? 10 : 12,
    );
    _controller.animateCamera(
      CameraUpdate.newCameraPosition(camPosition),
    );
  }

  double _calculeTotaleDistance(List<LatLng> data){
    double totalDistance = 0;
    for(var i = 0; i < data.length-1; i++){
      totalDistance += _calculDistance(data[i].latitude, data[i].longitude, data[i+1].latitude, data[i+1].longitude);
    }
    return totalDistance;
  }

  double _calculDistance(lat1, lon1, lat2, lon2){
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 - c((lat2 - lat1) * p)/2 +
        c(lat1 * p) * c(lat2 * p) *
            (1 - c((lon2 - lon1) * p))/2;
    return 12742 * asin(sqrt(a));
  }

  double _calculVM(){
    final totalInHour = _chrono.hour+_chrono.minute/60+_chrono.seconds/3600;

    final result = _totalDistance/totalInHour;

    return result;
  }

}