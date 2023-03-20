import 'dart:async';

import 'package:athlete_iq/ui/home/home_view_model_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:location/location.dart';

import '../../utils/utils.dart';


final positionProvider = ChangeNotifierProvider(
      (ref) => PositionModel(ref.read),
);

class PositionModel extends ChangeNotifier {

  final Reader _reader;
  PositionModel(this._reader);

  Location location = Location();

  HomeViewModel get homeProvider => _reader(homeViewModelProvider);

  List<LocationData> _allPosition = [];
  List<LocationData> get allPostion => _allPosition;
  set allPosition(List<LocationData> allPosition){
    allPosition = _allPosition;
    notifyListeners();
  }

  StreamSubscription<LocationData>? _streamPosition;

  double _speed = 0;
  double get speed => _speed;
  set speed(double speed){
    speed = _speed;
    notifyListeners();
  }

  // void _getLocationSettings(){
  //   if (defaultTargetPlatform == TargetPlatform.android) {
  //     _locationSettings = AndroidSettings(
  //         accuracy: LocationAccuracy.high,
  //         distanceFilter: 100,
  //         forceLocationManager: true,
  //         intervalDuration: const Duration(seconds: 10),
  //         //(Optional) Set foreground notification config to keep the app alive
  //         //when going to the background
  //         foregroundNotificationConfig: const ForegroundNotificationConfig(
  //           notificationText:
  //           "Example app will continue to receive your location even when you aren't using it",
  //           notificationTitle: "Running in Background",
  //           enableWakeLock: true,
  //         )
  //     );
  //   } else if (defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.macOS) {
  //     _locationSettings = AppleSettings(
  //       accuracy: LocationAccuracy.high,
  //       activityType: ActivityType.fitness,
  //       distanceFilter: 50,
  //       pauseLocationUpdatesAutomatically: true,
  //       // Only set to true if our app will be started up in the background.
  //       showBackgroundLocationIndicator: true,
  //     );
  //   } else {
  //     _locationSettings = const LocationSettings(
  //       accuracy: LocationAccuracy.high,
  //       distanceFilter: 100,
  //     );
  //   }
  // }

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
    if (permission == PermissionStatus.denied || permission == PermissionStatus.grantedLimited) {
      permission = await location.requestPermission();
      if (permission == PermissionStatus.denied) {
        Utils.toastMessage("La localisation n'est pas autorisée");
        return false;
      }
    }
    if (permission == PermissionStatus.deniedForever) {
      Utils.toastMessage("Votre service de localisation est pour toujours refusé nous ne pouvons pas la demander");
      return false;
    }
    return true;
  }

  Future<LocationData> getPosition() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return Future.error('no location permission');
    return await location.getLocation()
        .catchError((e) {
          return Future.error(e);
      Utils.toastMessage(e);
      debugPrint(e);
    });
  }

  Future<Stream<LocationData>> _getStreamPosition() async{
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission)return Future.error('no location permission');
    location.changeSettings(accuracy: LocationAccuracy.navigation, interval: 50);

    return location.onLocationChanged;
  }

  Future<void> startCourse() async {
    _allPosition.clear();
    final Stream<LocationData> stream;
    try{ stream =  await _getStreamPosition();
    _streamPosition = stream.listen((LocationData currentLocation) {
      _speed = currentLocation.speed!;
      _allPosition.add(currentLocation);
      homeProvider.setLocationDuringCours(currentLocation);
      notifyListeners();
    });
    }catch(e){
      print(e.toString());
    };


  }
  
  Future<void> stopCourse()async {
    await _streamPosition?.cancel().onError((error, stackTrace) => Future.error);
  }

}