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

  final double radius = 15;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      textInputAction: textInputAction,
      maxLength: maxLength,
      textCapitalization: textCapitalization,
      style: const TextStyle(fontSize: 16),
      initialValue: initialValue,
      decoration: decoration ??
          InputDecoration(
            label: label != null ? Text(label!) : null,
            hintText: hintText,
            hintStyle: const TextStyle(fontSize: 16),
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            prefix: const Padding(padding: EdgeInsets.only(left: 12)),
            contentPadding: const EdgeInsets.only(
              bottom: 20,
              top: 20,
              right: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(radius),
              ),
            ),
            filled: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Color(0xffcccccc),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(radius),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Color.fromARGB(255, 197, 46, 35),
                width: 2.0,
              ),
              borderRadius: BorderRadius.circular(radius),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.black, width: 2.0),
              borderRadius: BorderRadius.circular(radius),
            ),
          ),
      validator: validator,
      onSaved: onSaved,
    );
  }
}
