import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:freezed/builder.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:async/async.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ble_tushin',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'ble_tushin'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _flutterReactiveBle = FlutterReactiveBle();

  StreamSubscription<List<ScanResult>> _scanSubscription;
  List<ScanResult> _scanResults = [];

  ScanResult _toScanResult(DiscoveredDevice device) {
    return ScanResult(
      device: device,
      advertisementData: AdvertisementData(),
      rssi: -100,
    );
  }

  void startScan() {
    _scanSubscription =
        _flutterReactiveBle.scanForDevices(withServices: []).listen(
      (discoveredDevice) {
        final scanResult = _toScanResult(discoveredDevice);
        setState(() {
          _scanResults.add(scanResult);
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        height: 300.0,
        child: ListView.builder(
          itemCount: _scanResults.length,
          itemBuilder: (BuildContext context, int index) {
            final scanResult = _scanResults[index];
            return ListTile(
              title: Text(scanResult.device.name ?? "Unknown"),
              subtitle: Text(scanResult.device.id.toString()),
              onTap: () {
                connectToDevice(scanResult.device.id);
              },
            );
          },
        ),
      ),
    );
  }

  void connectToDevice(Uuid deviceId) async {
    _scanSubscription?.cancel();

    final deviceConnection = _flutterReactiveBle.connectToDevice(
      id: deviceId,
      connectionTimeout: const Duration(seconds: 10),
    );

    final deviceServices = deviceConnection
        .flatMap(
            (connection) => connection.discoverAllServicesAndCharacteristics())
        .asBroadcastStream();

    deviceServices.listen((event) {
      // サービスを読み取る処理
    });
  }
}
