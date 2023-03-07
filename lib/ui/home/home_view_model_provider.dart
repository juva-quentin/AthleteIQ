import 'dart:async';

import 'package:athlete_iq/ui/home/providers/timer_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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

  TimerClassProvider get _chrono => _reader(timerProvider);

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

  List<Position> _coursePosition = [];
  List<Position> get coursePosition => _coursePosition;
  set coursePosition(List<Position> coursePosition) {
    _coursePosition = coursePosition;
    notifyListeners();
  }

  MapType _defaultMapType = MapType.normal;
  MapType get defaultMapType => _defaultMapType;
  set defaultMapType(MapType defaultMapType) {
    _defaultMapType = defaultMapType;
    notifyListeners();
  }

  CameraPosition _initialPosition =
      const CameraPosition(target: LatLng(0, 0), zoom: 10);
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

  Set<Polyline> _polylines = {};
  Set<Polyline> get polylines => _polylines;
  set polylines(Set<Polyline> polylines) {
    _polylines = polylines;
    notifyListeners();
  }

  Set<Polyline> _tempPolylines = {};
  Set<Polyline> get tempPolylines => _tempPolylines;
  set tempPolylines(Set<Polyline> tempPolylines) {
    _tempPolylines = tempPolylines;
    notifyListeners();
  }

  late GoogleMapController _controller;

  void onMapCreated(GoogleMapController controller) {
    _controller = controller;
    setLocation();
  }

  Future<Position> _getUserCurrentLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) async {
      await Geolocator.requestPermission();
      if (kDebugMode) {
        print("ERROR$error");
      }
    });
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  void setLocation() async {
    _loading.start();
    await _getUserCurrentLocation().then((value) async {
      currentPosition = CameraPosition(
        target: LatLng(value.latitude, value.longitude),
        zoom: 19,
      );
      _controller.animateCamera(
        CameraUpdate.newCameraPosition(currentPosition!),
      );
    });
    _loading.end();
  }

  void register() async {
    _tempPolylines.clear();
    _coursePosition.clear();
    _chrono.startTimer();
    await Future.delayed(const Duration(milliseconds: 500));
    while (_courseStart) {
      await _getUserCurrentLocation().then((value) {
        _coursePosition.add(value);
      });
      setLocation();
      await Future.delayed(const Duration(milliseconds: 300));
    }
    _chrono.stopTimer();
    List<LatLng> points = <LatLng>[];
    final latLng = _coursePosition
        .map((position) => LatLng(position.latitude, position.longitude));
    points.addAll(latLng);
    _tempPolylines.add(
      Polyline(
        polylineId: const PolylineId("running"),
        points: points,
        width: 4,
        color: Colors.blue,
      ),
    );
    setLocation();
  }
}
