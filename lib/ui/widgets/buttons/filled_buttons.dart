import 'package:flutter/material.dart';
import 'package:ikinci_el/core/extentions/context_extentions.dart';
import 'package:ikinci_el/core/extentions/padding_extentions.dart';
import 'package:ikinci_el/core/extentions/radius_extentions.dart';
import 'package:ikinci_el/ui/widgets/loading/loading.dart';

class FilledButton extends StatelessWidget {
  const FilledButton(
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
      child: Container(
        decoration: BoxDecoration(
            color: context.colorScheme.primary,
            borderRadius: context.radiusLow),
        child: Center(
          child: Padding(
            padding: context.paddingMediumAll,
            child: isLoading
                ? const Loading(
                    isSmall: true,
                    isWhite: true,
                  )
                : Text(
                    label,
                    style: context.textTheme.bodyLarge!.copyWith(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
          ),
        ),
      ),
    );
  }
}
