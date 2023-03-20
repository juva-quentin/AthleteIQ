import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../home/providers/timer_provider.dart';
import '../providers/loading_provider.dart';

class HomeChatViewModel extends ChangeNotifier {
  final Reader _reader;
  HomeChatViewModel(this._reader);

  Loading get _loading => _reader(loadingProvider);
  Stream? groups;

}