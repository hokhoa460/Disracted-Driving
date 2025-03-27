import '/flutter_flow/flutter_flow_choice_chips.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'dashboard_model.dart';
export 'dashboard_model.dart';

// Import flutter_blue_plus for Bluetooth functionality
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class DashboardWidget extends StatefulWidget {
  const DashboardWidget({
    super.key,
    required this.createaccount,
    bool? isBTEnabled,
  }) : this.isBTEnabled = isBTEnabled ?? false;

  final bool? createaccount;
  final bool isBTEnabled;

  static String routeName = 'Dashboard';
  static String routePath = '/dashboard';

  @override
  State<DashboardWidget> createState() => _DashboardWidgetState();
}

class _DashboardWidgetState extends State<DashboardWidget> {
  late DashboardModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  // Bluetooth-related variables
  final flutterBlue = FlutterBluePlus.instance; // Fix: Correct way to access singleton
  BluetoothDevice? device;
  BluetoothCharacteristic? characteristic;
  String data = "";

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => DashboardModel());

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));

    scanForDevices();
  }

  // Function to scan for Bluetooth devices
  void scanForDevices() async {
    flutterBlue.startScan(timeout: const Duration(seconds: 4));

    flutterBlue.scanResults.listen((results) async {
      for (ScanResult r in results) {
        print('${r.device.name} found! rssi: ${r.rssi}');

        if (r.device.name == 'Your Device Name') {
          await flutterBlue.stopScan(); // Stop scanning first
          connectToDevice(r.device);
          break;
        }
      }
    });

    // Stop scanning automatically after timeout
    Future.delayed(const Duration(seconds: 4), () async {
      await flutterBlue.stopScan();
    });
  }

  // Function to connect to the Bluetooth device
  void connectToDevice(BluetoothDevice d) async {
    try {
      if (device != null) {
        print("Already connected to a device.");
        return;
      }

      print("Connecting to ${d.name}...");
      await d.connect(autoConnect: false);
      setState(() {
        device = d;
      });

      // Discover services
      List<BluetoothService> services = await d.discoverServices();
      for (BluetoothService service in services) {
        for (BluetoothCharacteristic c in service.characteristics) {
          if (c.uuid.toString().toLowerCase() == 'your_characteristic_uuid') {
            characteristic = c;
            startListening(c);
            break;
          }
        }
      }
    } catch (e) {
      print("Error connecting: $e");
    }
  }

  // Function to listen for data from Bluetooth characteristic
  void startListening(BluetoothCharacteristic characteristic) async {
    try {
      await characteristic.setNotifyValue(true); // Enable notifications

      characteristic.lastValueStream.listen((value) {
        String receivedData = String.fromCharCodes(value);
        print("Received Data: $receivedData");
        setState(() {
          data = receivedData;
        });
        triggerAlert(receivedData);
      });
    } catch (e) {
      print("Error subscribing to notifications: $e");
    }
  }

  void triggerAlert(String data) {
    print("Alert Triggered with Data: $data");
    // Add sound/visual alert logic here
  }

  @override
  void dispose() {
    _model.dispose();
    device?.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: Container(
          width: MediaQuery.sizeOf(context).width * 1.0,
          height: MediaQuery.sizeOf(context).height * 1.0,
          child: Stack(
            children: [
              Image.network(
                'https://images.unsplash.com/photo-1504846257989-a76209d9d2ac?w=500&h=500',
                width: MediaQuery.sizeOf(context).width * 1.0,
                height: MediaQuery.sizeOf(context).height * 1.0,
                fit: BoxFit.cover,
              ),
              Container(
                width: MediaQuery.sizeOf(context).width * 1.0,
                height: MediaQuery.sizeOf(context).height * 1.0,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0x99000000), Color(0x33000000)],
                    stops: [0.0, 1.0],
                    begin: AlignmentDirectional(0.0, -1.0),
                    end: AlignmentDirectional(0, 1.0),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(24.0, 24.0, 24.0, 0.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: AlignmentDirectional(1.0, -1.0),
                        child: InkWell(
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () async {
                            context.pushNamed(
                              SettingsWidget.routeName,
                              queryParameters: {
                                'isBTEnabled': serializeParam(
                                  false,
                                  ParamType.bool,
                                ),
                              }.withoutNulls,
                            );
                          },
                          child: Icon(
                            Icons.settings_sharp,
                            color: Colors.white,
                            size: 50.0,
                          ),
                        ),
                      ),
                      Text(
                        'Dashboard',
                        style: FlutterFlowTheme.of(context).headlineLarge.override(
                              fontFamily: 'Inter Tight',
                              color: Colors.white,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Container(
                        width: MediaQuery.sizeOf(context).width * 1.0,
                        decoration: BoxDecoration(
                          color: Color(0x33FFFFFF),
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text(
                                'Welcome, Trucker!',
                                style: FlutterFlowTheme.of(context).headlineMedium.override(
                                      fontFamily: 'Inter Tight',
                                      color: Colors.white,
                                      letterSpacing: 0.0,
                                    ),
                              ),
                              Text(
                                'Stay safe on the road with our advanced detection system and helpful tips.',
                                style: FlutterFlowTheme.of(context).bodyLarge.override(
                                      fontFamily: 'Inter',
                                      color: Color(0xFFE0E0E0),
                                      letterSpacing: 0.0,
                                    ),
                              ),
                            ].divide(SizedBox(height: 16.0)),
                          ),
                        ),
                      ),
                      Container(
                        width: MediaQuery.sizeOf(context).width * 1.0,
                        decoration: BoxDecoration(
                          color: Color(0x33FFFFFF),
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              FlutterFlowChoiceChips(
                                options: [ChipData('Detection Logs')],
                                onChanged: (val) => setState(() =>
                                    _model.choiceChipsValue = val?.firstOrNull),
                                selectedChipStyle: ChipStyle(
                                  backgroundColor: FlutterFlowTheme.of(context).primary,
                                  textStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                                        fontFamily: 'Inter',
                                        color: Colors.white,
                                        letterSpacing: 0.0,
                                      ),
                                  iconColor: FlutterFlowTheme.of(context).primaryText,
                                  iconSize: 18.0,
                                  elevation: 0.0,
                                  borderRadius: BorderRadius.circular(25.0),
                                ),
                                unselectedChipStyle: ChipStyle(
                                  backgroundColor: Color(0x33FFFFFF),
                                  textStyle: FlutterFlowTheme.of(context).bodySmall.override(
                                        fontFamily: 'Inter',
                                        color: Color(0xFFE0E0E0),
                                        letterSpacing: 0.0,
                                      ),
                                  iconColor: FlutterFlowTheme.of(context).primaryText,
                                  iconSize: 18.0,
                                  elevation: 0.0,
                                  borderRadius: BorderRadius.circular(25.0),
                                ),
                                chipSpacing: 16.0,
                                rowSpacing: 16.0,
                                multiselect: false,
                                alignment: WrapAlignment.start,
                                controller: _model.choiceChipsValueController ??=
                                    FormFieldController<List<String>>(
                                  [],
                                ),
                                wrapped: true,
                              ),
                              Container(
                                width: MediaQuery.sizeOf(context).width * 1.0,
                                height: 300.0,
                                decoration: BoxDecoration(
                                  color: Color(0x33FFFFFF),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 16.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Recent Detections',
                                        style: FlutterFlowTheme.of(context).headlineSmall.override(
                                              fontFamily: 'Inter Tight',
                                              color: Colors.white,
                                              letterSpacing: 0.0,
                                            ),
                                      ),
                                      ListView(
                                        padding: EdgeInsets.zero,
                                        primary: false,
                                        shrinkWrap: true,
                                        scrollDirection: Axis.vertical,
                                        children: [
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Drowsiness Detected',
                                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                      fontFamily: 'Inter',
                                                      color: Colors.white,
                                                      letterSpacing: 0.0,
                                                    ),
                                              ),
                                              Text(
                                                '2 hours ago',
                                                style: FlutterFlowTheme.of(context).bodySmall.override(
                                                      fontFamily: 'Inter',
                                                      color: Color(0xFFE0E0E0),
                                                      letterSpacing: 0.0,
                                                    ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Lane Departure Warning',
                                                style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                      fontFamily: 'Inter',
                                                      color: Colors.white,
                                                      letterSpacing: 0.0,
                                                    ),
                                              ),
                                              Text(
                                                '4 hours ago',
                                                style: FlutterFlowTheme.of(context).bodySmall.override(
                                                      fontFamily: 'Inter',
                                                      color: Color(0xFFE0E0E0),
                                                      letterSpacing: 0.0,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ].divide(SizedBox(height: 16.0)),
                                  ),
                                ),
                              ),
                            ].divide(SizedBox(height: 16.0)),
                          ),
                        ),
                      ),
                      FFButtonWidget(
                        onPressed: () async {
                          context.pushNamed(IncidentGraphWidget.routeName);
                        },
                        text: 'View Full Report',
                        options: FFButtonOptions(
                          width: MediaQuery.sizeOf(context).width * 1.0,
                          height: 50.0,
                          padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                          iconPadding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
                          color: FlutterFlowTheme.of(context).primary,
                          textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                                fontFamily: 'Inter Tight',
                                color: Colors.white,
                                letterSpacing: 0.0,
                              ),
                          elevation: 0.0,
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                      ),
                    ].divide(SizedBox(height: 24.0)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
