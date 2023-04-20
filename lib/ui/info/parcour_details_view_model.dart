import 'package:athlete_iq/data/network/parcoursRepository.dart';
import 'package:athlete_iq/ui/auth/providers/auth_view_model_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../data/network/userRepository.dart';
import '../../model/Parcour.dart';
import '../../model/User.dart';

final parcourDetailsViewModel = ChangeNotifierProvider.autoDispose<ParcourDetailsViewModel>(
      (ref) => ParcourDetailsViewModel(ref.read),
);

class ParcourDetailsViewModel extends ChangeNotifier {
  final Reader _reader;
  ParcourDetailsViewModel(this._reader);

  UserRepository get _repository => _reader(userRepositoryProvider);
  ParcourRepository get _parcourRepo => _reader(parcourRepositoryProvider);
  FirebaseAuth get auth => _reader (firebaseAuthProvider);


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
  Future<void> addToFav(Parcours parcour) async{
    try{
      final currentUser = await _repository.getUserWithId(userId: auth.currentUser!.uid);
      currentUser.fav.add(parcour.id);
      await _repository.updateUser(currentUser);
    }catch(e){
      return Future.error(e);
    }
    notifyListeners();
  }
  Future<void> removeToFav(Parcours parcour) async{
    try{
      final currentUser = await _repository.getUserWithId(userId: auth.currentUser!.uid);
      currentUser.fav.removeWhere((value)=> value == parcour.id);
      await _repository.updateUser(currentUser);
      notifyListeners();
    }catch(e){
      return Future.error(e);
    }
    notifyListeners();
  }
}