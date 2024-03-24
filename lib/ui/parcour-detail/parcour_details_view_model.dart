import 'package:athlete_iq/data/network/parcoursRepository.dart';
import 'package:athlete_iq/ui/auth/providers/auth_view_model_provider.dart';
import 'package:athlete_iq/utils/speedConverter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:unicons/unicons.dart';

import '../../data/network/userRepository.dart';
import '../../model/Parcour.dart';
import '../../utils/visibility.dart';

final parcourDetailsViewModel =
    ChangeNotifierProvider.autoDispose<ParcourDetailsViewModel>(
  (ref) => ParcourDetailsViewModel(ref),
);

class ParcourDetailsViewModel extends ChangeNotifier {
  final Ref _reader;
  ParcourDetailsViewModel(this._reader);

  UserRepository get _repository => _reader.read(userRepositoryProvider);
  ParcourRepository get parcourRepo => _reader.read(parcourRepositoryProvider);
  FirebaseAuth get auth => _reader.read(firebaseAuthProvider);

  Parcours? parcour;

  ParcourVisibility visibility = ParcourVisibility.Public;

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

  List<dynamic> _share = [];
  List<dynamic> get share => _share;
  set share(List<dynamic> share) {
    _share = share;
    notifyListeners();
  }

  double? caculatMaxSpeed(Parcours parcour) {
    double? maxSpeed = parcour.allPoints
        .reduce((curr, next) => curr.speed! > next.speed! ? curr : next)
        .speed;
    return toKmH(speed: maxSpeed!);
  }

  double? calculatMinSpeed(Parcours parcour) {
    double? minSpeed = parcour.allPoints
        .reduce((curr, next) => curr.speed! < next.speed! ? curr : next)
        .speed;
    return toKmH(speed: minSpeed!);
  }

  double? caculatMaxAltitude(Parcours parcour) {
    double? maxAlt = parcour.allPoints
        .reduce((curr, next) => curr.altitude! > next.altitude! ? curr : next)
        .speed;
    return maxAlt;
  }

  double? calculatMinAltitude(Parcours parcour) {
    double? minAlt = parcour.allPoints
        .reduce((curr, next) => curr.altitude! < next.altitude! ? curr : next)
        .speed;
    return minAlt;
  }

  Future<void> addToFav(Parcours parcour) async {
    try {
      final currentUser =
          await _repository.getUserWithId(userId: auth.currentUser!.uid);
      currentUser.fav.add(parcour.id);
      await _repository.updateUser(currentUser);
    } catch (e) {
      return Future.error(e);
    }
    notifyListeners();
  }

  Future<void> removeToFav(Parcours parcour) async {
    try {
      final currentUser =
          await _repository.getUserWithId(userId: auth.currentUser!.uid);
      currentUser.fav.removeWhere((value) => value == parcour.id);
      await _repository.updateUser(currentUser);
      notifyListeners();
    } catch (e) {
      return Future.error(e);
    }
    notifyListeners();
  }

  void shareParcour(BuildContext context, Parcours parcour) {
    String parcourLink = "athleteiq://parcours/details/${parcour.id}";
    String message = "Découvrez ce parcours sur Athlete IQ: $parcourLink";

    Share.share(message);
  }

  void initValue(Parcours args) {
    parcour = args;
    _title = args.title;
    _description = args.description;
    _share = args.shareTo;
    visibility = args.type == 'Public'
        ? ParcourVisibility.Public
        : args.type == 'Private'
            ? ParcourVisibility.Private
            : ParcourVisibility.Protected;
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

  void addRemoveFriend(bool? value, String uid) {
    if (value ?? false) {
      _share.add(uid);
    } else {
      _share.remove(uid);
    }
    notifyListeners();
  }

  Future<void> updateParcour() async {
    try {
      await parcourRepo.updateParcour(
          data: Parcours(
              id: parcour!.id,
              owner: parcour!.owner,
              title: title,
              description: description,
              type: visibility.name,
              shareTo: share,
              timer: parcour!.timer,
              createdAt: parcour!.createdAt,
              VM: parcour!.VM,
              totalDistance: parcour!.totalDistance,
              allPoints: parcour!.allPoints));
    } catch (e) {
      initValue(parcour!);
      return Future.error(e);
    }
  }

  Future<void> deleteParcour() async {
    try {
      await parcourRepo.delete(parcour!.id);
    } catch (e) {
      initValue(parcour!);
      return Future.error(e);
    }
  }
}
