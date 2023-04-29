import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ikinci_el/core/extentions/context_extentions.dart';
import 'package:ikinci_el/core/extentions/padding_extentions.dart';
import 'package:ikinci_el/core/extentions/radius_extentions.dart';

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
          labelStyle: context.themeData.accentTextTheme.bodyMedium!
              .copyWith(fontWeight: FontWeight.w600)),
    );
  }
}
