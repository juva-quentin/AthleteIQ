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
    final model = ref.watch(infoViewModelProvider);
    final user = ref.watch(firestoreUserProvider);
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        maintainBottomViewPadding: true,
        child: Stack(
          children: [
            PositionedDirectional(
              end: width * .02,
              bottom: height * .87,
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
                buildTopInfo(height, width, user, context),
                buildMiddleNavInfo(height, width),
                Expanded(
                    child: model.widgetOptions.elementAt(model.selectedIndex)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

List<String> middleNav = ["Mes courses", "Mes favoris", "Mes amis"];
