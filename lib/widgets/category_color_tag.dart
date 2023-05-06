import 'package:flutter/material.dart';

class CategoryColorTag extends StatelessWidget {
  const CategoryColorTag({
    super.key,
    required this.color,
    this.width = 24,
    this.height = 24,
  });

  final Color color;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}
