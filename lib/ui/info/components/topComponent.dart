import 'package:flutter/cupertino.dart';

Widget buildTopOverlay(BuildContext context) {
  return Container(
    height: MediaQuery.of(context).size.height * 0.22,
    decoration: const BoxDecoration(
      color: Color(0xFF72B0EA),
      borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(35), bottomRight: Radius.circular(35)),
    ),
  );
}