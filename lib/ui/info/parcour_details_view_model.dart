import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final parcourDetailsViewModel = ChangeNotifierProvider.autoDispose<ParcourDetailsViewModel>(
      (ref) => ParcourDetailsViewModel(ref.read),
);

class ParcourDetailsViewModel extends ChangeNotifier {
  final Reader _reader;
  ParcourDetailsViewModel(this._reader);
}