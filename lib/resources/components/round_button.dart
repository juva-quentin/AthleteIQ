import 'package:athlete_iq/data/riverpods/auth_pod.dart';
import 'package:athlete_iq/resources/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RoundButton extends StatelessWidget {
  final String title;
  final VoidCallback onPress;

  const RoundButton(
      {Key? key,
      required this.title,
      required this.onPress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, _) {
      var auth = ref.watch(authProvider);
      return InkWell(
          onTap: onPress,
          child: Container(
              height: 40,
              width: 200,
              decoration: BoxDecoration(
                  color: Theme.of(context).buttonTheme.colorScheme!.primary,
                  borderRadius: BorderRadius.circular(10)),
              child: Center(
                  child: auth.isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : Text(
                          title,
                          style: TextStyle(color: Theme.of(context).colorScheme.background),
                        ))),
        );
      }
    );
  }
}
