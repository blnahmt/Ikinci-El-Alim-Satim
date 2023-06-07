import 'package:bluetooth_enable_fork/bluetooth_enable_fork.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:ikinci_el/core/auth/auth_manager.dart';
import 'package:ikinci_el/core/extentions/context_extentions.dart';
import 'package:ikinci_el/core/extentions/padding_extentions.dart';
import 'package:ikinci_el/core/navigation/navigation_service.dart';
import 'package:ikinci_el/core/navigation/routes.dart';
import 'package:ikinci_el/ui/widgets/buttons/filled_buttons.dart';
import 'package:ikinci_el/ui/widgets/buttons/simple_button.dart';
import 'package:ikinci_el/ui/widgets/loading/loading.dart';

import '../../widgets/buttons/go_back_button.dart';

class SettingsView extends StatelessWidget {
  SettingsView({super.key});
  final FlutterBlue flutterBlue = FlutterBlue.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const GoBackButton(),
        iconTheme: context.themeData.iconTheme,
        title: const Text("Settings"),
      ),
      body: Column(children: [
        Expanded(child: BluetoothDevices()),
        Padding(
          padding: context.paddingMediumAll,
          child: SimpleButton(
              onTap: () async {
                await AuthManager().signOut();
                NavigationService().clearAllTo(routeName: Routes.signin);
              },
              label: "LogOut"),
        )
      ]),
    );
  }
}

class BluetoothDevices extends StatefulWidget {
  const BluetoothDevices({
    Key? key,
  }) : super(key: key);

  @override
  State<BluetoothDevices> createState() => _BluetoothDevicesState();
}

class _BluetoothDevicesState extends State<BluetoothDevices> {
  final FlutterBlue flutterBlue = FlutterBlue.instance;
  List<ScanResult> devices = [];

  bool isLoading = false;
  changeIsLoading() {
    setState(() {
      isLoading = !isLoading;
    });
  }

  bool isON = false;
  changeIsON() {
    setState(() {
      isON = !isON;
    });
  }

  @override
  void initState() {
    super.initState();

    getDevices();
  }

  void getDevices() async {
    isON = await flutterBlue.isOn;
    setState(() {});
    if (isON) {
      changeIsLoading();
      flutterBlue.startScan(timeout: Duration(seconds: 4));


      flutterBlue.stopScan();
      changeIsLoading();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: devices.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(isON ? "Bluetooth açık" : "Bluetooth kapalı"),
              isLoading ? Loading() : SizedBox.shrink(),
              !isON
                  ? MyFilledButton(
                      onTap: () {
                        BluetoothEnable.enableBluetooth.then((result) {
                          if (result == "true") {
                            setState(() {
                              isON = true;
                            });
                          } else if (result == "false") {
                            setState(() {
                              isON = false;
                            });
                          }
                          getDevices();
                        });
                      },
                      label: "Bluetooth'u Aç",
                    )
                  : IconButton(
                      onPressed: () {
                        BluetoothEnable.enableBluetooth.then((result) {
                          if (result == "true") {
                            setState(() {
                              isON = true;
                            });
                          } else if (result == "false") {
                            setState(() {
                              isON = false;
                            });
                          }
                          getDevices();
                        });
                      },
                      icon: Icon(Icons.bluetooth_searching_rounded),
                    )
            ],
          );
        } else {
          return ListTile(
            onTap: () {
              devices[index - 1].device.connect();
            },
            title: Text(devices[index - 1].device.type.name),
          );
        }
      },
    );
  }
}
