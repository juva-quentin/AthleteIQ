import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'bluetooth_state_notifier.dart'; // Assurez-vous que ce chemin est correct

class BluetoothDevicesScreen extends ConsumerWidget {
  const BluetoothDevicesScreen({super.key});

  static const route = "/devices";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final devices = ref.watch(bluetoothDevicesNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Appareils Bluetooth'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () =>
                ref.read(bluetoothDevicesNotifierProvider.notifier).startScan(),
          ),
        ],
      ),
      body: devices.isEmpty
          ? Center(
              child: Text(
                'Aucun appareil Bluetooth trouvé.\nCliquez sur rechercher pour commencer le scan.',
                textAlign: TextAlign.center,
              ),
            )
          : ListView.builder(
              itemCount: devices.length,
              itemBuilder: (context, index) {
                final device = devices[index].device;
                final deviceSignalStrength = devices[index].rssi;
                return ListTile(
                  leading: Icon(Icons.bluetooth,
                      color: Theme.of(context).primaryColor),
                  title: Text(
                      device.name.isEmpty ? 'Appareil inconnu' : device.name),
                  subtitle: Text('Signal: $deviceSignalStrength dBm'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.link),
                        onPressed: () {
                          ref
                              .read(bluetoothDevicesNotifierProvider.notifier)
                              .pairDevice(device);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          ref
                              .read(bluetoothDevicesNotifierProvider.notifier)
                              .removeDevice(device);
                        },
                      ),
                    ],
                  ),
                  onTap: () {
                    // Optionnel : Ajouter une action lors du tap sur un appareil
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.search),
        onPressed: () =>
            ref.read(bluetoothDevicesNotifierProvider.notifier).startScan(),
        tooltip: 'Rechercher des appareils',
      ),
    );
  }
}
