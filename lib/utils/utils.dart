import 'package:another_flushbar/flushbar.dart';
import 'package:another_flushbar/flushbar_route.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Utils {
  static toastMessage(String message) {
    Fluttertoast.showToast(msg: message);
  }

  static void flushBarErrorMessage(String message, BuildContext context) {
    showFlushbar(
        context: context,
        flushbar: Flushbar(
            forwardAnimationCurve: Curves.decelerate,
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            padding: EdgeInsets.all(10),
            message: message,
            backgroundColor: Colors.black,
            duration: const Duration(seconds: 3),
            reverseAnimationCurve: Curves.bounceOut,
            positionOffset: 20,
            borderRadius: BorderRadius.circular(20),
            flushbarPosition: FlushbarPosition.TOP,
            icon: Icon(Icons.error, size: 28, color: Colors.white))
          ..show(context));
  }

  static snackBar(String message, BuildContext context) {
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.black,
      content: Text(message),
    ));
  }
}
