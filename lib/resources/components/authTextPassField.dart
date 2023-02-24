import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../utils/utils.dart';

class AuthTextPassField extends StatelessWidget {
  final TextEditingController controller;
  final ValueNotifier<dynamic> obscureText;
  final FocusNode focusNode;
  final Widget suffixIcon;
  final Icon prefixIcon;
  final String hintText;
  final String labelText;
  final FocusNode nextFocus;
  final TextInputType keyboardType;
  const AuthTextPassField(
      {Key? key, required this.controller, required this.obscureText, required this.focusNode, required this.suffixIcon, required this.prefixIcon, required this.keyboardType, required this.hintText, required this.labelText, required this.nextFocus})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
   return TextFormField(
     controller: controller,
     obscureText: obscureText.value,
     focusNode: focusNode,
     keyboardType: keyboardType,
     decoration: InputDecoration(
       hintText: hintText,
       labelText: labelText,
       prefixIcon: prefixIcon,
       suffixIcon: suffixIcon
     ),
     onFieldSubmitted: (value) {
       Utils.fieldFocusChange(context, focusNode,
           nextFocus);
     },
   );
  }

}