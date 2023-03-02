import 'package:athlete_iq/resources/components/animatedBar.dart';
import 'package:athlete_iq/resources/size.dart';
import 'package:athlete_iq/ui/home/home_view_model_provider.dart';
import 'package:athlete_iq/utils/rive_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rive/rive.dart';
import '../model/rive_asset.dart';
import 'app_view_model_provider.dart';


class App extends ConsumerWidget {
  const App({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppSize appSize = AppSize(context);
    final width = appSize.globalWidth;
    final height = appSize.globalHeight;
    final appProvider = appViewModelProvider;
    final homeProvider = homeViewModelProvider;
    final appModel = ref.read(appViewModelProvider);
    final homeModel = ref.read(homeViewModelProvider);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: true,
      body: Consumer(
          builder: (context, ref, child) {
            ref.watch(
                appProvider.select((value) => value.selectedIndex));
            return appModel.widgetOptions.elementAt(appModel.selectedIndex);
        }
      ),
      bottomNavigationBar: Consumer(builder: (context, ref, child) {
          return SafeArea(
              child: Consumer(
                  builder: (context, ref, child) {
                    ref.watch(
                        appProvider.select((value) => value.selectedIndex));
                    ref.watch(
                        homeProvider.select((value) => value.courseStart));
                  return AnimatedOpacity(
                    opacity: !homeModel.courseStart? 1.0 : 0,
                    duration: const Duration(seconds: 1),
                    child: !homeModel.courseStart? Container(
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
                              if (bottomNavs[index] != appModel.selectedBottomNav) {
                                appModel.selectedBottomNav = bottomNavs[index];
                                appModel.selectedIndex = index;
                              }
                              Future.delayed(const Duration(seconds: 1), (){
                                bottomNavs[index].input!.change(false);
                              });
                            },
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                AnimatedBar(isActive: bottomNavs[index] == appModel.selectedBottomNav),
                                SizedBox(
                                  height: 36,
                                  width: 36,
                                  child: Opacity(
                                    opacity: bottomNavs[index] == appModel.selectedBottomNav ? 1 : 0.5,
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
                  );
                }
              ),
            );
        }
      )
    );
  }
}