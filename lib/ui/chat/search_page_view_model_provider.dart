import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../home/providers/timer_provider.dart';
import '../providers/loading_provider.dart';

final searchPageViewModelProvider = ChangeNotifierProvider.autoDispose(
      (ref) => SearchPageViewModel(ref.read),
);

class SearchPageViewModel extends ChangeNotifier {
  final Reader _reader;
  SearchPageViewModel(this._reader);

  Loading get _loading => _reader(loadingProvider);

  String _name = "";
  String get name => _name;
  set name(String name) {
    _name = name;
    notifyListeners();
  }

}