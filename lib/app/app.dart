import 'package:athlete_iq/resources/components/animatedBar.dart';
import 'package:athlete_iq/ui/home/home_view_model_provider.dart';
import 'package:athlete_iq/utils/rive_utils.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:rive/rive.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // Assurez-vous que ceci est ajouté
import '../model/rive_asset.dart';
import 'app_view_model_provider.dart';

class App extends ConsumerWidget {
  const App({Key? key}) : super(key: key);
  static const String route = "/home";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appModel = ref.watch(appViewModelProvider);
    final homeModel = ref.watch(homeViewModelProvider);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: true,
      body: appModel.widgetOptions.elementAt(appModel.selectedIndex),
      bottomNavigationBar: SafeArea(
        bottom: false,
        child: AnimatedOpacity(
          opacity: !homeModel.courseStart ? 1.0 : 0,
          duration: const Duration(seconds: 1),
          child: !homeModel.courseStart
              ? Container(
                  padding: EdgeInsets.only(
                    bottom: 5.h,
                    top: 5.h,
                    left: 20.w,
                    right: 20.w,
                  ),
                  margin: EdgeInsets.symmetric(
                    horizontal: 18.w,
                    vertical: 24.h,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.9),
                    borderRadius: BorderRadius.all(Radius.circular(24.r)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ...List.generate(
                        bottomNavs.length,
                        (index) => GestureDetector(
                          onTap: () {
                            bottomNavs[index].input!.change(true);
                            if (bottomNavs[index] !=
                                appModel.selectedBottomNav) {
                              appModel.selectedBottomNav = bottomNavs[index];
                              appModel.selectedIndex = index;
                            }
                            Future.delayed(const Duration(seconds: 1), () {
                              bottomNavs[index].input!.change(false);
                            });
                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              AnimatedBar(
                                  isActive: bottomNavs[index] ==
                                      appModel.selectedBottomNav),
                              SizedBox(
                                height: 40.h, // Modifié
                                width: 40.w, // Modifié
                                child: Opacity(
                                  opacity: bottomNavs[index] ==
                                          appModel.selectedBottomNav
                                      ? 1
                                      : 0.5,
                                  child: RiveAnimation.asset(
                                    bottomNavs[1].src,
                                    artboard: bottomNavs[index].artboard,
                                    onInit: (artboard) {
                                      StateMachineController controller =
                                          RiveUtils.getRiveController(
                                        artboard,
                                        stateMachineName:
                                            bottomNavs[index].stateMachineName,
                                      );
                                      bottomNavs[index].input = controller
                                          .findSMI("active") as SMIBool;
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : const SizedBox(),
        ),
      ),
    );
  }
}
