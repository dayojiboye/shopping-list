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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        itemCount: groceryItems.length,
        itemBuilder: (context, index) => Column(
          children: [
            Row(
              children: [
                Container(
                  height: 30,
                  width: 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    color: groceryItems[index].category?.color,
                  ),
                ),
                const SizedBox(width: 30),
                Text(
                  groceryItems[index].name,
                  style: const TextStyle(fontSize: 20),
                ),
                const Spacer(),
                Text(
                  groceryItems[index].quantity.toString(),
                  style: const TextStyle(fontSize: 16),
                )
              ],
            ),
            const SizedBox(
              height: 40,
            )
          ],
        ),
      ),
    );
  }
}
