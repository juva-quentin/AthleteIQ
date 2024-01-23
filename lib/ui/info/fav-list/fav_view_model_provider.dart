import 'package:athlete_iq/data/network/parcoursRepository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../data/network/userRepository.dart';
import '../../../model/Parcour.dart';
import '../../../model/User.dart';
import '../../providers/loading_provider.dart';

final favListViewModelProvider =
    ChangeNotifierProvider.autoDispose<favListViewModel>(
  (ref) => favListViewModel(ref),
);

class favListViewModel extends ChangeNotifier {
  final Ref _reader;
  favListViewModel(this._reader);
  UserRepository get _repository => _reader.read(userRepositoryProvider);
  ParcourRepository get _parcourRepo => _reader.read(parcourRepositoryProvider);
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<Parcours> favParcour = [];

  Future<void> init() async {
    try {
      await loadFavs();
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<void> loadFavs() async {
    try {
      List<Parcours> resultFavsId = [];
      UserModel result =
          await _repository.getUserWithId(userId: _auth.currentUser!.uid);
      for (var parcourId in result.fav) {
        final parcour =
            await _parcourRepo.getParcourWithId(parcourId: parcourId);
        resultFavsId.add(parcour);
      }
      favParcour = resultFavsId;
      notifyListeners();
    } catch (e) {
      return Future.error(e);
    }
  }
}
