import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../data/network/groupsRepository.dart';
import '../../../model/Groups.dart';
import '../../providers/loading_provider.dart';

final creatGroupViewModelProvider =
ChangeNotifierProvider.autoDispose((ref) => CreatGroupViewModel(ref.read));

class CreatGroupViewModel extends ChangeNotifier {
  final Reader _reader;
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

  File? _file;
  File? get file => _file;
  set file(File? file) {
    _file = file;
    notifyListeners();
  }


  bool get enabled => groupName.isNotEmpty&&(image!=null||file!=null);

  Loading get _loading => _reader(loadingProvider);

  GroupsRepository get _repository => _reader(GroupsRepositoryProvider);

  Future<void> write() async {
    final updated = initial.copyWith(
      groupName: groupName,
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
    _file = null;
  }
}
