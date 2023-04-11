import 'package:athlete_iq/ui/auth/login_screen.dart';
import 'package:athlete_iq/ui/info/provider/user_provider.dart';
import 'package:athlete_iq/ui/providers/loading_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unicons/unicons.dart';

import '../../app/app.dart';
import '../../utils/utils.dart';
import '../auth/providers/auth_view_model_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({Key, key}) : super(key: key);

  static const route = "/settings";
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authViewModelProvider);
    final isLoading = ref.watch(loadingProvider);
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
              onPressed: () =>
                  Navigator.pushReplacementNamed(context, App.route)),
          actions: [
            IconButton(
                onPressed: () async {
                  try {
                    await auth.logout().then((value) =>
                        Navigator.pushNamedAndRemoveUntil(
                            context,
                            LoginScreen.route,
                            (Route<dynamic> route) => false));
                  } catch (e) {
                    Utils.flushBarErrorMessage(e.toString(), context);
                    if (kDebugMode) {
                      print(e);
                    }
                  }
                },
                icon: Icon(UniconsLine.exit, size: width * .1)),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            // TextFormField(
            //   initialValue: user.when(
            //     data: (user) {
            //       return user.pseudo;
            //     },
            //     error: (Object error, StackTrace? stackTrace) {
            //       "Erreur";
            //     },
            //     loading: () {
            //       "Chargement...";
            //     },
            //   ),
            //   autocorrect: false,
            //   textCapitalization: TextCapitalization.none,
            //   textInputAction: TextInputAction.next,
            //   decoration: const InputDecoration(
            //     prefixIcon: Icon(Icons.person),
            //     labelText: "Pseudo",
            //   ),
            //   onChanged: (v) => auth.pseudo = v,
            // ),
            // TextFormField(
            //   initialValue: user.when(
            //     data: (user) {
            //       return user.email;
            //     },
            //     error: (Object error, StackTrace? stackTrace) {
            //       "Erreur";
            //     },
            //     loading: () {
            //       "Chargement...";
            //     },
            //   ),
            //   autocorrect: false,
            //   textCapitalization: TextCapitalization.none,
            //   textInputAction: TextInputAction.next,
            //   decoration: const InputDecoration(
            //     prefixIcon: Icon(Icons.email),
            //     labelText: "Email",
            //   ),
            //   onChanged: (v) => auth.email = v,
            // ),
            // TextFormField(
            //   initialValue: user.when(
            //     data: (user) {
            //       return user.objectif.toString();
            //     },
            //     error: (Object error, StackTrace? stackTrace) {
            //       "Erreur";
            //     },
            //     loading: () {
            //       "Chargement...";
            //     },
            //   ),
            //   autocorrect: false,
            //   textCapitalization: TextCapitalization.none,
            //   textInputAction: TextInputAction.next,
            //   decoration: const InputDecoration(
            //     prefixIcon: Icon(Icons.bike_scooter),
            //     labelText: "Objectif",
            //   ),
            //   onChanged: (v) => auth.email = v,
            // ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor),
                  child: Center(
                      child: isLoading.loading
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : Text(
                              "Confirmer",
                              style: TextStyle(color: Colors.white),
                            ))),
            )
          ]),
        ));
  }
}
