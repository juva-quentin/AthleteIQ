import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class GroupTile extends ConsumerWidget {
  final String userName;
  final String groupId;
  final String groupName;

  GroupTile({Key, key, required this.userName, required this.groupId, required this.groupName,}) : super(key: key);


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      title: Text(groupName),
      subtitle: Text(userName),
    );
  }
}