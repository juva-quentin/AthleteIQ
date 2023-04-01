import 'package:athlete_iq/ui/auth/login_screen.dart';
import 'package:athlete_iq/ui/home/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unicons/unicons.dart';

import '../app/app.dart';
import '../utils/routes/root.dart';
import 'auth/providers/auth_view_model_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({Key, key}) : super(key: key);

  static const route = "/settings";
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authViewModelProvider);
    final height = MediaQuery.of(context).size.height;

    final width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: const Text(
            "Paramètres",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
          ),
          leading: IconButton(
            icon: Icon(UniconsLine.arrow_left, size: width * .1),
            onPressed: () =>  Navigator.pushReplacementNamed(
                context, App.route)
          ),
          actions: [
            IconButton(
                onPressed: () async {
                  try {
                    await auth.logout();
                    Navigator.pushNamedAndRemoveUntil(
                        context, LoginScreen.route, (Route<dynamic> route) => false);
                  } catch (e) {
                    print(e);
                  }
                },
                icon: Icon(UniconsLine.exit, size: width * .1)),
          ],
        ),
        body: Container());
  }
}
