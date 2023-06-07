import 'package:flutter/material.dart';
import 'package:ikinci_el/core/extentions/context_extentions.dart';
import 'package:ikinci_el/core/extentions/padding_extentions.dart';

class DefaultMenuDialog<T extends Widget> extends StatelessWidget {
  const DefaultMenuDialog(
      {Key? key, required this.children, required this.title})
      : super(key: key);
  final List<T> children;
  final String title;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: context.colorScheme.background,
      titlePadding: context.paddingMediumAll,
      title: Text(
        title,
        style: context.primarytTextTheme.bodyLarge,
      ),
      contentPadding: context.paddingLowOnly(bottom: true),
      scrollable: true,
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [...children],
      ),
    );
  }
}
