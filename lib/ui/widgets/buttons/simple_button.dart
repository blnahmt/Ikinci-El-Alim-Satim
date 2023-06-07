import 'package:flutter/material.dart';
import 'package:ikinci_el/core/constants/colors.dart';
import 'package:ikinci_el/core/extentions/context_extentions.dart';
import 'package:ikinci_el/core/extentions/padding_extentions.dart';
import 'package:ikinci_el/ui/widgets/loading/loading.dart';

class SimpleButton extends StatelessWidget {
  const SimpleButton(
      {Key? key,
      required this.onTap,
      required this.label,
      this.isLoading = false})
      : super(key: key);
  final VoidCallback onTap;
  final String label;
  final bool isLoading;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? () {} : onTap,
      child: Center(
        child: Padding(
          padding: context.paddingLowAll,
          child: isLoading
              ? const Loading(
                  isSmall: true,
                )
              : Text(
                  label,
                  style: context.themeData.textTheme.bodyLarge!
                      .copyWith(fontWeight: FontWeight.bold,color: AppColors.fieryRose),
                ),
        ),
      ),
    );
  }
}
