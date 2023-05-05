import 'package:flutter/material.dart';
import 'package:shopping_list/constants/enums.dart';

class CustomSnackbar {
  const CustomSnackbar(
      {required this.context, required this.variant, required this.text});

  final BuildContext context;
  final SnackbarVariant variant;
  final String text;

  Color? get _getVariant {
    switch (variant) {
      case SnackbarVariant.ERROR:
        return Colors.red;

      case SnackbarVariant.SUCCESS:
        return Colors.green;

      default:
        return null;
    }
  }

  void showFeedback() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: _getVariant,
        content: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
