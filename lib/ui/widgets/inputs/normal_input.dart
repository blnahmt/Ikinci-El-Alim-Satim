import 'package:flutter/material.dart';
import 'package:ikinci_el/core/constants/colors.dart';
import 'package:ikinci_el/core/extentions/context_extentions.dart';
import 'package:ikinci_el/core/extentions/radius_extentions.dart';

class NormalInput extends StatelessWidget {
  const NormalInput(
      {super.key,
      required TextEditingController controller,
      required this.label,
      this.line = 1})
      : _controller = controller;

  final TextEditingController _controller;
  final String label;
  final int line;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      maxLines: line,
      inputFormatters: [],
      validator: ((value) {
        if (value == null ? true : value.isEmpty) {
          return "$label alanı boş bırakılamaz";
        }
        return null;
      }),
      decoration: InputDecoration(
          filled: true,
          fillColor: context.themeData.cardColor,
          border: OutlineInputBorder(
              borderRadius: context.radiusLow, borderSide: BorderSide.none),
          labelText: label,
          labelStyle: context.themeData.textTheme.bodyMedium!
              .copyWith(color: AppColors.fieryRose,fontWeight: FontWeight.w600)),
    );
  }
}
