import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class BluetoothDevicesNotifier extends StateNotifier<List<ScanResult>> {
  BluetoothDevicesNotifier() : super([]) {
    _startListeningForDevices();
  }

  void _startListeningForDevices() {
    // Arrêtez un scan en cours avant de démarrer un nouveau
    FlutterBluePlus.stopScan();
    FlutterBluePlus.startScan(timeout: const Duration(seconds: 4));
    FlutterBluePlus.scanResults.listen((results) {
      state = results;
    });
  }

  void startScan() {
    _startListeningForDevices();
  }

  void stopScan() {
    FlutterBluePlus.stopScan();
  }

  Future<void> pairDevice(BluetoothDevice device) async {
    await device.connect();
    // Ajouter des actions post-connexion si nécessaire
  }

  Future<void> removeDevice(BluetoothDevice device) async {
    await device.disconnect();
    // Effectuer des opérations de nettoyage après la déconnexion si nécessaire
  }

  @override
  void dispose() {
    stopScan();
    super.dispose();
  }
}

final bluetoothDevicesNotifierProvider =
    StateNotifierProvider<BluetoothDevicesNotifier, List<ScanResult>>((ref) {
  return BluetoothDevicesNotifier();
});
