import 'package:athlete_iq/data/network/parcoursRepository.dart';
import 'package:athlete_iq/data/network/userRepository.dart';
import 'package:athlete_iq/ui/info/fav-list/fav_list_screen.dart';
import 'package:athlete_iq/ui/info/friend-list/friends_list_screen.dart';
import 'package:athlete_iq/ui/info/info_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import '../../model/User.dart' as userModel;
import 'courses_list_screen.dart';

final infoViewModelProvider = ChangeNotifierProvider.autoDispose<InfoViewModel>(
  (ref) => InfoViewModel(ref),
);

class InfoViewModel extends ChangeNotifier {
  final Ref _reader;
  InfoViewModel(this._reader);
  UserRepository get repository => _reader.read(userRepositoryProvider);
  ParcourRepository get parcourRepository =>
      _reader.read(parcourRepositoryProvider);
  final FirebaseAuth _auth = FirebaseAuth.instance;

  dynamic _file;
  File get file => _file;
  set file(File file) {
    _file = file;
    notifyListeners();
  }

  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;
  set selectedIndex(int selectedIndex) {
    _selectedIndex = selectedIndex;
    notifyListeners();
  }

  String _selectedBottomNav = middleNav[0];
  String get selectedBottomNav => _selectedBottomNav;
  set selectedBottomNav(String selectedBottomNav) {
    _selectedBottomNav = selectedBottomNav;
    notifyListeners();
  }

  static const List<Widget> _widgetOptions = <Widget>[
    CoursesListScreen(),
    FavListScreen(),
    FriendsListScreen(),
  ];
  List<Widget> get widgetOptions => _widgetOptions;

  int nbrDays() {
    var date = DateFormat.EEEE().format(DateTime.now());
    List<String> days = [
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday",
      'Sunday'
    ];
    var index1 = days.indexWhere((element) => element == date);
    if (index1 >= 0) {
      return 7 - (index1 + 1);
    }
    return 0;
  }

  double advencementBar(int objectif, advencement) {
    double result = ((advencement * 100) / objectif) / 100;
    if (objectif == 0) {
      return 0.0;
    }
    if (result <= 0) {
      return 0.0;
    } else if (result > 1) {
      return 1.0;
    } else {
      return result;
    }
  }

  double advencement(int objectif, advencement) {
    double result = ((advencement * 100) / objectif) / 100;
    if (objectif == 0) {
      return 0.0;
    }
    if (result <= 0) {
      return 0.0;
    } else {
      return result;
    }
  }

  Future<void> updateUserImage() async {
    try {
      userModel.UserModel user =
          await repository.getUserWithId(userId: _auth.currentUser!.uid);
      await repository.writeUser(user, file: _file);
    } catch (e) {
      return Future.error(e);
    }
  }
}
