import 'package:athlete_iq/data/network/groupsRepository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../data/network/userRepository.dart';

final chatViewModelProvider = ChangeNotifierProvider.autoDispose(
  (ref) => ChatViewModel(ref.read),
);

class ChatViewModel extends ChangeNotifier {

  ScrollController scrollController = ScrollController();

  final Reader _reader;

  final UserRepository _userRepo = UserRepository();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  GroupsRepository get _groupRepo => _reader(groupsRepositoryProvider);

  ChatViewModel(this._reader);

  Future<void> init() async {
    await getChatAndAdmin();
  }

  bool isAdmin(String owner){
    return owner == _auth.currentUser!.uid;
  }

  Stream<QuerySnapshot>? _chats;
  Stream<QuerySnapshot>? get chats => _chats;
  set chats(Stream<QuerySnapshot>? chats) {
    _chats = chats;
    notifyListeners();
  }

  TextEditingController messageController = TextEditingController();


  String _username = "";
  String get username => _username;
  set username(String username) {
    _username = username;
    notifyListeners();
  }

  String _groupeId = "";
  String get groupeId => _groupeId;
  set groupeId(String groupeId) {
    _groupeId = groupeId;
    notifyListeners();
  }

  getChatAndAdmin() async {
    await _groupRepo.getChats(_groupeId).then((val) {
      chats = val;
      notifyListeners();
    });
    await _userRepo.getUserWithId(userId: _auth.currentUser!.uid).then((value) {
      _username = value.pseudo;
      notifyListeners();
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
        GroupsRepository().sendMessage(_groupeId, chatMessageMap);
        messageController.clear();
        notifyListeners();
      });
    }
  }

  String formatMessageDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inHours < 24) {
      // Moins de 24 heures écoulées, afficher le temps écoulé
      return  difference.inHours != 0 ? 'Il y à ${difference.inHours}h${difference.inMinutes.remainder(60)}min' : '${difference.inMinutes.remainder(60)}min';
    } else {
      // Plus de 24 heures écoulées, afficher la date complète
      final formatter = DateFormat('dd/MM/yyyy');
      return formatter.format(dateTime);
    }
  }

  Future<void> removeUserToGroup() async{
    try {
      final group = await _groupRepo.getGroupById(_groupeId);
      group.members.removeWhere((item)=> item == _auth.currentUser?.uid);
      await _groupRepo.updateGroup(group.id, group);
    } catch (e) {
      return Future.error(e);
    }
  }
}
