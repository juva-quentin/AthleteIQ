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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text("Paramètres"),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text("Profil"),
            onTap: () => Navigator.pushNamed(context, ProfileScreen.route),
          ),
          ListTile(
            title: const Text("Appareils"),
            onTap: () =>
                Navigator.pushNamed(context, BluetoothDevicesScreen.route),
          ),
          ListTile(
            title: const Text("A propos de nous"),
            onTap: () =>
                Navigator.pushNamed(context, BluetoothDevicesScreen.route),
          ),
          ListTile(
            title: const Text("Conditions d'utilisation"),
            onTap: () =>
                Navigator.pushNamed(context, BluetoothDevicesScreen.route),
          ),
          ListTile(
            title: const Text("Politique de confidentialité"),
            onTap: () =>
                Navigator.pushNamed(context, BluetoothDevicesScreen.route),
          ),
        ],
        //TODO: Ajouter la version de l'application
      ),
    );
  }
}
