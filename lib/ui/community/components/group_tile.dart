import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../model/Groups.dart';
import '../chat-page/chat_page.dart';

Widget groupTile(Groups group, BuildContext context, WidgetRef ref) {
  bool isUnread = true; // Placeholder for unread message condition

  return InkWell(
    onTap: () {
      Navigator.pushNamed(context, ChatPage.route, arguments: group.id);
    },
    child: Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          SizedBox(width: 16.w),
          Container(
            padding: EdgeInsets.all(2.w), // Added padding for the border
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 4,
                ),
              ],
              border: isUnread ? Border.all(
                color: Theme.of(context).primaryColor,
                width: 2.w,
              ) : null,
            ),
            child: CircleAvatar(
              backgroundImage: NetworkImage(group.groupIcon),
              radius: 25.r,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          group.groupName,
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (isUnread)
                        Container(
                          height: 10.r,
                          width: 10.r,
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    group.recentMessage.length > 30
                        ? '${group.recentMessage.substring(0, 27)}...'
                        : group.recentMessage,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12.sp,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: Text(
              "${group.recentMessageTime.hour.toString().padLeft(2, '0')}:${group.recentMessageTime.minute.toString().padLeft(2, '0')}",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 11.sp,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
