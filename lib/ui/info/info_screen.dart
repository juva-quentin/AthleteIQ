import 'package:athlete_iq/ui/info/provider/user_provider.dart';
import 'package:athlete_iq/ui/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:unicons/unicons.dart';
import '../../model/User.dart';
import '../../resources/components/middleAnimatedBar.dart';
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
                SizedBox(
                  height: heigth * .22,
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            left: width * .03, right: width * .03),
                        child: Container(
                          width: width * .35,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20)),
                            image: DecorationImage(
                                image: user.when(
                                  data: (user) {
                                    return NetworkImage(user.image);
                                  },
                                  error: (error, stackTrace) =>
                                      const AssetImage(
                                          "assets/images/error.png"),
                                  loading: () => const AssetImage(
                                      "assets/gif/Loading_icon.gif"),
                                ),
                                fit: BoxFit.fitWidth),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: width * .02,
                              right: width * .03,
                              top: (heigth * .25) * .15),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              user.when(data: (User user) {
                                return Text(
                                  user.pseudo,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 26),
                                );
                              }, error: (Object error, StackTrace? stackTrace) {
                                return Text(error.toString());
                              }, loading: () {
                                return const Text('Loading');
                              }),
                              SizedBox(height: heigth * .02),
                              user.when(
                                data: (user) {
                                  return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Objectif hebdo: ",
                                            style: GoogleFonts.sen(
                                                textStyle: const TextStyle(
                                              color: Color(0xFF121212),
                                              fontSize: 17,
                                              fontWeight: FontWeight.normal,
                                            ))),
                                        Text("${user.objectif.toString()}KM",
                                            style: GoogleFonts.sen(
                                                textStyle: const TextStyle(
                                              color: Color(0xFF72B0EA),
                                              fontSize: 15,
                                              fontWeight: FontWeight.w700,
                                            )))
                                      ]);
                                },
                                error: (error, stackTrace) =>
                                    Text(error.toString()),
                                loading: () =>
                                    const CircularProgressIndicator(),
                              ),
                              user.when(
                                data: (user) {
                                  return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("${user.totalDist.toString()}KM",
                                            style: GoogleFonts.sen(
                                                textStyle: const TextStyle(
                                              color:
                                                  Color.fromARGB(255, 0, 0, 0),
                                              fontSize: 18,
                                              fontWeight: FontWeight.w700,
                                            ))),
                                        Text(
                                            "plus que ${model.nbrDays()} jours...")
                                      ]);
                                },
                                error: (error, stackTrace) =>
                                    Text(error.toString()),
                                loading: () =>
                                    const CircularProgressIndicator(),
                              ),
                              user.when(
                                data: (user) {
                                  return LinearPercentIndicator(
                                    animation: true,
                                    lineHeight: heigth * .025,
                                    animationDuration: 2500,
                                    percent: model.advencement(
                                        user.objectif.toInt(),
                                        user.totalDist.toInt()),
                                    barRadius: const Radius.circular(16),
                                    center: Text(
                                        "${((model.advencement(user.objectif.toInt(), user.totalDist.toInt())) * 100).toStringAsFixed(2)}%"),
                                    progressColor: const Color(0xFF72B0EA),
                                  );
                                },
                                error: (error, stackTrace) =>
                                    Text(error.toString()),
                                loading: () =>
                                    const CircularProgressIndicator(),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: heigth * .05,
                  child: Consumer(builder: (context, ref, child) {
                    ref.watch(provider.select((value) => value.selectedIndex));
                    return Padding(
                      padding: EdgeInsets.only(
                          right: width * .03, left: width * .03),
                      child: Row(
                        children: [
                          ...List.generate(
                            middleNav.length,
                            (index) => GestureDetector(
                              onTap: () {
                                if (middleNav[index] !=
                                    model.selectedBottomNav) {
                                  model.selectedBottomNav = middleNav[index];
                                  model.selectedIndex = index;
                                }
                              },
                              child: Padding(
                                padding: EdgeInsets.only(right: width * .02),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Opacity(
                                        opacity: middleNav[index] ==
                                                model.selectedBottomNav
                                            ? 1
                                            : 0.5,
                                        child: Text(middleNav[index])),
                                    const SizedBox(height: 3),
                                    MiddleAnimatedBar(
                                        isActive: middleNav[index] ==
                                            model.selectedBottomNav),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  }),
                ),
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

Widget _buildNameOverlay(User user) {
  return Container(
    padding: EdgeInsets.all(3),
    alignment: Alignment.centerLeft,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        CircleAvatar(
          backgroundColor: Colors.white,
          radius: 20,
          child: Image.network(user.image),
        ),
        Container(
            margin: EdgeInsets.only(left: 7),
            child: Text(user.pseudo ?? "pseudo"))
      ],
    ),
  );
}

List<String> middleNav = ["Mes courses", "Mes favoris", "Mes amis"];
