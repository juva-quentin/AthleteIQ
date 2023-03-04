import 'package:athlete_iq/ui/info/provider/user_provider.dart';
import 'package:athlete_iq/ui/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unicons/unicons.dart';
import 'components/TopInfo.dart';
import 'components/middleNavComponent.dart';
import 'info_view_model_provider.dart';

class InfoScreen extends ConsumerWidget {
  const InfoScreen({Key, key}) : super(key: key);

  static const route = "/info";
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final model = ref.read(infoViewModelProvider);
    final provider = infoViewModelProvider;
    final user = ref.watch(firestoreUserProvider);
    final heigth = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
          maintainBottomViewPadding: true,
          child: Stack(children: [
            PositionedDirectional(
              end: width * .02,
              bottom: heigth * .87,
              child: IconButton(
                icon: Icon(
                  UniconsLine.setting,
                  size: width * .1,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, SettingsScreen.route);
                },
              ),
            ),
            Column(
              children: [
                buildTopInfo(heigth, width, user, model),
                buildMiddleNavInfo(heigth, provider, width, model),
                Expanded(
                  child: Consumer(builder: (context, ref, child) {
                    ref.watch(provider.select((value) => value.selectedIndex));
                    return model.widgetOptions.elementAt(model.selectedIndex);
                  }),
                ),
              ],
            ),
          ])),
    );
  }
}

List<String> middleNav = ["Mes courses", "Mes favoris", "Mes amis"];