import 'package:flutter/material.dart';
import 'package:shopping_list/data/dummy_items.dart';

class GroceryScreen extends StatelessWidget {
  const GroceryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text("Your Groceries"),
      ),
      body: ListView.builder(
        itemCount: groceryItems.length,
        itemBuilder: (context, index) => ListTile(
          leading: Container(
            height: 24,
            width: 24,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3),
              color: groceryItems[index].category.color,
            ),
          ),
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
