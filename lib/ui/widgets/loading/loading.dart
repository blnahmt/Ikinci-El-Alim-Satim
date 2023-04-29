import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ikinci_el/core/extentions/context_extentions.dart';

class Loading extends StatelessWidget {
  const Loading({Key? key, this.isSmall = false, this.isWhite = false})
      : super(key: key);
  final bool isSmall;
  final bool isWhite;
  @override
  Widget build(BuildContext context) {
    return SpinKitChasingDots(
      color: isWhite ? Colors.white : context.themeData.primaryColor,
      size: context.dynamicHeight(isSmall ? 2 : 4),
    );
  }
}
