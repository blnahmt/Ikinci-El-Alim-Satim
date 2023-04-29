import 'package:flutter/material.dart';
import 'package:ikinci_el/core/extentions/context_extentions.dart';
import 'package:ikinci_el/core/extentions/radius_extentions.dart';
import 'package:ikinci_el/core/extentions/string_extentions.dart';

class EmailInput extends StatelessWidget {
  const EmailInput({super.key, required TextEditingController controller})
      : _controller = controller;

  final TextEditingController _controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      inputFormatters: [],
      validator: ((value) {
        if (value == null ? true : !value.isValidEmail) {
          return "Geçerli bir Email adresi giriniz...";
        }
        return null;
      }),
      decoration: InputDecoration(
          filled: true,
          fillColor: context.themeData.cardColor,
          border: OutlineInputBorder(
              borderRadius: context.radiusLow, borderSide: BorderSide.none),
          labelText: "Email",
          labelStyle: context.themeData.accentTextTheme.bodyMedium!
              .copyWith(fontWeight: FontWeight.w600)),
    );
  }
}
