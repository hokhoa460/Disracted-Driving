// Automatic FlutterFlow imports
import '/backend/backend.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class ConnectBluetoothWidget extends StatefulWidget {
  @override
  _ConnectBluetoothWidgetState createState() => _ConnectBluetoothWidgetState();
}

class _ConnectBluetoothWidgetState extends State<ConnectBluetoothWidget> {
  FlutterBluePlus flutterBlue = FlutterBluePlus.instance;
  BluetoothDevice? device;
  BluetoothCharacteristic? characteristic;

  @override
  void initState() {
    super.initState();
    scanForDevices();
  }

  void scanForDevices() {
    flutterBlue.startScan(timeout: Duration(seconds: 4));

    flutterBlue.scanResults.listen((results) {
      for (ScanResult r in results) {
        print('${r.device.name} found! rssi: ${r.rssi}');
        if (r.device.name == 'Khoa iPhone') {
          flutterBlue.stopScan();
          connectToDevice(r.device);
          break;
        }
      }
    });
  }

  void connectToDevice(BluetoothDevice d) async {
    await d.connect();
    setState(() {
      device = d;
    });

    // Discover services
    List<BluetoothService> services = await d.discoverServices();
    services.forEach((service) {
      service.characteristics.forEach((c) {
        if (c.uuid.toString() == 'c87f21dd-a4a7-419b-b038-49ee00c42f87') {
          characteristic = c;
          startListening(characteristic!);
        }
      });
    });
  }

  void startListening(BluetoothCharacteristic characteristic) {
    characteristic.value.listen((value) {
      String receivedData = String.fromCharCodes(value);
      triggerAlert(receivedData);
      setState(() {
        // Update your dashboard state
      });
    });
    characteristic.setNotifyValue(true);
  }

  void triggerAlert(String data) {
    // Trigger sound and visual alert
    print("Received Data: $data");
    // Add code for playing sound and showing visual alert here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Connect Bluetooth'),
      ),
      body: Center(
        child: device == null
            ? Text('Scanning for devices...')
            : Text('Connected to ${device!.name}'),
      ),
    );
  }
}
