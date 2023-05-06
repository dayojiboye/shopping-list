import 'package:flutter/material.dart';

class CustomBottomsheet {
  const CustomBottomsheet({
    required this.context,
    required this.child,
  });

  final BuildContext context;
  final Widget child;

  void open() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              // bottom sheet top handle
              Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 20),
              // inner child widget
              child
            ],
          ),
        ),
      ),
    );
  }
}
