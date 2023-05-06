import 'package:flutter/material.dart';

class AppTextFormField extends StatelessWidget {
  const AppTextFormField({
    super.key,
    this.controller,
    this.textInputAction,
    this.onSaved,
    this.maxLength = 50,
    this.decoration,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.hintText = "Placeholder",
    this.keyboardType,
    this.obscureText = false,
    this.textCapitalization = TextCapitalization.none,
    this.label,
    this.initialValue,
  });

  final TextEditingController? controller;
  final TextInputAction? textInputAction;
  final void Function(String?)? onSaved;
  final int? maxLength;
  final InputDecoration? decoration;
  final String? Function(String?)? validator;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String hintText;
  final TextInputType? keyboardType;
  final bool obscureText;
  final TextCapitalization textCapitalization;
  final String? label;
  final String? initialValue;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      textInputAction: textInputAction,
      maxLength: maxLength,
      textCapitalization: textCapitalization,
      style: const TextStyle(fontSize: 14),
      initialValue: initialValue,
      decoration: decoration ??
          InputDecoration(
            label: label != null ? Text(label!) : null,
            hintText: hintText,
            hintStyle: const TextStyle(fontSize: 14),
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            prefix: const Padding(padding: EdgeInsets.only(left: 12)),
            contentPadding: const EdgeInsets.only(
              bottom: 20,
              top: 20,
              right: 12,
            ),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(7),
              ),
            ),
          ),
      validator: validator,
      onSaved: onSaved,
    );
  }
}
