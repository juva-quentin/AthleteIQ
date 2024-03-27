import 'dart:io';

import 'package:athlete_iq/ui/info/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../../utils/utils.dart';
import '../info_view_model_provider.dart';

Widget buildTopInfo(BuildContext context) {
  return Consumer(builder: (context, ref, _) {
    final user = ref.watch(firestoreUserProvider);
    final model = ref.watch(infoViewModelProvider);
    return SizedBox(
      height: 0.22.sh,
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 0.03.sw),
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
                width: 0.35.sw,
                alignment: const Alignment(0.90, 0.90),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.all(Radius.circular(20.r)),
                  image: DecorationImage(
                    image: user.when(
                      data: (user) => NetworkImage(user.image),
                      error: (error, stackTrace) =>
                          const AssetImage("assets/images/error.png"),
                      loading: () => const AssetImage("assets/gif/Loading_icon.gif"),
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
                child: const Icon(Icons.image_search, color: Colors.white),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                  left: 0.02.sw, right: 0.03.sw, top: 0.0375.sh),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.when(
                      data: (user) => user.pseudo,
                      error: (Object error, StackTrace? stackTrace) => 'Error',
                      loading: () => 'Loading',
                    ),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 23.sp,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Objectif hebdo: ",
                        style: TextStyle(
                          color: const Color(0xFF121212),
                          fontSize: 15.sp,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      Text(
                        "${user.when(data: (user) => user.objectif, error: (error, stackTrace) => 0.0, loading: () => 0.0).toString()}Km",
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        "${user.when(data: (user) => user.totalDist, error: (error, stackTrace) => 0.0, loading: () => 0.0).toStringAsFixed(2)}Km",
                        style: TextStyle(
                          color: const Color.fromARGB(255, 0, 0, 0),
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(width: 0.03.sw),
                      Text(
                        "plus que ${model.nbrDays()} jours...",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 14.sp), // Adjust for responsiveness
                      ),
                    ],
                  ),
                  LinearPercentIndicator(
                    animation: true,
                    lineHeight: 0.025.sh,
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
                    barRadius: const Radius.circular(9),
                    center: Text(
                      "${(model.advencement(user.when(data: (user) => user.objectif.toInt(), error: (error, stackTrace) => 0, loading: () => 0), user.when(data: (user) => user.totalDist.toInt(), error: (error, stackTrace) => 0, loading: () => 0)) * 100).toStringAsFixed(2)}%",
                      style: TextStyle(
                        color: Colors.white,
                          fontSize: 14.sp), // Adjust for responsiveness
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
