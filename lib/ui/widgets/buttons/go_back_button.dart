import 'package:flutter/material.dart';
import 'package:ikinci_el/core/extentions/padding_extentions.dart';
import '../../../core/navigation/navigation_service.dart';

class GoBackButton extends StatelessWidget {
  const GoBackButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: context.paddingLowAll,
      child: InkWell(
        onTap: (() {
          NavigationService().back();
        }),
        child: const Icon(Icons.arrow_back_ios_new_rounded),
      ),
    );
  }
}
