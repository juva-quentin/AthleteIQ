import 'dart:async';
import 'package:athlete_iq/data/network/parcoursRepository.dart';
import 'package:athlete_iq/ui/home/providers/timer_provider.dart';
import 'package:athlete_iq/ui/providers/position_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:location/location.dart';

import '../../model/Parcour.dart';
import '../providers/loading_provider.dart';

final homeViewModelProvider = ChangeNotifierProvider.autoDispose<HomeViewModel>(
  (ref) => HomeViewModel(ref.read),
);

class HomeViewModel extends ChangeNotifier {
  final Reader _reader;
  HomeViewModel(this._reader);

  Loading get _loading => _reader(loadingProvider);

  TimerClassProvider get _chrono => _reader(timerProvider);

  PositionModel get _position => _reader(positionProvider);

  ParcourRepository get _parcourRepo => _reader(parcourRepositoryProvider);

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

  String _typeFilter = 'public';
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

  Stream<List<Parcours>>? _parcours;
  Stream<List<Parcours>>? get parcours => _parcours;
  set parcours(Stream<List<Parcours>>? parcours) {
    _parcours = parcours;
    notifyListeners();
  }

  StreamSubscription<List<Parcours>>? subStreamParcours;

  late GoogleMapController _controller;

  Future<void> onMapCreated(GoogleMapController controller) async {
    _controller = controller;
    setLocation();
    getParcourt();
    notifyListeners();
  }

  Future<void> getParcourt() async {
    switch (typeFilter) {
      case "public":
        polylines.clear();
        try {
          parcours = await _parcourRepo.parcoursPublicStream;
          streamParcours();
        } catch (e) {
          print(e);
        }
        break;
      case "protected":
        polylines.clear();
        try {
          parcours = await _parcourRepo.parcoursProtectedStream;
          streamParcours();
        } catch (e) {
          print(e);
        }
        break;
      case "private":
        polylines.clear();
        try {
          parcours = await _parcourRepo.parcoursProtectedStream;
          streamParcours();
        } catch (e) {
          print(e);
        }
        break;
      default:
        polylines.clear();
        parcours = await _parcourRepo.parcoursPublicStream;
        streamParcours();
        break;
    }
  }

  void streamParcours() async{
    subStreamParcours = parcours!.listen((List<Parcours> parcours) {
      for (var i = 0; i<parcours.length; i++){
          final newPolilyne = Polyline(
            polylineId: PolylineId(parcours[i].id),
            points: parcours[i].allPoints
                .map((position) =>
                LatLng(position.latitude!, position.longitude!))
                .toList(),
            width: 4,
            color: typeFilter == "public"
                ? Colors.green
                : typeFilter == "protected"
                ? Colors.orange
                : Colors.red,
          );
          if (!polylines.contains(newPolilyne)) {
            polylines.add(newPolilyne);
            notifyListeners();
          }
        };
    });
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

  void setLocationDuringCours(LocationData location) {
    _currentPosition = CameraPosition(
        target: LatLng(location.latitude!, location.longitude!),
        zoom: location.speed! * 3.6 > 50 ? 16 : 18,
        bearing: location.heading!,
        tilt: 50);
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
