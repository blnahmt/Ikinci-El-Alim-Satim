import 'package:flutter/material.dart';
import 'package:ikinci_el/core/constants/colors.dart';
import 'package:ikinci_el/core/extentions/context_extentions.dart';

class SearchInput extends StatelessWidget {
  const SearchInput({
    super.key,
    required TextEditingController controller,
    required this.label,
    this.onChanged,
  }) : _controller = controller;

  final TextEditingController _controller;
  final String label;

  final void Function(String)? onChanged;
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      autofocus: false,
      onChanged: onChanged,
      decoration: InputDecoration(
          filled: true,
          suffixIcon: Icon(Icons.search),
          fillColor: context.themeData.cardColor,
          labelText: label,
          labelStyle: context.themeData.textTheme.bodyMedium!
              .copyWith(color: AppColors.fieryRose,fontWeight: FontWeight.w600)),
    );
  }
}
