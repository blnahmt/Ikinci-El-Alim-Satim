import 'package:flutter/material.dart';
import 'package:ikinci_el/core/constants/colors.dart';
import 'package:ikinci_el/core/extentions/context_extentions.dart';
import 'package:ikinci_el/core/extentions/radius_extentions.dart';
import 'package:ikinci_el/core/extentions/string_extentions.dart';

class PasswordInput extends StatefulWidget {
  const PasswordInput({super.key, required TextEditingController controller})
      : _controller = controller;
  final TextEditingController _controller;
  @override
  State<PasswordInput> createState() => _PasswordInputState();
}

class _PasswordInputState extends State<PasswordInput> {
  bool isVisible = false;

  changeIsVisible() {
    setState(() {
      isVisible = !isVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        controller: widget._controller,
        obscureText: !isVisible,
        inputFormatters: [],
        validator: ((value) {
          if (value == null || value.isEmpty) {
            return "Şifre alanı boş olamaz.";
          } else if (!value.isValidPassword) {
            if (value.length < 8) {
              return "Şifre en az 8 karakter olmalı.";
            } else {
              return "Geçerli bir şifre giriniz.";
            }
          }
          return null;
        }),
        decoration: InputDecoration(
            suffixIcon: IconButton(
              onPressed: changeIsVisible,
              icon: Icon(isVisible ? Icons.visibility_off : Icons.visibility),
            ),
            filled: true,
            fillColor: context.themeData.cardColor,
            border: OutlineInputBorder(
                borderRadius: context.radiusLow, borderSide: BorderSide.none),
            labelText: "Şifre",
            labelStyle: context.themeData.textTheme.bodyMedium!
                .copyWith(color:AppColors.fieryRose,fontWeight: FontWeight.w600)));
  }
}
