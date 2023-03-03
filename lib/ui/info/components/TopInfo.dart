import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../../model/User.dart';
import '../info_view_model_provider.dart';

Widget buildTopInfo(double heigth, double width, AsyncValue<User> user, InfoViewModel model) {
  return SizedBox(
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
  );
}