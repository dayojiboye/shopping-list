import 'package:flutter/material.dart';
import 'package:shopping_list/data/categories.dart';
import 'package:shopping_list/models/category.dart';
import 'package:shopping_list/utils/custom_bottomsheet.dart';
import 'package:shopping_list/widgets/category_color_tag.dart';
import 'package:shopping_list/widgets/touchable_opacity.dart';

class CategoriesButton extends StatefulWidget {
  const CategoriesButton({
    super.key,
    required this.selectedCategory,
    required this.categories,
    required this.onSelect,
  });

  final Category selectedCategory;
  final Map<Categories, Category> categories;
  final void Function(Category? value) onSelect;

  @override
  State<CategoriesButton> createState() => _CategoriesButtonState();
}

class _CategoriesButtonState extends State<CategoriesButton> {
  void _openCategoriesBottomsheet() {
    CustomBottomsheet(
      context: context,
      child: Expanded(
        child: SingleChildScrollView(
          child: Column(
            children: categories.entries
                .map(
                  (category) => TouchableOpacity(
                    onTap: () {
                      widget.onSelect(category.value);
                      Navigator.of(context).pop();
                    },
                    width: double.infinity,
                    height: null,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: const BoxDecoration(),
                    child: ListTile(
                      leading: CategoryColorTag(color: category.value.color),
                      title: Text(
                        category.value.title,
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ),
    ).open();
  }

  @override
  Widget build(BuildContext context) {
    return TouchableOpacity(
      onTap: _openCategoriesBottomsheet,
      decoration: const BoxDecoration(),
      child: Row(
        children: [
          CategoryColorTag(
            color: widget.selectedCategory.color,
            height: 20,
            width: 20,
          ),
          const SizedBox(width: 16),
          Text(
            widget.selectedCategory.title,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
