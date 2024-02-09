import 'package:athlete_iq/ui/community/chat-page/chat_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../model/Groups.dart';

Widget groupTile(Groups group, BuildContext context, WidgetRef ref) {
  return Padding(
    padding: EdgeInsets.only(top: 10.h),
    child: Material(
      elevation: 3.0,
      shadowColor: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.r),
      ),
      child: ListTile(
        onTap: () {
          Navigator.pushNamed(context, ChatPage.route, arguments: group.id);
        },
        leading: group.groupIcon.isNotEmpty
            ? CircleAvatar(
                backgroundImage: NetworkImage(group.groupIcon),
                radius: 33.r,
              )
            : null,
        title: Text(group.groupName,
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500)),
        subtitle: Text(
          group.recentMessage.length >= 30
              ? group.recentMessage.substring(0, 30)
              : group.recentMessage,
          style: TextStyle(
            color: Colors.grey,
            fontSize: 14.sp,
          ),
        ),
        trailing: Text(
          "${group.recentMessageTime.hour.toString().padLeft(2, '0')}h${group.recentMessageTime.minute.toString().padLeft(2, '0')}",
          style: TextStyle(
            fontSize: 9.sp,
          ),
        ),
      ),
    ),
  );
}
