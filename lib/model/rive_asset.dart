import 'package:rive/rive.dart';

class RiveAsset {
  final String artboard, stateMachineName, title, src;
  late SMIBool? input;

  RiveAsset(this.src,{required this.artboard, required this.stateMachineName, required this.title, this.input});

  set setInput(SMIBool status){
    input = status;
  }

}

List<RiveAsset> bottomNavs = [
  RiveAsset("assets/RiveAssets/icons.riv", artboard: "CHAT", stateMachineName: "CHAT_Interactivity", title: "Communauté"),
  RiveAsset("assets/RiveAssets/icons.riv", artboard: "HOME", stateMachineName: "HOME_interactivity", title: "Map"),
  RiveAsset("assets/RiveAssets/icons.riv", artboard: "USER", stateMachineName: "USER_Interactivity", title: "Truc"),
];