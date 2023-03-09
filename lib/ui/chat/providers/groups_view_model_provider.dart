import 'package:athlete_iq/data/network/groupsRepository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../model/Groups.dart' as groupsModel;
import '../../providers/loading_provider.dart';

final groupsViewModelProvider = ChangeNotifierProvider(
      (ref) => GroupsViewModel(ref.read),
);

class GroupsViewModel extends ChangeNotifier {
  final Reader _reader;
  GroupsViewModel(this._reader);
  Loading get _loading => _reader(loadingProvider);
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? get user => _auth.currentUser;
  final GroupsRepository _groupsRepo = GroupsRepository();

  String _groupName = '';
  String get groupName => _groupName;
  set groupName(String groupName) {
    _groupName = groupName;
    notifyListeners();
  }


  Future<void> createGroup() async {
    _loading.start();
    try {
      groupsModel.Groups _groups = groupsModel.Groups(
        id: "",
        admin: _auth.currentUser!.uid,
        groupIcon: '',
        groupName: groupName,
        members:[_auth.currentUser!.uid],
        recentMessage:'',
        recentMessageSender: '',
        recentMessageTime: DateTime.now(),
      );
      await _groupsRepo.writeGroups(_groups);

      _loading.end();
    } catch (e) {
      _loading.stop();
      if (kDebugMode) {
        print(e);
      }
    }
    try {
      ;
      _loading.end();
    } catch (e) {
      _loading.stop();
      if (kDebugMode) {
        print(e);
      }
    }
  }
}