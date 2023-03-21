import 'package:athlete_iq/ui/chat/chat_page.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../model/Groups.dart';
import '../providers/active_groups_provider.dart';

Widget groupTile(Groups group, BuildContext context, WidgetRef ref) {
  return ListTile(
    onTap: () {
      ref.read(activeGroupeProvider.notifier).state = group.id;
      Navigator.pushNamed(context, ChatPage.route);
    },
    leading: group.groupIcon.isNotEmpty
        ? CircleAvatar(
            backgroundImage: NetworkImage(group.groupIcon),
            radius: 22,
          )
        : null,
    title: Text(group.groupName),
    trailing: Text(
        "${group.recentMessageTime.hour.toString()}h${group.recentMessageTime.minute.toString()}"),
  );
}
