// ignore_for_file: constant_identifier_names
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shopping_list/data/categories.dart';
import 'package:shopping_list/models/category.dart';
import 'package:shopping_list/models/grocery_item.dart';
import 'package:shopping_list/screens/new_item.dart';
import 'package:shopping_list/widgets/empty_text.dart';
import 'package:shopping_list/widgets/grocery_list.dart';
import "package:http/http.dart" as http;

enum CurrentState { IDLE, LOADING, ERROR, SUCCESS }

class GroceryScreen extends StatefulWidget {
  const GroceryScreen({super.key});

  @override
  State<GroceryScreen> createState() => _GroceryScreenState();
}

class _GroceryScreenState extends State<GroceryScreen> {
  List<GroceryItem> _groceryItems = [];
  String? _error;
  CurrentState currentState = CurrentState.IDLE;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  void _loadItems() async {
    setState(() {
      currentState = CurrentState.LOADING;
    });

    final url = Uri.https(
        "flutter-prep-8e00d-default-rtdb.firebaseio.com", "shopping-list.json");
    final response = await http.get(url);

    if (response.statusCode >= 400) {
      setState(() {
        _error = "Failed to fetch data. Please try again later.";
        currentState = CurrentState.ERROR;
      });
    }

    final Map<String, dynamic> listData = jsonDecode(response.body);

    final List<GroceryItem> loadedItems = [];

    for (final item in listData.entries) {
      final Category category = categories.entries
          .firstWhere(
              (catItem) => catItem.value.title == item.value["category"])
          .value;

      loadedItems.add(
        GroceryItem(
          id: item.key,
          name: item.value["name"],
          quantity: item.value["quantity"],
          category: category,
        ),
      );
    }

    setState(() {
      _groceryItems = loadedItems;
      // _isLoading = false;
      currentState = CurrentState.SUCCESS;
    });
  }

  void _addItem() async {
    final newItem = await Navigator.of(context).push<GroceryItem>(
      MaterialPageRoute(
        builder: (ctx) => const NewItemScreen(),
      ),
    );

    if (newItem == null) return;

    setState(() {
      _groceryItems.add(newItem);
    });
  }

  void _removeItem(GroceryItem item) {
    setState(() {
      _groceryItems.remove(item);
    });
  }

  Widget? renderContent() {
    switch (currentState) {
      case CurrentState.LOADING:
        return const Center(child: CircularProgressIndicator());

      case CurrentState.ERROR:
        return EmptyText(text: _error!);

      case CurrentState.SUCCESS:
        if (_groceryItems.isEmpty) {
          return const EmptyText(
              text: "No grocery item added! \n Please add one now.");
        }

        return GroceryList(
          groceryItems: _groceryItems,
          onRemoveItem: (GroceryItem item) {
            _removeItem(item);
          },
        );

      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Groceries"),
        actions: [
          IconButton(
            onPressed: _addItem,
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: renderContent(),
    );
  }
}
