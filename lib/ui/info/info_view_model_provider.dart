import 'package:athlete_iq/data/network/userRepository.dart';
import 'package:athlete_iq/ui/auth/providers/auth_view_model_provider.dart';
import 'package:athlete_iq/ui/info/provider/user_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../model/User.dart';

final infoViewModelProvider = ChangeNotifierProvider(
      (ref) => InfoViewModel(ref.read),
);

class InfoViewModel extends ChangeNotifier {
  final Reader _reader;
  InfoViewModel(this._reader);
  UserRepository get _repository => _reader(userRepositoryProvider);

}