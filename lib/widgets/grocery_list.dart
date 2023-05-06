import 'package:flutter/material.dart';
import 'package:shopping_list/models/grocery_item.dart';
import 'package:shopping_list/widgets/category_color_tag.dart';

class GroceryList extends StatelessWidget {
  const GroceryList(
      {super.key, required this.groceryItems, required this.onRemoveItem});

  final List<GroceryItem> groceryItems;
  final void Function(GroceryItem item) onRemoveItem;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: groceryItems.length,
      itemBuilder: (context, index) => Dismissible(
        key: ValueKey(groceryItems[index].id),
        onDismissed: (direction) {
          onRemoveItem(groceryItems[index]);
        },
        background: Container(color: Colors.red),
        child: ListTile(
          leading: CategoryColorTag(color: groceryItems[index].category.color),
          title: Text(
            groceryItems[index].name,
            style: const TextStyle(fontSize: 20),
          ),
          trailing: Text(
            groceryItems[index].quantity.toString(),
            style: const TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}
