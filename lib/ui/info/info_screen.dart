import 'package:athlete_iq/model/User.dart';
import 'package:athlete_iq/ui/info/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import '../../utils/routes/root.dart';
import '../auth/providers/auth_view_model_provider.dart';
import 'components/topComponent.dart';
import 'info_view_model_provider.dart';

class InfoScreen extends ConsumerWidget {
  const InfoScreen({Key, key}) : super(key: key);

  static const route = "/info";
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final model = ref.read(infoViewModelProvider);
    final user = ref.watch(firestoreUserProvider);
    final heigth = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
          maintainBottomViewPadding: true,
          child: Column(
            children: [
              SizedBox(
                height: heigth * .25,
                child: Row(
                  children: [
                    Container(
                      width: width * .35,
                      decoration: BoxDecoration(color: Colors.blue),
                      child: Column(children: [],),
                    ),
                    Expanded(
                        child: Container(
                      decoration: BoxDecoration(color: Colors.green),
                    ))
                  ],
                ),
              ),
              SizedBox(
                  height: heigth * .05,
                  child: Row(
                    children: [],
                  )),
              Expanded(
                  child: Container(
                decoration: BoxDecoration(color: Colors.amberAccent),
              ))

              // Positioned(
              //     child: user.when(
              //         data: (user){ return _buildNameOverlay(user);},
              //         error: (error, stackTrace) => Text(error.toString()),
              //         loading: () => const CircularProgressIndicator())
              // ),
              // Positioned(child:user.when(
              //     data: (user){ return _buildObjectifOverlay(context, user);},
              //     error: (error, stackTrace) => Text(error.toString()),
              //     loading: () => const CircularProgressIndicator()))
            ],
          )),
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

Widget _buildObjectifOverlay(BuildContext context, User user) {
  int nbrDays() {
    var date = DateFormat.EEEE().format(DateTime.now());
    List<String> days = [
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday",
      'Sunday'
    ];
    var index1 = days.indexWhere((element) => element == date);
    if (index1 >= 0) {
      return 7 - (index1 + 1);
    }
    return 0;
  }

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
              style: GoogleFonts.sen(
                  textStyle: TextStyle(
                color: Color(0xFF121212),
                fontSize: 17,
                fontWeight: FontWeight.normal,
              ))),
          Text("${user.objectif} KM",
              style: GoogleFonts.sen(
                  textStyle: TextStyle(
                color: Color(0xFF72B0EA),
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ))),
        ]),
        Spacer(),
        Container(
          child: Column(children: [
            Row(
              children: [
                Text("${user.totalDist.toStringAsFixed(2)}KM",
                    style: GoogleFonts.sen(
                        textStyle: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ))),
                Spacer(),
                Text("Plus que ${nbrDays()} jours..."),
              ],
            ),
            LinearPercentIndicator(
              animation: true,
              lineHeight: 25.0,
              animationDuration: 2500,
              percent: _advencement(user.objectif.toInt(), user.totalDist),
              center: Text(
                  ((_advencement(user.objectif.toInt(), user.totalDist)) * 100)
                          .toStringAsFixed(2) +
                      "%"),
              progressColor: Color(0xFF72B0EA),
            ),
          ]),
        )
      ]));
}
