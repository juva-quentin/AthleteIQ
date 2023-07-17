import 'dart:io';

import 'package:athlete_iq/ui/info/provider/user_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../../model/User.dart';
import '../../../utils/utils.dart';
import '../info_view_model_provider.dart';

Widget buildTopInfo(double height, double width, BuildContext context) {
  return Consumer(builder: (context, ref, _) {
    final user = ref.watch(firestoreUserProvider);
    final model = ref.watch(infoViewModelProvider);
    return SizedBox(
      height: height * .22,
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(left: width * .03, right: width * .03),
            child: GestureDetector(
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
                      fit: BoxFit.cover),
                ),
                child: const Icon(
                  Icons.image_search,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                left: width * .02,
                right: width * .03,
                top: (height * .25) * .15,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Pseudo de l'utilisateur
                  Text(
                    user.when(
                      data: (user) => user.pseudo,
                      error: (Object error, StackTrace? stackTrace) => 'Error',
                      loading: () => 'Loading',
                    ),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 26,
                    ),
                  ),

                  // Objectif hebdomadaire
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Objectif hebdo: ",
                        style: TextStyle(
                          color: Color(0xFF121212),
                          fontSize: 17,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      Text(
                        "${user.when(data: (user) => user.objectif, error: (error, stackTrace) => 0.0, loading: () => 0.0).toString()}Km",
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),

                  // Total des kilomètres et jours restants
                  Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        "${user.when(data: (user) => user.totalDist, error: (error, stackTrace) => 0.0, loading: () => 0.0).toStringAsFixed(2)}Km",
                        style: const TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(width: width*.03),
                      Text(
                        "plus que ${model.nbrDays()} jours...",
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),

                  // Pourcentage d'avancement
                  LinearPercentIndicator(
                    animation: true,
                    lineHeight: height * .025,
                    animationDuration: 2500,
                    padding: EdgeInsets.zero,
                    percent: model.advencementBar(
                      user.when(
                        data: (user) => user.objectif.toInt(),
                        error: (error, stackTrace) => 0,
                        loading: () => 0,
                      ),
                      user.when(
                        data: (user) => user.totalDist.toInt(),
                        error: (error, stackTrace) => 0,
                        loading: () => 0,
                      ),
                    ),
                    barRadius: const Radius.circular(16),
                    center: Text(
                      "${(model.advencement(user.when(data: (user) => user.objectif.toInt(), error: (error, stackTrace) => 0, loading: () => 0), user.when(data: (user) => user.totalDist.toInt(), error: (error, stackTrace) => 0, loading: () => 0)) * 100).toStringAsFixed(2)}%",
                    ),
                    progressColor: Theme.of(context).primaryColor,
                    backgroundColor: Theme.of(context).highlightColor,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  });
}