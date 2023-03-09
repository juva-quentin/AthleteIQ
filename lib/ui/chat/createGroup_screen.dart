import 'package:athlete_iq/ui/chat/providers/groups_view_model_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../model/User.dart';
import '../info/provider/user_provider.dart';

class CreateGroupScreen extends ConsumerWidget {
  CreateGroupScreen({Key, key}) : super(key: key);


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = groupsViewModelProvider;
    final model = ref.read(provider);
    final user = ref.watch(firestoreUserProvider);
    return SafeArea(child: AlertDialog(
      title: const Text("Créer un groupe", textAlign: TextAlign.start),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [user.when(data: (User user) { return TextField(
          onChanged: (v) => model.groupName = v,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).primaryColor
              ),
            borderRadius: BorderRadius.circular(20)),
              errorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                      color: Colors.red
                  ),
                  borderRadius: BorderRadius.circular(20)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Theme.of(context).primaryColor
                  ),
                  borderRadius: BorderRadius.circular(20))
          ),
        );}, error: (Object error, StackTrace? stackTrace) { return Text(error.toString()); }, loading: () { return const Text('Loading'); })],
      ),
      actions: [
        ElevatedButton(onPressed: () {
          Navigator.of(context).pop();
        }, style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).primaryColor), child: const Text("Annuler", style: TextStyle(color: Colors.white),),),
        ElevatedButton(onPressed: () async {
          if (model.groupName.isNotEmpty) {
            await model.createGroup();
            Navigator.of(context).pop();
          }
        }, style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).primaryColor), child: const Text("Créer" ,style: TextStyle(color: Colors.white)),)
      ],
    ));
  }

}