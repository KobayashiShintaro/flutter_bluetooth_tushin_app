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
      home: DeviceListWidget(),
    );
  }
}

class BluetoothService {
  late FlutterReactiveBle _ble;
  late ConnectedDevice _connectedDeviceOperator;

  BluetoothService() {
    _ble = FlutterReactiveBle();
    _connectedDeviceOperator = _ble.connectedDevice;
  }

  Stream<List<DiscoveredDevice>> scanForDevices(
      {Duration scanTimeout = const Duration(seconds: 10)}) {
    return _ble.scanForDevices(
      withServices: [],
      scanMode: ScanMode.balanced,
      requireLocationServicesEnabled: true,
      // 10秒スキャン
    ).map((devices) => [devices]);
  }

  Future<List<DiscoveredService>> discoverServices(String deviceId) =>
      _connectedDeviceOperator.discoverServices(deviceId);

  Future<List<BluetoothService>> getServices(String deviceId) async {
    final connectedDevice = await _ble.connectToDevice(id: deviceId).first;
    return connectedDevice.discoverServices().first;
  }
}

class DeviceListWidget extends StatefulWidget {
  const DeviceListWidget({Key? key}) : super(key: key);
  @override
  _DeviceListWidgetState createState() => _DeviceListWidgetState();
}

class _DeviceListWidgetState extends State<DeviceListWidget> {
  final _bluetoothService = BluetoothService();

  List<DiscoveredDevice> _devices = [];
  DiscoveredDevice? _selectedDevice;

  @override
  void initState() {
    super.initState();
    _startScan();
  }

  @override
  void dispose() {
    _stopScan();
    super.dispose();
  }

  void _startScan() {
    _bluetoothService.scanForDevices().listen((devices) {
      setState(() {
        _devices = devices;
      });
    });
  }

  void _stopScan() {
    _bluetoothService.scanForDevices().first.then((_) {
      _devices.clear();
      setState(() {});
    });
  }

  Future<void> _onDeviceSelected(DiscoveredDevice device) async {
    final services = await _bluetoothService.getServices(device.id);
    setState(() {
      _selectedDevice = device;
      // 選択したデバイスのサービスを表示
      print(services);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Device List')),
        body: ListView.builder(
            itemCount: _devices.length,
            itemBuilder: (BuildContext context, int index) {
              final device = _devices[index];
              return ListTile(
                title: Text(device.name),
                subtitle: Text(device.id),
                onTap: () => _onDeviceSelected(device),
              );
            }));
  }
}
