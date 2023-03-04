
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../providers/loading_provider.dart';

final homeViewModelProvider = ChangeNotifierProvider(
      (ref) => HomeViewModel(ref.read),
);

class HomeViewModel extends ChangeNotifier {

  final Reader _reader;
  HomeViewModel(this._reader);

  Loading get _loading => _reader(loadingProvider);

  void setLocation() async{
    _loading.start();
    await _getUserCurrentLocation().then((value) async {
      currentPosition = CameraPosition(
      target: LatLng(value.latitude, value.longitude),
      zoom: 14,
      );
      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newCameraPosition(currentPosition!));
    });
    _loading.end();
  }

  bool _courseStart = false;
  bool get courseStart => _courseStart;
  set courseStart(bool courseStart) {
    _courseStart = courseStart;
    notifyListeners();
  }

  String _visibilityFilter = '';
  String get visibilityFilter => _visibilityFilter;
  set visibilityFilter(String visibilityFilter) {
    _visibilityFilter = visibilityFilter;
    notifyListeners();
  }

  String _typeFilter = '';
  String get typeFilter => _typeFilter;
  set typeFilter(String typeFilter) {
    _typeFilter = typeFilter;
    notifyListeners();
  }

  MapType _defaultMapType = MapType.normal;
  MapType get defaultMapType => _defaultMapType;
  set defaultMapType(MapType defaultMapType) {
    _defaultMapType = defaultMapType;
    notifyListeners();
  }

  CameraPosition _initialPosition = const CameraPosition(target: LatLng(0, 0), zoom: 10);
  CameraPosition get initialPosition => _initialPosition;
  set initialPosition(CameraPosition initialPosition) {
    _initialPosition = initialPosition;
    notifyListeners();
  }

  CameraPosition? _currentPosition;
  CameraPosition? get currentPosition => _currentPosition;
  set currentPosition(CameraPosition? currentPosition) {
    _currentPosition = currentPosition;
    notifyListeners();
  }

  final Completer<GoogleMapController> _controller = Completer();

  void onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
    setLocation();
  }

  Future<Position> _getUserCurrentLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) async {
      await Geolocator.requestPermission();
      print("ERROR" + error.toString());
    });
    return await Geolocator.getCurrentPosition();
  }

}