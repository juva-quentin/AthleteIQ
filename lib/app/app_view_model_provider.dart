import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../model/rive_asset.dart';
import '../ui/community/homeChat_screen.dart';
import '../ui/home/home_screen.dart';
import '../ui/info/info_screen.dart';

final appViewModelProvider = ChangeNotifierProvider.autoDispose<AppViewModel>(
      (ref) => AppViewModel(ref.read),
);


class AppViewModel extends ChangeNotifier {
  final Reader _reader;

  AppViewModel(this._reader);


  int _selectedIndex = 1;
  int get selectedIndex => _selectedIndex;
  set selectedIndex(int selectedIndex) {
    _selectedIndex = selectedIndex;
    notifyListeners();
  }

  RiveAsset _selectedBottomNav = bottomNavs[1];
  RiveAsset get selectedBottomNav => _selectedBottomNav;
  set selectedBottomNav(RiveAsset selectedBottomNav) {
    _selectedBottomNav = selectedBottomNav;
    notifyListeners();
  }

  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);


  static const List<Widget> _widgetOptions = <Widget>[
    HomeChatScreen(),
    HomeScreen(),
    InfoScreen()
  ];
  List<Widget> get widgetOptions => _widgetOptions;

}