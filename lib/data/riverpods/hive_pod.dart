import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import 'auth_pod.dart';

class HiveProvider extends ChangeNotifier {

  var _value;
  get value => _value;
  final String boxName = "Box";

  getHiveData(String key) async {
    var box = await Hive.openBox(boxName);
    return box.get(key);
  }


  storeHiveData(String key, value) {
    var box = Hive.box(boxName);
    box.put(key, value);
  }
}
final hiveProvider =
ChangeNotifierProvider<HiveProvider>((ref)=> HiveProvider());