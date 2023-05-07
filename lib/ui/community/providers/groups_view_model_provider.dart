import 'package:athlete_iq/data/network/groupsRepository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unicons/unicons.dart';

import '../../../model/Groups.dart' as groupsModel;
import '../../../model/Groups.dart';
import '../../../utils/visibility.dart';
import '../../providers/loading_provider.dart';

final groupsViewModelProvider = ChangeNotifierProvider.autoDispose(
      (ref) => GroupsViewModel(ref.read),
);

class GroupsViewModel extends ChangeNotifier {
  final Reader _reader;
  GroupsViewModel(this._reader);

  Loading get _loading => _reader(loadingProvider);

  final FirebaseAuth _auth = FirebaseAuth.instance;

  GroupsRepository get _groupRepo => _reader(groupsRepositoryProvider);

  final titleController = TextEditingController();

  final formUpdateKey = GlobalKey<FormState>();

  String get title => titleController.text;

  GroupType visibility = GroupType.Public;

  Groups? currentGroupe;

  List<dynamic> _share = [];
  List<dynamic> get share => _share;
  set share(List<dynamic> share) {
    _share = share;
    notifyListeners();
  }

  void actu() {
    notifyListeners();
  }

  String switchCaseVisibility() {
    switch (visibility) {
      case GroupType.Public:
        return "Public";
      case GroupType.Private:
        return "Privé";
      default:
        return "Public";
    }
  }

  IconData switchCaseIconVisibility() {
    switch (visibility) {
      case GroupType.Public:
        return UniconsLine.globe;
      case GroupType.Private:
        return UniconsLine.lock;
      default:
        return UniconsLine.globe;
    }
  }

  void changeVisibility() {
    if (visibility == GroupType.Public) {
      visibility = GroupType.Private;
      notifyListeners();
      return;
    } else {
      share.clear();
      visibility = GroupType.Public;
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

  Future<void> getGroupInfo(String id) async {
    _loading.start();
    try {
      currentGroupe =
      await _groupRepo.getGroupById(id);
      titleController.text = currentGroupe!.groupName;
      share = currentGroupe!.members;
      _loading.stop();
    } catch (e) {
      Future.error(e);
    }
  }

  bool valideForm() {
    if (title !=  '') {
      return true;
    }
    return false;
  }

  Future<void> updateUser() async {
    _loading.start();
    try {
      await _groupRepo.updateGroup(currentGroupe!.id, currentGroupe!.copyWith(
        groupName: title,
        members: share,
        type: visibility.name
      ));
    } catch (e) {
      _loading.stop();
      return Future.error(e);
    }
    _loading.stop();
  }

}