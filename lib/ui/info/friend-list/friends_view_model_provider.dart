import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../data/network/userRepository.dart';
import '../../../model/User.dart' as userModel;

final friendsViewModelProvider =
    ChangeNotifierProvider.autoDispose<FriendsViewModel>(
  (ref) => FriendsViewModel(ref),
);

class FriendsViewModel extends ChangeNotifier {
  final Ref _reader;
  FriendsViewModel(this._reader);
  UserRepository get _repository => _reader.read(userRepositoryProvider);
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<userModel.UserModel> awaitFriends = [];
  List<userModel.UserModel> friends = [];

  Future<void> init() async {
    try {
      await loadFriends();
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<void> loadFriends() async {
    try {
      List<userModel.UserModel> resultFriends = [];
      List<userModel.UserModel> resultAwaitFriends = [];
      userModel.UserModel result =
          await _repository.getUserWithId(userId: _auth.currentUser!.uid);
      for (var userId in result.awaitFriends) {
        final friend = await _repository.getUserWithId(userId: userId);
        resultAwaitFriends.add(friend);
      }
      for (var userId in result.friends) {
        final friend = await _repository.getUserWithId(userId: userId);
        resultFriends.add(friend);
      }
      friends = resultFriends;
      awaitFriends = resultAwaitFriends;
      notifyListeners();
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<void> valideInvalideFriend(
      userModel.UserModel friend, bool valide) async {
    try {
      final currentUser =
          await _repository.getUserWithId(userId: _auth.currentUser!.uid);
      currentUser.awaitFriends.removeWhere((item) => item == friend.id);
      friend.pendingFriendRequests
          .removeWhere((item) => item == _auth.currentUser!.uid);
      if (valide) {
        currentUser.friends.add(friend.id);
        friend.friends.add(_auth.currentUser!.uid);
      }
      await _repository
          .updateFriendToFirestore(
              dataUserFriend: friend, dataUser: currentUser)
          .then((value) => loadFriends());
    } catch (e) {
      Future.error(e);
    }
  }

  Future<void> removeFriend(userModel.UserModel friend) async {
    try {
      final currentUser =
          await _repository.getUserWithId(userId: _auth.currentUser!.uid);
      currentUser.friends.removeWhere((item) => item == friend.id);
      friend.friends
          .removeWhere((element) => element == _auth.currentUser!.uid);
      await _repository
          .updateFriendToFirestore(
              dataUserFriend: friend, dataUser: currentUser)
          .then((value) => loadFriends());
    } catch (e) {
      Future.error(e);
    }
  }
}
