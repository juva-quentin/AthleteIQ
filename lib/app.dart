import 'package:athlete_iq/resources/components/animatedBar.dart';
import 'package:athlete_iq/resources/size.dart';
import 'package:athlete_iq/utils/rive_utils.dart';
import 'package:athlete_iq/view/home_screen.dart';
import 'package:athlete_iq/view/info_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rive/rive.dart';

import 'data/riverpods/variable_pod.dart';
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
    InfoScreen()
  ];


  @override
  Widget build(BuildContext context) {
    final AppSize appSize = AppSize(context);
    final width = appSize.globalWidth;
    final height = appSize.globalHeight;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: true,
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: Consumer(builder: (context, ref, _) {
        var visible = ref.watch(courseStart);
          return SafeArea(
              child: AnimatedOpacity(
                opacity: !visible? 1.0 : 0,
                duration: const Duration(seconds: 1),
                child: !visible? Container(
                  padding: const EdgeInsets.only(bottom: 12, top: 12, left: 20, right: 20),
                  margin: EdgeInsets.symmetric(horizontal: width*.06, vertical: height > 800? 0 : height*.01),
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
                ) : SizedBox(),
              ),
            );
        }
      )
    );
  }
}