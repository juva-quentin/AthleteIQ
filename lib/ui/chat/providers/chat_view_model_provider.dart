import 'package:athlete_iq/data/network/groupsRepository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../data/network/userRepository.dart';
import 'active_groups_provider.dart';

final chatViewModelProvider = ChangeNotifierProvider.autoDispose(
  (ref) => ChatViewModel(ref.read),
);

class ChatViewModel extends ChangeNotifier {
  final Reader _reader;

  String get groupId => _reader(activeGroupeProvider);

  final UserRepository _userRepo = UserRepository();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  ChatViewModel(this._reader);

  void init() {
    getChatAndAdmin();
  }

  Stream<QuerySnapshot>? _chats;
  Stream<QuerySnapshot>? get chats => _chats;
  set chats(Stream<QuerySnapshot>? chats) {
    _chats = chats;
    notifyListeners();
  }

  TextEditingController messageController = TextEditingController();

  String _admin = "";
  String get admin => _admin;
  set admin(String admin) {
    _admin = admin;
    notifyListeners();
  }

  String _username = "";
  String get username => _username;
  set username(String username) {
    _username = username;
    notifyListeners();
  }

  getChatAndAdmin() async {
    print("groupeId$groupId");
    GroupsRepository().getChats(groupId).then((val) {
      chats = val;
      notifyListeners();
    });
    GroupsRepository().getGroupAdmin(groupId).then((val) {
      admin = val;
      notifyListeners();
    });
    await _userRepo.getUserWithId(userId: _auth.currentUser!.uid).then((value) {
      _username = value.pseudo;
    });
  }

  sendMessage() async {
    if (messageController.text.isNotEmpty) {
      await _userRepo
          .getUserWithId(userId: _auth.currentUser!.uid)
          .then((value) {
        _username = value.pseudo;
        Map<String, dynamic> chatMessageMap = {
          "message": messageController.text,
          "sender": _username,
          "time": DateTime.now(),
        };
        GroupsRepository().sendMessage(groupId, chatMessageMap);
        messageController.clear();
        notifyListeners();
      });
    }
  }
}
