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

import 'package:flutter_blue_plus/flutter_blue_plus.dart';

void startAdvertising() async {
  final flutterBlue = FlutterBluePlus.instance;

  // Define a service UUID for your app
  var serviceUuid = Guid("1179d14a-163a-433d-8265-b3389565bdf0");
  var characteristicUuid = Guid("c87f21dd-a4a7-419b-b038-49ee00c42f87");

  // Define a characteristic
  BluetoothCharacteristic characteristic = BluetoothCharacteristic(
    characteristicUuid,
    properties: BluetoothCharacteristicProperties(
      read: true,
      write: true,
      notify: true,
    ),
    value: [],
  );

  // Create a service with the characteristic
  BluetoothService service = BluetoothService(
    serviceUuid,
    isPrimary: true,
    characteristics: [characteristic],
  );

  // Start advertising the service
  await flutterBlue.startAdvertising(service);
  print("BLE Advertising Started!");
}
