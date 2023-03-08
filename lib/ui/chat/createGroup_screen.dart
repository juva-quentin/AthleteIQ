import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CreateGroupScreen extends ConsumerWidget {
  CreateGroupScreen({Key, key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(child: Text("Créer un groupe"));
  }

}