import 'dart:async';
import 'package:athlete_iq/data/network/parcoursRepository.dart';
import 'package:athlete_iq/ui/home/providers/timer_provider.dart';
import 'package:athlete_iq/ui/providers/position_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:location/location.dart';
import 'package:unicons/unicons.dart';
import 'package:wakelock/wakelock.dart';

import '../../data/network/userRepository.dart';
import '../../model/Parcour.dart';
import '../../utils/map_utils.dart';
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
  final UserRepository _userRepo = UserRepository();

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

  Set<Polyline> _polylines = <Polyline>{};
  Set<Polyline> get polylines => _polylines;
  set polylines(Set<Polyline> polylines) {
    _polylines = polylines;
    notifyListeners();
  }

  Set<Marker> _markers = <Marker>{};
  Set<Marker> get markers => _markers;
  set markers(Set<Marker> markers) {
    _markers = markers;
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

  IconData _filterParcourIcon = UniconsLine.globe;
  IconData get filterParcourIcon => _filterParcourIcon;
  set filterParcourIcon(IconData filterParcourIcon) {
    _filterParcourIcon = filterParcourIcon;
    notifyListeners();
  }

  StreamSubscription<List<Parcours>>? _subStreamParcours;

  BitmapDescriptor _markerIcon = BitmapDescriptor.defaultMarker;

  late GoogleMapController _controller;

  Future<void> onMapCreated(GoogleMapController controller) async {
    try {
      getParcour();
    } catch (e) {
      rethrow;
    }
    _controller = controller;
    setLocation();
    notifyListeners();
  }

  Future<void> changeFilterParcour() async {
    final provVal = _typeFilter;
    if (_typeFilter == "public") {
      _filterParcourIcon = Icons.shield;
      _typeFilter = "protected";
    }else if (_typeFilter == "protected"){
      _filterParcourIcon = UniconsLine.lock;
      _typeFilter = "private";
    }else{
      _filterParcourIcon = UniconsLine.globe;
      _typeFilter = "public";
    }
    try {
      getParcour();
    } catch (e) {
      _typeFilter = provVal;
      switch (provVal) {
        case "public":
          _filterParcourIcon = UniconsLine.globe;
          break;
        case "private":
          _filterParcourIcon = UniconsLine.lock;
          break;
        case "protected":
          _filterParcourIcon = Icons.shield;
          break;
        default:
          _filterParcourIcon = UniconsLine.globe;
          break;
      }
      return Future.error(e);
    }
  }

  void getParcour() async {
    switch (typeFilter) {
      case "public":
        try {
          parcours = _parcourRepo.parcoursPublicStream;
          polylines.clear();
          markers.clear();
          streamParcours();
        } catch (e) {
          rethrow;
        }
        break;
      case "protected":
        try {
          parcours = _parcourRepo.parcoursProtectedStream();
          polylines.clear();
          markers.clear();
          streamParcours();
        } catch (e) {
          rethrow;
        }
        break;
      case "private":
        try {
          parcours = _parcourRepo.parcoursPrivateStream;
          polylines.clear();
          markers.clear();
          streamParcours();
        } catch (e) {
          rethrow;
        }
        break;
      default:
        try {
          parcours = await _parcourRepo.parcoursPublicStream;
          polylines.clear();
          markers.clear();
          streamParcours();
        } catch (e) {
          rethrow;
        }
        break;
    }
  }

  void streamParcours() async {
    _subStreamParcours = parcours!.listen((List<Parcours> parcours) async {
      for (var i = 0; i < parcours.length; i++) {
        final newPolilyne = Polyline(
          polylineId: PolylineId(parcours[i].id),
          points: parcours[i]
              .allPoints
              .map(
                  (position) => LatLng(position.latitude!, position.longitude!))
              .toList(),
          width: 5,
          color: typeFilter == "public"
              ? const Color(0xC005FF0C)
              : typeFilter == "protected"
                  ? const Color(0xFFFFF200)
                  : const Color(0xFFFF2100),
          onTap: () async {
           await  _controller.animateCamera(CameraUpdate.newLatLngBounds(
                MapUtils.boundsFromLatLngList(parcours[i].allPoints.map((e) => LatLng(e.latitude!, e.longitude!)).toList()),12
            ));
           notifyListeners();
          }
        );
        final newMarker = Marker(
            markerId: MarkerId(parcours[i].id),
            position: LatLng(parcours[i].allPoints.first.latitude!,
                parcours[i].allPoints.first.longitude!),
            infoWindow: InfoWindow(
                title: parcours[i].title,
                snippet:"Par : ${await _userRepo.getUserWithId(userId: parcours[i].owner).then((value) => value.pseudo)}"));
        if (!polylines.contains(newPolilyne)) {
          polylines.add(newPolilyne);
        }
        if (!markers.contains(newMarker)) {
          markers.add(newMarker);
        }
        notifyListeners();
      }
    });
  }

  void setLocation() async {
    _loading.start();
    try {
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
    } catch (e) {
      _loading.end();
      notifyListeners();
    }
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
      tempPolylines.add(
        Polyline(
          polylineId: const PolylineId("running"),
          points: points,
          width: 4,
          color: Colors.blue,
        ),
      );
      notifyListeners();
      Wakelock.disable();
      return false;
    } else {
      _courseStart = true;
      Wakelock.enable();
      tempPolylines.clear();
      _chrono.startTimer();
      try {
        _position.startCourse();
      } catch (e) {
        _courseStart = false;
        _chrono.stopTimer();
        rethrow;
      }
      notifyListeners();
      await Future.delayed(const Duration(milliseconds: 500));
      while (_courseStart) {
        await Future.delayed(const Duration(milliseconds: 5));
      }
      return true;
    }
  }
}
