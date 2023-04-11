import 'dart:async';
import 'dart:math';

import 'package:athlete_iq/data/network/userRepository.dart';
import 'package:athlete_iq/model/Parcour.dart';
import 'package:athlete_iq/model/Timer.dart';
import 'package:athlete_iq/ui/providers/position_provider.dart';
import 'package:athlete_iq/utils/map_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:location/location.dart';
import 'package:unicons/unicons.dart';

import '../../data/network/parcoursRepository.dart';
import '../../model/User.dart' as userModel;
import '../../utils/visibility.dart';
import '../home/home_view_model_provider.dart';
import '../home/providers/timer_provider.dart';
import '../info/provider/user_provider.dart';
import '../providers/loading_provider.dart';

final registerViewModelProvider =
    ChangeNotifierProvider.autoDispose<RegisterViewModel>(
  (ref) => RegisterViewModel(ref.read),
);

class RegisterViewModel extends ChangeNotifier {
  final Reader _reader;
  RegisterViewModel(this._reader);

  Loading get _loading => _reader(loadingProvider);

  TimerClassProvider get _chrono => _reader(timerProvider);

  HomeViewModel get _homeProvier => _reader(homeViewModelProvider);

  PositionModel get _position => _reader(positionProvider);

  ParcourVisibility visibility = ParcourVisibility.Public;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final UserRepository _userRepo = UserRepository();

  final ParcourRepository _parcourRepo = ParcourRepository();

  User? get user => _auth.currentUser;

  Parcours? _initial;
  Parcours get initial =>
      _initial ??
      Parcours.empty().copyWith(
        createdAt: DateTime.now(),
      );
  set initial(Parcours initial) {
    _initial = initial;
  }

  String _title = '';
  String get title => _title;
  set title(String title) {
    _title = title;
    notifyListeners();
  }

  String _description = '';
  String get description => _description;
  set description(String description) {
    _description = description;
    notifyListeners();
  }

  List<String> _share = [];
  List<String> get share => _share;
  set share(List<String> share) {
    _share = share;
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
    _coursePosition = _position.allPostion;
    _setLocation();
    _totalDistance = _calculeTotaleDistance(
        _coursePosition.map((e) => LatLng(e.latitude!, e.longitude!)).toList());
    _VM = _calculVM();
    notifyListeners();
  }

  void _setLocation() async {
    final allPoints =
        _coursePosition.map((e) => LatLng(e.latitude!, e.longitude!)).toList();
    _controller.animateCamera(
      CameraUpdate.newLatLngBounds(
          MapUtils.boundsFromLatLngList(allPoints), 20),
    );
  }

  double _calculeTotaleDistance(List<LatLng> data) {
    double totalDistance = 0;
    for (var i = 0; i < data.length - 1; i++) {
      totalDistance += _calculDistance(data[i].latitude, data[i].longitude,
          data[i + 1].latitude, data[i + 1].longitude);
    }
    return totalDistance;
  }

  double _calculDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  double _calculVM() {
    final totalInHour =
        _chrono.hour + _chrono.minute / 60 + _chrono.seconds / 3600;

    final result = _totalDistance / totalInHour;

    return result;
  }

  void changeVisibility() {
    if (visibility == ParcourVisibility.Public) {
      visibility = ParcourVisibility.Protected;
      notifyListeners();
      return;
    } else if (visibility == ParcourVisibility.Protected) {
      share.clear();
      visibility = ParcourVisibility.Private;
      notifyListeners();
      return;
    } else {
      share.clear();
      visibility = ParcourVisibility.Public;
      notifyListeners();
      return;
    }
  }

  String switchCaseVisibility() {
    switch (visibility) {
      case ParcourVisibility.Public:
        return "Public";
      case ParcourVisibility.Private:
        return "Privé";
      case ParcourVisibility.Protected:
        return "Entre amis";
      default:
        return "Public";
    }
  }

  IconData switchCaseIconVisibility() {
    switch (visibility) {
      case ParcourVisibility.Public:
        return UniconsLine.globe;
      case ParcourVisibility.Private:
        return UniconsLine.lock;
      case ParcourVisibility.Protected:
        return Icons.shield;
      default:
        return UniconsLine.globe;
    }
  }

  void addRemoveFriend(bool? value, String uid) {
    if (value ?? false) {
      _share.add(uid);
    } else {
      _share.remove(uid);
    }
    notifyListeners();
  }

  void register() async {
    final CustomTimer timer = CustomTimer.empty();
    timer.hours = _chrono.hour;
    timer.minutes = _chrono.minute;
    timer.seconds = _chrono.seconds;
    final newParcour = initial.copyWith(
      title: title,
      description: description,
      owner: user?.uid,
      type: visibility.name,
      shareTo: share,
      timer: timer,
      VM: VM,
      totalDistance: totalDistance,
      allPoints: coursePosition,
    );
    print(newParcour.timer.hours);
    _loading.start();
    try {
      await _parcourRepo.writeParcours(newParcour);
      userModel.UserModel user =
          await _userRepo.getUserWithId(userId: _auth.currentUser!.uid);
      await _userRepo
          .updateUser(user.copyWith(totalDist: user.totalDist+totalDistance));
      _homeProvier.setLocation();
      _loading.end();
    } catch (e) {
      Future.error(e);
    }
  }
}
