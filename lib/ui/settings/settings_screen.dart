import 'package:athlete_iq/ui/settings/devices/devices_screen.dart';
import 'package:athlete_iq/ui/settings/profil/profile_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../utils/routes/router.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);
  static const route = "/settings";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Paramètres"),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text("Profile"),
            onTap: () => Navigator.pushNamed(context, ProfileScreen.route),
          ),
          ListTile(
            title: Text("Appareils"),
            onTap: () =>
                Navigator.pushNamed(context, BluetoothDevicesScreen.route),
          ),
        ],
      ),
    );
  }
}
