import 'package:athlete_iq/data/network/groupsRepository.dart';
import 'package:athlete_iq/data/network/userRepository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rxdart/rxdart.dart';
import '../../model/Groups.dart';
import '../../model/User.dart' as userModel;
import '../providers/loading_provider.dart';

final searchPageViewModelProvider = ChangeNotifierProvider.autoDispose(
      (ref) => SearchPageViewModel(ref.read),
);

class SearchPageViewModel extends ChangeNotifier {
  final Reader _reader;
  SearchPageViewModel(this._reader);

  final UserRepository _userRepo = UserRepository();
  final GroupsRepository _groupRepo = GroupsRepository();

  Loading get _loading => _reader(loadingProvider);
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String _name = "";
  String get name => _name;
  set name(String name) {
    _name = name;
    notifyListeners();
  }

  CombineLatestStream<List<Object>, dynamic> combineStream(){
    final userStream = _userRepo.usersStream.map((snapshot) =>
        snapshot.docs.map((e) => userModel.User.fromFirestore(e)).toList());
    final groupStream = _groupRepo.groupsStream.map((snapshot) =>
        snapshot.docs.map((e) => Groups.fromFirestore(e)).toList());

    return CombineLatestStream([userStream, groupStream], (value){
      List<Object> result = [];
      for(var objs in value){
        result.addAll(objs);
      }
      print(result);
      return result;
    });
  }

  Future<void> addFriend(String userId) async{
    try {
      userModel.User userFriend =
      await _userRepo.getUserWithId(userId: userId);
      userModel.User user =
      await _userRepo.getUserWithId(userId: _auth.currentUser!.uid);
      userFriend.awaitFriends.add(_auth.currentUser?.uid);
      user.awaitFriends.add(userId);
      print(userId);
      await _userRepo.updateFriendToFirestore(userId,{'awaitFriends': userFriend.awaitFriends}, {'awaitFriends': user.awaitFriends});
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<void> addUserToGroup(Groups group) async{
    try {
      group.members.add(_auth.currentUser?.uid);
      await _groupRepo.updateUserToGroup(group.id, {'members': group.members});
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<void> removeUserToGroup(Groups group) async{
    try {
      group.members.removeWhere((item)=> item == _auth.currentUser?.uid);
      await _groupRepo.updateUserToGroup(group.id, {'members': group.members});
    } catch (e) {
      return Future.error(e);
    }
  }
}