import 'package:athlete_iq/ui/chat/chat_page.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../model/Groups.dart';
import '../providers/active_groups_provider.dart';

Widget groupTile(Groups group, BuildContext context, WidgetRef ref) {
  return Padding(
    padding: const EdgeInsets.only(top: 10.0),
    child: Material(
      elevation: 3.0,
      shadowColor: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        onTap: () {
          ref.read(activeGroupeProvider.notifier).state = group.id;
          Navigator.pushNamed(context, ChatPage.route);
        },
        leading: group.groupIcon.isNotEmpty
            ? CircleAvatar(
                backgroundImage: NetworkImage(group.groupIcon),
                radius: 33,
              )
            : null,
        title: Text(group.groupName, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500)),
        subtitle: Text(group.recentMessage.length >= 30 ? group.recentMessage.substring(0, 30) : group.recentMessage, style: TextStyle(color: Colors.grey),),
        trailing: Text(
            "${group.recentMessageTime.hour.toString().padLeft(2,'0')}h${group.recentMessageTime.minute.toString().padLeft(2,'0')}"),
      ),
    ),
  );
}
