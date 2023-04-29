import 'package:flutter/material.dart';

mixin DialogMixin {
  showDefaultDialog(BuildContext context, Widget child) {
    showDialog(
      context: context,
      builder: (context) {
        return child;
      },
    );
  }
}
