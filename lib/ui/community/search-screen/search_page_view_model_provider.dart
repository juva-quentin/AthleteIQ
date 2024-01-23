import 'package:athlete_iq/data/network/groupsRepository.dart';
import 'package:athlete_iq/data/network/userRepository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rxdart/rxdart.dart';

import '../../../model/Groups.dart';
import '../../../model/User.dart' as userModel;
import '../../providers/loading_provider.dart';

final searchPageViewModelProvider = ChangeNotifierProvider.autoDispose(
  (ref) => SearchPageViewModel(ref),
);

class SearchPageViewModel extends ChangeNotifier {
  final Ref _reader;
  SearchPageViewModel(this._reader);

  final UserRepository _userRepo = UserRepository();
  final GroupsRepository _groupRepo = GroupsRepository();

  Loading get _loading => _reader.read(loadingProvider);
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String _name = "";
  String get name => _name;
  set name(String name) {
    _name = name;
    notifyListeners();
  }

  CombineLatestStream<List<Object>, dynamic> combineStream() {
    final userStream = _userRepo.usersStream.map((snapshot) => snapshot.docs
        .map((e) => userModel.UserModel.fromFirestore(e))
        .toList());
    final groupStream = _groupRepo.groupsStream.map((snapshot) =>
        snapshot.docs.map((e) => Groups.fromFirestore(e)).toList());

    return CombineLatestStream([userStream, groupStream], (value) {
      List<Object> result = [];
      for (var objs in value) {
        result.addAll(objs);
      }
      return result;
    });
  }

  Future<void> addFriend(String userId) async {
    try {
      userModel.UserModel userFriend =
          await _userRepo.getUserWithId(userId: userId);
      userModel.UserModel user =
          await _userRepo.getUserWithId(userId: _auth.currentUser!.uid);
      userFriend.awaitFriends.add(_auth.currentUser?.uid);
      user.pendingFriendRequests.add(userId);
      await _userRepo.updateFriendToFirestore(
          dataUserFriend: userFriend, dataUser: user);
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<void> addUserToGroup(Groups group) async {
    try {
      group.members.add(_auth.currentUser?.uid);
      await _groupRepo.updateGroup(group.id, group);
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<void> removeUserToGroup(Groups group) async {
    try {
      group.members.removeWhere((item) => item == _auth.currentUser?.uid);
      await _groupRepo.updateGroup(group.id, group);
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<void> removeFriend(userModel.UserModel friend) async {
    try {
      final currentUser =
          await _userRepo.getUserWithId(userId: _auth.currentUser!.uid);
      currentUser.friends.removeWhere((item) => item == friend.id);
      friend.friends
          .removeWhere((element) => element == _auth.currentUser!.uid);
      await _userRepo.updateFriendToFirestore(
          dataUserFriend: friend, dataUser: currentUser);
    } catch (e) {
      Future.error(e);
    }
  }
}
