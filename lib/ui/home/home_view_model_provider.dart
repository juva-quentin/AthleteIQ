import 'dart:async';

import 'package:athlete_iq/ui/home/providers/timer_provider.dart';
import 'package:athlete_iq/ui/providers/position_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart';

import '../providers/loading_provider.dart';

final homeViewModelProvider = ChangeNotifierProvider(
  (ref) => HomeViewModel(ref.read),
);

class HomeViewModel extends ChangeNotifier {
  final Reader _reader;
  HomeViewModel(this._reader);

  Loading get _loading => _reader(loadingProvider);

  TimerClassProvider get _chrono => _reader(timerProvider);

  PositionModel get _position => _reader(positionProvider);

  bool _courseStart = false;
  bool get courseStart => _courseStart;
  set courseStart(bool courseStart) {
    _courseStart = courseStart;
    notifyListeners();
  }

  bool _traffic = false;
  bool get traffic => _traffic;
  set traffic(bool traffic) {
    _traffic = traffic;
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

  Future<void> onMapCreated(GoogleMapController controller) async {
    _controller = controller;
    setLocation();
  }

  void setLocation() async {
    _loading.start();
    await _position.getPosition().then((value) async {
      _currentPosition = CameraPosition(
        target: LatLng(value.latitude!, value.longitude!),
        zoom: 18,
      );
      _controller.animateCamera(
        CameraUpdate.newCameraPosition(_currentPosition!),
      );
    });
    _loading.end();
    notifyListeners();
  }

  void setLocationDuringCours(LocationData location, LocationData lastLocation){
    final calculatedRotation = Geolocator.bearingBetween(
        lastLocation.latitude! ?? 0,
        lastLocation.longitude! ?? 0,
        location.latitude!,
        location.longitude!);
    print(calculatedRotation);
    _currentPosition = CameraPosition(
      target: LatLng(location.latitude!, location.longitude!),
      zoom: location.speed!*3.6 > 50? 16 : 18,
      bearing: calculatedRotation,
      tilt: 50
    );
    _controller.animateCamera(
      CameraUpdate.newCameraPosition(_currentPosition!),
    );
  }

  Future<bool> register() async {
    if (_courseStart) {
      _courseStart = false;
      _chrono.stopTimer();
      await _position.stopCourse();
      List<LatLng> points = <LatLng>[];
      final latLng = _position.allPostion
          .map((position) => LatLng(position.latitude!, position.longitude!));
      points.addAll(latLng);
      _tempPolylines.add(
        Polyline(
          polylineId: const PolylineId("running"),
          points: points,
          width: 4,
          color: Colors.blue,
        ),
      );
      notifyListeners();
      return false;
    } else {
      _courseStart = true;
      _tempPolylines.clear();
      _chrono.startTimer();
      _position.startCourse();
      notifyListeners();
      await Future.delayed(const Duration(milliseconds: 500));
      while (_courseStart) {
        await Future.delayed(const Duration(milliseconds: 5));
      }
      return true;
    }
  }
}
