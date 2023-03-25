import 'package:athlete_iq/data/network/groupsRepository.dart';
import 'package:athlete_iq/data/network/parcoursRepository.dart';
import 'package:athlete_iq/data/network/userRepository.dart';
import 'package:athlete_iq/ui/auth/providers/auth_view_model_provider.dart';
import 'package:athlete_iq/ui/info/info_screen.dart';
import 'package:athlete_iq/ui/info/provider/user_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import '../../model/Parcour.dart';
import '../../model/User.dart';
import 'courses_list_screen.dart';

final infoViewModelProvider = ChangeNotifierProvider.autoDispose<InfoViewModel>(
      (ref) => InfoViewModel(ref.read),
);

class InfoViewModel extends ChangeNotifier {
  final Reader _reader;
  InfoViewModel(this._reader);
  UserRepository get _repository => _reader(userRepositoryProvider);
  ParcourRepository get parcourRepository => _reader(parcourRepositoryProvider);

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
    Text(
        'un autre truc '
    ),
    Text(
        'truc de truc'
    ),
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

  double advencement(int objectif, advencement) {
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
}