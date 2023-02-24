import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:introduction_screen/introduction_screen.dart';
import '../data/riverpods/hive_pod.dart';
import '../utils/routes/routes_name.dart';

class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hive = ref.watch(hiveProvider);

    return Scaffold(
      body: IntroductionScreen(
        pages: [
          PageViewModel(
            title: 'Title of 1st Page',
            body: 'Body of 1st Page',
          ),
          PageViewModel(
            title: 'Title of 2nd Page',
            body: 'Body of 2nd Page',
          ),
          PageViewModel(
            title: 'Title of 3rd Page',
            body: 'Body of 3rd Page',
          ),
          PageViewModel(
            title: 'Title of 4th Page',
            body: 'Body of 4th Page',
          ),
        ],
        onDone: () {
          hive.storeHiveData('firstTime', false);
          Navigator.pushNamed(context, RoutesName.app);
        },
        skip: const Icon(Icons.skip_next),
        next: const Icon(Icons.forward),
        done: const Text("Done", style: TextStyle(fontWeight: FontWeight.w600)),
        dotsDecorator: DotsDecorator(
            size: const Size.square(10.0),
            activeSize: const Size(20.0, 10.0),
            activeColor: Colors.blue,
            color: Colors.black26,
            spacing: const EdgeInsets.symmetric(horizontal: 3.0),
            activeShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0))),
      ),
    );
  }
}