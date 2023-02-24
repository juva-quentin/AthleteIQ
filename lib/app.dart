import 'package:athlete_iq/resources/components/animatedBar.dart';
import 'package:athlete_iq/utils/rive_utils.dart';
import 'package:athlete_iq/view/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

import 'model/rive_asset.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  int _selectedIndex = 1;
  RiveAsset selectedBottomNav = bottomNavs[1];
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 1: Business',
      style: optionStyle,
    ),
    HomeScreen(),
    Text(
      'Index 2: School',
      style: optionStyle,
    ),
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: true,
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: SafeArea(
        child : Container(
          padding: const EdgeInsets.only(bottom: 12, top: 12, left: 20, right: 20),
          margin: const EdgeInsets.symmetric(horizontal: 24),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.8),
            borderRadius: const BorderRadius.all(Radius.circular(24))
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ...List.generate(bottomNavs.length, (index) =>   GestureDetector(
                onTap: (){
                  bottomNavs[index].input!.change(true);
                  if (bottomNavs[index] != selectedBottomNav) {
                    setState(() {
                      selectedBottomNav = bottomNavs[index];
                      _selectedIndex = index;
                    });
                  }
                  Future.delayed(const Duration(seconds: 1), (){
                    bottomNavs[index].input!.change(false);
                  });
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedBar(isActive: bottomNavs[index] == selectedBottomNav),
                    SizedBox(
                      height: 36,
                      width: 36,
                      child: Opacity(
                        opacity: bottomNavs[index] == selectedBottomNav ? 1 : 0.5,
                        child: RiveAnimation.asset(
                          bottomNavs[1].src,
                          artboard: bottomNavs[index].artboard,
                          onInit: (artboard){
                            StateMachineController controller =
                              RiveUtils.getRiveController(artboard,
                                  stateMachineName:
                                      bottomNavs[index].stateMachineName);
                            bottomNavs[index].input = controller.findSMI("active") as SMIBool;
                          }
                        ),
                      )
                    ),
                  ],
                ),
              ))
            ],
          ),
        )
      )
    );
  }
}