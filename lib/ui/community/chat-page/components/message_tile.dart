import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MessageTile extends StatefulWidget {
  final String message;
  final String sender;
  final String date;
  final bool sentByMe;

  const MessageTile({
    super.key,
    required this.message,
    required this.sender,
    required this.date,
    required this.sentByMe,
  });

  @override
  State<MessageTile> createState() => _MessageTileState();
}

class _MessageTileState extends State<MessageTile> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: widget.sentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width *
              0.8, // 80% de la largeur de l'écran
        ),
        child: Container(
          margin: EdgeInsets.only(
            top: 4.h,
            bottom: 4.h,
            left: widget.sentByMe ? 50.w : 4.w,
            right: widget.sentByMe ? 4.w : 50.w,
          ),
          padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
          decoration: BoxDecoration(
            color: widget.sentByMe ? Colors.blue : Colors.grey[300],
            borderRadius: widget.sentByMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(15.r),
                    bottomLeft: Radius.circular(15.r),
                    bottomRight: Radius.circular(15.r),
                  )
                : BorderRadius.only(
                    topRight: Radius.circular(15.r),
                    bottomLeft: Radius.circular(15.r),
                    bottomRight: Radius.circular(15.r),
                  ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                spreadRadius: 2.r,
                blurRadius: 5.r,
                offset: Offset(0, 3.h),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                widget.sender,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: widget.sentByMe ? Colors.white : Colors.black,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                widget.message,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: widget.sentByMe ? Colors.white : Colors.black,
                ),
              ),
              SizedBox(height: 2.h),
              Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  widget.date,
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: widget.sentByMe ? Colors.white70 : Colors.grey[600],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
