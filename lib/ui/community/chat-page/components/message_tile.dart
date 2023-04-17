import 'package:flutter/material.dart';

class MessageTile extends StatefulWidget {
  final String message;
  final String sender;
  final String date;
  final bool sentByMe;

  const MessageTile(
      {Key? key,
        required this.message,
        required this.sender,
        required this.date,
        required this.sentByMe})
      : super(key: key);

  @override
  State<MessageTile> createState() => _MessageTileState();
}

class _MessageTileState extends State<MessageTile> {
  @override
  Widget build(BuildContext context) {
    // return Container(
    //   padding: EdgeInsets.only(
    //       top: 4,
    //       bottom: 4,
    //       left: widget.sentByMe ? 0 : 24,
    //       right: widget.sentByMe ? 24 : 0),
    //   alignment: widget.sentByMe ? Alignment.centerRight : Alignment.centerLeft,
    //   child: Container(
    //     margin: widget.sentByMe
    //         ? const EdgeInsets.only(left: 30)
    //         : const EdgeInsets.only(right: 30),
    //     padding:
    //     const EdgeInsets.only(top: 17, bottom: 17, left: 20, right: 20),
    //     decoration: BoxDecoration(
    //         borderRadius: widget.sentByMe
    //             ? const BorderRadius.only(
    //           topLeft: Radius.circular(20),
    //           topRight: Radius.circular(20),
    //           bottomLeft: Radius.circular(20),
    //         )
    //             : const BorderRadius.only(
    //           topLeft: Radius.circular(20),
    //           topRight: Radius.circular(20),
    //           bottomRight: Radius.circular(20),
    //         ),
    //         color: widget.sentByMe
    //             ? Theme.of(context).primaryColor
    //             : Colors.grey),
    //     child: Column(
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: [
    //         Row(
    //           children: [
    //             Text(
    //               widget.sender.toUpperCase(),
    //               textAlign: TextAlign.start,
    //               style: const TextStyle(
    //                   fontSize: 13,
    //                   fontWeight: FontWeight.bold,
    //                   color: Colors.white,
    //                   letterSpacing: -0.5),
    //             ),
    //             Text(
    //               widget.date,
    //               textAlign: TextAlign.start,
    //               style: const TextStyle(
    //                   fontSize: 13,
    //                   fontWeight: FontWeight.bold,
    //                   color: Colors.white,
    //                   letterSpacing: -0.5),
    //             ),
    //           ],
    //         ),
    //         const SizedBox(
    //           height: 8,
    //         ),
    //         Text(widget.message,
    //             textAlign: TextAlign.start,
    //             style: const TextStyle(fontSize: 16, color: Colors.white))
    //       ],
    //     ),
    //   ),
    // );
    // final messageBubble = Container(
    //   padding: EdgeInsets.all(10),
    //   margin: widget.sentByMe
    //       ? EdgeInsets.only(
    //     top: 8,
    //     bottom: 8,
    //     left: 80,
    //   )
    //       : EdgeInsets.only(
    //     top: 8,
    //     bottom: 8,
    //     right: 80,
    //   ),
    //   decoration: BoxDecoration(
    //     color: widget.sentByMe ? Colors.grey[300] : Colors.blue[400],
    //     borderRadius: BorderRadius.only(
    //       topLeft: Radius.circular(20),
    //       topRight: Radius.circular(20),
    //       bottomLeft: widget.sentByMe ? Radius.circular(20) : Radius.circular(0),
    //       bottomRight: widget.sentByMe ? Radius.circular(0) : Radius.circular(20),
    //     ),
    //   ),
    //   child: Column(
    //     crossAxisAlignment:
    //     widget.sentByMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
    //     children: [
    //       Text(
    //         widget.sender,
    //         style: TextStyle(
    //           fontWeight: FontWeight.bold,
    //           fontSize: 12,
    //           color: widget.sentByMe ? Colors.black54 : Colors.blue[900],
    //         ),
    //       ),
    //       SizedBox(height: 2),
    //       Text(
    //         widget.message,
    //         style: TextStyle(fontSize: 16),
    //       ),
    //       SizedBox(height: 2),
    //       Text(
    //         widget.date,
    //         style: TextStyle(
    //           fontSize: 10,
    //           color: widget.sentByMe ? Colors.black45 : Colors.blue[900],
    //         ),
    //       ),
    //     ],
    //   ),
    // );
    //
    // return Row(
    //   mainAxisAlignment:
    //   widget.sentByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
    //   children: [
    //     Flexible(
    //       child: messageBubble,
    //     ),
    //   ],
    // );
    return Container(
      margin: widget.sentByMe
          ? const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 80.0)
          : const EdgeInsets.only(top: 8.0, bottom: 8.0, right: 80.0),
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
      decoration: BoxDecoration(
        color: widget.sentByMe ? Colors.blue : Colors.grey[300],
        borderRadius: widget.sentByMe
            ? const BorderRadius.only(
          topLeft: Radius.circular(30.0),
          bottomLeft: Radius.circular(30.0),
          bottomRight: Radius.circular(30.0),
        )
            : const BorderRadius.only(
          topRight: Radius.circular(30.0),
          bottomLeft: Radius.circular(30.0),
          bottomRight: Radius.circular(30.0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            widget.sender,
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: widget.sentByMe ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 5.0),
          Text(
            widget.message,
            style: TextStyle(
              fontSize: 16.0,
              color: widget.sentByMe ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 5.0),
          Text(
            widget.date,
            style: TextStyle(
              fontSize: 12.0,
              color: widget.sentByMe ? Colors.white70 : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

}