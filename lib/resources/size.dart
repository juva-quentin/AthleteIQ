import 'package:flutter/material.dart';

class AppSize {
  late double globalHeight;
  late double globalWidth;
  AppSize(BuildContext context){
    globalHeight = MediaQuery.of(context).size.height;
    globalWidth = MediaQuery.of(context).size.width;
  }
}
