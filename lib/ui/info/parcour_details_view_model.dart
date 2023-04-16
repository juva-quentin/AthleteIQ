import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../model/Parcour.dart';

final parcourDetailsViewModel = ChangeNotifierProvider.autoDispose<ParcourDetailsViewModel>(
      (ref) => ParcourDetailsViewModel(ref.read),
);

class ParcourDetailsViewModel extends ChangeNotifier {
  final Reader _reader;
  ParcourDetailsViewModel(this._reader);

  double? caculatMaxSpeed(Parcours parcour){
    double? maxSpeed = parcour.allPoints.reduce((curr, next) => curr.speed! > next.speed! ? curr : next).speed;
    return maxSpeed;
  }
  double? calculatMinSpeed(Parcours parcour){
    double? minSpeed = parcour.allPoints.reduce((curr, next) => curr.speed! < next.speed! ? curr : next).speed;
    return minSpeed;
  }
  double? caculatMaxAltitude(Parcours parcour){
    double? maxSpeed = parcour.allPoints.reduce((curr, next) => curr.altitude! > next.altitude! ? curr : next).speed;
    return maxSpeed;
  }
  double? calculatMinAltitude(Parcours parcour){
    double? minSpeed = parcour.allPoints.reduce((curr, next) => curr.altitude! < next.altitude! ? curr : next).speed;
    return minSpeed;
  }
}