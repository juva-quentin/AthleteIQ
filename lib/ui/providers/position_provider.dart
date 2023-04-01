import 'dart:async';

import 'package:athlete_iq/ui/home/home_view_model_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:location/location.dart';

import '../../utils/utils.dart';

final positionProvider = ChangeNotifierProvider.autoDispose(
  (ref) => PositionModel(ref.read),
);

class PositionModel extends ChangeNotifier {
  final Reader _reader;
  PositionModel(this._reader);

  Location location = Location();

  HomeViewModel get homeProvider => _reader(homeViewModelProvider);

  List<LocationData> _allPosition = [];
  List<LocationData> get allPostion => _allPosition;
  set allPosition(List<LocationData> allPosition) {
    allPosition = _allPosition;
    notifyListeners();
  }

  StreamSubscription<LocationData>? _streamPosition;

  double _speed = 0;
  double get speed => _speed;
  set speed(double speed) {
    speed = _speed;
    notifyListeners();
  }

  Future<bool> _handleLocationPermission() async {
    bool _serviceEnabled;
    PermissionStatus permission;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return false;
      }
    }
    permission = await location.hasPermission();
    if (permission == PermissionStatus.denied ||
        permission == PermissionStatus.grantedLimited) {
      permission = await location.requestPermission();
      if (permission == PermissionStatus.denied) {
        Utils.toastMessage("La localisation n'est pas autorisée");
        return false;
      }
    }
    if (permission == PermissionStatus.deniedForever) {
      Utils.toastMessage(
          "Votre service de localisation est pour toujours refusé nous ne pouvons pas la demander");
      return false;
    }
    location.enableBackgroundMode(enable: true);
    return true;
  }

  Future<LocationData> getPosition() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return Future.error('no location permission');
    return await location.getLocation().catchError((e) {
      throw (e);
    });
  }

  Future<Stream<LocationData>> _getStreamPosition() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return Future.error('no location permission');
    location.changeSettings(
        accuracy: LocationAccuracy.navigation, interval: 50);

    return location.onLocationChanged;
  }

  Future<void> startCourse() async {
    _allPosition.clear();
    final Stream<LocationData> stream;
    try {
      stream = await _getStreamPosition();
      _streamPosition = stream.listen((LocationData currentLocation) {
        _speed = currentLocation.speed!;
        _allPosition.add(currentLocation);
        homeProvider.setLocationDuringCours(currentLocation);
        notifyListeners();
      });
    } catch (e) {
      rethrow;
    }

  }

  Future<void> stopCourse() async {
    await _streamPosition
        ?.cancel()
        .onError((error, stackTrace) => Future.error);
  }
}
