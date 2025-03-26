// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BluetoothService {
  FlutterBluePlus flutterBlue = FlutterBluePlus.instance;
  BluetoothDevice? connectedDevice;
  BluetoothCharacteristic? characteristic;

  Future<void> connectToDevice(String deviceId) async {
    List<BluetoothDevice> devices = await flutterBlue.connectedDevices;
    for (BluetoothDevice device in devices) {
      if (device.id.id == deviceId) {
        connectedDevice = device;
        break;
      }
    }

    if (connectedDevice == null) {
      flutterBlue.scanResults.listen((results) {
        for (ScanResult result in results) {
          if (result.device.id.id == deviceId) {
            connectedDevice = result.device;
            flutterBlue.stopScan();
            break;
          }
        }
      });
      await flutterBlue.startScan(timeout: Duration(seconds: 4));
    }

    if (connectedDevice != null) {
      await connectedDevice!.connect();
      List<BluetoothService> services = await connectedDevice!.discoverServices();
      for (BluetoothService service in services) {
        for (BluetoothCharacteristic c in service.characteristics) {
          characteristic = c;
          break;
        }
        if (characteristic != null) break;
      }
    }
  }

  Future<void> sendData(String data) async {
    if (characteristic != null) {
      await characteristic!.write(utf8.encode(data));
    }
  }

  void listenForData(BuildContext context) {
    characteristic?.value.listen((value) {
      String data = utf8.decode(value);
      // Trigger sound and visual alert
      // Update your Dashboard page with the received data
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Data received: $data")));
    });
  }
}
