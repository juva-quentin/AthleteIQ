import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../../model/User.dart';
import '../../../utils/utils.dart';
import '../info_view_model_provider.dart';

Widget buildTopInfo(
    double height, double width, AsyncValue<User> user, BuildContext context) {
  return SizedBox(
    height: height * .22,
    child: Row(
      children: [
        Padding(
          padding: EdgeInsets.only(left: width * .03, right: width * .03),
          child: Consumer(builder: (context, ref, child) {
            final model = ref.watch(infoViewModelProvider);
            return GestureDetector(
              onTap: () async {
                final picked =
                    await ImagePicker().pickImage(source: ImageSource.gallery);
                if (picked != null) {
                  model.file = File(picked.path);
                  try {
                    await model.updateUserImage();
                  } catch (e) {
                    Utils.flushBarErrorMessage(e.toString(), context);
                  }
                }
              },
              child: Container(
                width: width * .35,
                height: double.infinity,
                alignment: const Alignment(0.90, 0.90),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  image: DecorationImage(
                      image: user.when(
                        data: (user) {
                          return NetworkImage(user.image);
                        },
                        error: (error, stackTrace) =>
                            const AssetImage("assets/images/error.png"),
                        loading: () =>
                            const AssetImage("assets/gif/Loading_icon.gif"),
                      ),
                      fit: BoxFit.fill),
                ),
                child: const Icon(Icons.image_search, color: Colors.white,),
              ),
            );
          }),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(
                left: width * .02,
                right: width * .03,
                top: (height * .25) * .15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                user.when(data: (User user) {
                  return Text(
                    user.pseudo,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 26),
                  );
                }, error: (Object error, StackTrace? stackTrace) {
                  return Text(error.toString());
                }, loading: () {
                  return const Text('Loading');
                }),
                SizedBox(height: height * .02),
                user.when(
                  data: (user) {
                    return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Objectif hebdo: ",
                              style: GoogleFonts.sen(
                                  textStyle: const TextStyle(
                                color: Color(0xFF121212),
                                fontSize: 17,
                                fontWeight: FontWeight.normal,
                              ))),
                          Text("${user.objectif.toString()}Km",
                              style: GoogleFonts.sen(
                                  textStyle: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              )))
                        ]);
                  },
                  error: (error, stackTrace) {
                    print(error.toString());
                    return Text(error.toString());
                  },
                  loading: () => const CircularProgressIndicator(),
                ),
                user.when(
                  data: (user) {
                    return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("${user.totalDist.toStringAsFixed(2)}Km",
                              style: GoogleFonts.sen(
                                  textStyle: const TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ))),
                          Consumer(builder: (context, ref, child) {
                            final model = ref.watch(infoViewModelProvider);
                            return Text("plus que ${model.nbrDays()} jours...");
                          })
                        ]);
                  },
                  error: (error, stackTrace) => Text(error.toString()),
                  loading: () => const CircularProgressIndicator(),
                ),
                Consumer(builder: (context, ref, child) {
                  final model = ref.watch(infoViewModelProvider);
                  return user.when(
                    data: (user) {
                      return LinearPercentIndicator(
                        animation: true,
                        lineHeight: height * .025,
                        animationDuration: 2500,
                        padding: EdgeInsets.zero,
                        percent: model.advencement(
                            user.objectif.toInt(), user.totalDist.toInt()),
                        barRadius: const Radius.circular(16),
                        center: Text(
                            "${((model.advencement(user.objectif.toInt(), user.totalDist.toInt())) * 100).toStringAsFixed(2)}%"),
                        progressColor: Theme.of(context).primaryColor,
                        backgroundColor: Theme.of(context).highlightColor,
                      );
                    },
                    error: (error, stackTrace) => Text(error.toString()),
                    loading: () => const CircularProgressIndicator(),
                  );
                })
              ],
            ),
          ),
        )
      ],
    ),
  );
}
