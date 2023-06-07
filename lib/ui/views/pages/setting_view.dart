import 'package:bluetooth_enable_fork/bluetooth_enable_fork.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:ikinci_el/core/auth/auth_manager.dart';
import 'package:ikinci_el/core/extentions/context_extentions.dart';
import 'package:ikinci_el/core/extentions/padding_extentions.dart';
import 'package:ikinci_el/core/navigation/navigation_service.dart';
import 'package:ikinci_el/core/navigation/routes.dart';
import 'package:ikinci_el/ui/widgets/buttons/simple_button.dart';

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
