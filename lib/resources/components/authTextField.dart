import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../utils/utils.dart';

class AuthTextField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final Icon prefixIcon;
  final String hintText;
  final String labelText;
  final FocusNode nextFocus;
  final TextInputType keyboardType;
  const AuthTextField(
      {Key? key, required this.controller, required this.focusNode, required this.prefixIcon, required this.keyboardType, required this.hintText, required this.labelText, required this.nextFocus})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: keyboardType,
      decoration: InputDecoration(
          hintText: hintText,
          labelText: labelText,
          prefixIcon: prefixIcon,
      ),
      onFieldSubmitted: (value) {
        Utils.fieldFocusChange(context, focusNode,
            nextFocus);
      },
    );
  }

}