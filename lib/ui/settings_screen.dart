import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:unicons/unicons.dart';

import 'auth/login_screen.dart';
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
        title: const Text("Paramètres", style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),),
        leading: IconButton(
          icon: Icon(UniconsLine.arrow_left,size: width*.1),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(onPressed: () async {
          await auth.logout();
          Navigator.pushNamedAndRemoveUntil(
            context,
            LoginScreen.route,
                (route) => false,
          );
        }, icon: Icon(UniconsLine.exit, size: width*.1)),],
      ),
      body:Container()
    );
  }
}
