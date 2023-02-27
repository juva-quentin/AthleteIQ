import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import '../utils/routes/root.dart';
import 'auth/providers/auth_view_model_provider.dart';

class InfoScreen extends ConsumerStatefulWidget {
  const InfoScreen({Key? key}) : super(key: key);

  @override
  _InfoScreenState createState() => _InfoScreenState();
}

class _InfoScreenState extends ConsumerState<InfoScreen> {
  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    final top = MediaQuery.of(context).size.height * 0.22 -
        MediaQuery.of(context).size.height * 0.13 / 2;
    return Stack(clipBehavior: Clip.none, alignment: Alignment.center, children: [
      _buildTopOverlay(context),
      Positioned(
        top: MediaQuery.of(context).size.height * 0.05,
        right: MediaQuery.of(context).size.height * 0.01,
        child: IconButton(
            icon: Icon(
              Icons.logout_outlined,
              color: Color.fromARGB(255, 255, 255, 255),
              size: 35,
            ),
            onPressed: () async {
              await ref.read(authViewModelProvider).logout();
              Navigator.pushReplacementNamed(context, Root.route);
            }),
      ),
      Positioned(
          left: MediaQuery.of(context).size.width * 0.10,
          top: top - MediaQuery.of(context).size.height * 0.15 / 2.5,
          child: _buildNameOverlay()),
      Positioned(top: top, child: _buildObjectifOverlay(context))
    ]);
  }
}

Widget _buildTopOverlay(BuildContext context) {
  return Container(
    height: MediaQuery.of(context).size.height * 0.22,
    decoration: BoxDecoration(
      color: Color(0xFF72B0EA),
      borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(35), bottomRight: Radius.circular(35)),
    ),
  );
}

Widget _buildNameOverlay() {

          return Container(
            padding: EdgeInsets.all(3),
            alignment: Alignment.centerLeft,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 20,
                  child: Icon(Icons.account_circle_rounded, size: 40),
                ),
                Container(
                    margin: EdgeInsets.only(left: 7),
                    child: Text("pseudo"))
              ],
            ),
          );

}

Widget _buildObjectifOverlay(BuildContext context) {
  // ignore: missing_return

  double _advencement(int objectif, advencement) {
    double result = ((advencement * 100) / objectif) / 100;
    if (objectif == 0) {
      return 0.0;
    }
    if (result <= 0) {
      return 0.0;
    } else if (result > 1) {
      return 1.0;
    } else {
      return result;
    }
  }

  return Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.13,
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 255, 255, 255),
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Column(children: [
                Row(children: [
                  Text("Objectif de la semaine: ",
                      ),
                  Text("objectif KM",
                      ),
                ]),
                Spacer(),
                Container(
                  child: Column(children: [
                    Row(
                      children: [
                        Text("tdp KM",),
                        Spacer(),
                        Text("Plus que ? jours..."),
                      ],
                    ),
                    LinearPercentIndicator(
                      animation: true,
                      lineHeight: 25.0,
                      animationDuration: 2500,
                      percent: 1,
                      center: Text(
                          "100 %"),
                      progressColor: Color(0xFF72B0EA),
                    ),
                  ]),
                )
              ]));
}