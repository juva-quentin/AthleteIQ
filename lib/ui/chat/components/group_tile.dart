import 'package:flutter/material.dart';
import '../../../model/Groups.dart';

Widget groupTile(Groups group) {
  return ListTile(
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
