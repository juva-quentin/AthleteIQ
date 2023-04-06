import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../data/network/groupsRepository.dart';
import '../../../model/Groups.dart';
import '../../../utils/visibility.dart';
import '../../providers/loading_provider.dart';

final creatGroupViewModelProvider =
ChangeNotifierProvider.autoDispose((ref) => CreatGroupViewModel(ref.read));

class CreatGroupViewModel extends ChangeNotifier {
  final Reader _reader;
  GroupType visibility = GroupType.Public;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  CreatGroupViewModel(this._reader);

  Groups? _initial;
  Groups get initial =>  _initial ??
  Groups.empty().copyWith(
  admin: _auth.currentUser?.uid,
    members: [_auth.currentUser!.uid]
  );
  set initial(Groups initial) {
    _initial = initial;
  }

  String? get image => initial.groupIcon.isNotEmpty ? initial.groupIcon: null;

  bool get edit => initial.id.isNotEmpty;

  String? _groupName;
  String get groupName => _groupName ?? initial.groupName;
  set groupName(String groupName) {
    _groupName = groupName;
    notifyListeners();
  }

  String? _groupType;
  String get groupType => _groupType ?? initial.type;
  set groupType(String groupType) {
    _groupType = groupType;
    notifyListeners();
  }

  File? _file;
  File? get file => _file;
  set file(File? file) {
    _file = file;
    notifyListeners();
  }

  void changeType() {
    if (visibility == GroupType.Public) {
      visibility = GroupType.Private;
      groupType = "Private";
      notifyListeners();
      return;
    } else {
      visibility = GroupType.Public;
      groupType = "Public";
      notifyListeners();
      return;
    }
  }

  String switchCaseChangeType() {
    switch (visibility) {
      case GroupType.Public:
        return "Public";
      case GroupType.Private:
        return "Privé";
      default:
        return "Public";
    }
  }

  bool get enabled => groupName.isNotEmpty&&(image!=null||file!=null);

  Loading get _loading => _reader(loadingProvider);

  GroupsRepository get _repository => _reader(groupsRepositoryProvider);

  Future<void> write() async {
    final updated = initial.copyWith(
      groupName: groupName,
      type: groupType,
    );
    _loading.start();
    try {
      await _repository.writeGroups(updated, file: file);
      _loading.stop();
    } catch (e) {
      _loading.end();
      return Future.error("Something error!");
    }
  }

  void clear() {
    _initial = null;
    _groupName = null;
    _groupType = null;
    _file = null;
  }
}
