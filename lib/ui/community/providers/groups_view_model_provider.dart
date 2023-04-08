import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../model/Groups.dart' as groupsModel;
import '../../providers/loading_provider.dart';

final groupsViewModelProvider = ChangeNotifierProvider.autoDispose(
      (ref) => GroupsViewModel(ref.read),
);

class GroupsViewModel extends ChangeNotifier {
  final Reader _reader;
  GroupsViewModel(this._reader);

}