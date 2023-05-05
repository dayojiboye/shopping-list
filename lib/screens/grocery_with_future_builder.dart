// ignore_for_file: constant_identifier_names
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shopping_list/constants/api.dart';
import 'package:shopping_list/constants/enums.dart';
import 'package:shopping_list/data/categories.dart';
import 'package:shopping_list/models/category.dart';
import 'package:shopping_list/models/grocery_item.dart';
import 'package:shopping_list/screens/new_item.dart';
import 'package:shopping_list/utils/custom_snackbar.dart';
import 'package:shopping_list/widgets/empty_text.dart';
import 'package:shopping_list/widgets/grocery_list.dart';
import "package:http/http.dart" as http;

class GroceryScreen extends StatefulWidget {
  const GroceryScreen({super.key});

  @override
  State<GroceryScreen> createState() => _GroceryScreenState();
}

class _GroceryScreenState extends State<GroceryScreen> {
  List<GroceryItem> _groceryItems = [];
  String? _error;
  // ViewState currentState = ViewState.IDLE;
  late Future<List<GroceryItem>> _loadedItems;

  @override
  void initState() {
    super.initState();
    _loadedItems = _loadItems();
  }

  Future<List<GroceryItem>> _loadItems() async {
    final response =
        await http.get(const API(endpoint: "shopping-list.json").url);

    if (response.statusCode >= 400) {
      throw Exception("Failed to fetch grocery items. Please try again later.");
    }

    if (response.body == "null") {
      return [];
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

    return loadedItems;
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

  void _removeItem(BuildContext context, GroceryItem item) async {
    final index = _groceryItems.indexOf(item);

    setState(() {
      _groceryItems.remove(item);
    });

    ScaffoldMessenger.of(context).clearSnackBars();

    try {
      final response =
          await http.delete(API(endpoint: "shopping-list/${item.id}.json").url);

      if (response.statusCode == 200) {
        if (!context.mounted) return;

        CustomSnackbar(
          context: context,
          variant: SnackbarVariant.SUCCESS,
          text: "Item was deleted successfully.",
        ).showFeedback();
      }
    } catch (err) {
      setState(() {
        _groceryItems.insert(index, item);
      });

      CustomSnackbar(
        context: context,
        variant: SnackbarVariant.ERROR,
        text: "An error occured! Please try again.",
      ).showFeedback();
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
      // body: renderContent(),
      body: FutureBuilder(
        future: _loadedItems,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return EmptyText(
              text: snapshot.error.toString(),
            );
          }

          if (snapshot.data!.isEmpty) {
            return const EmptyText(
                text: "No grocery item added! \n Please add one now.");
          }

          return GroceryList(
            groceryItems: snapshot.data!,
            onRemoveItem: (GroceryItem item) {
              _removeItem(context, item);
            },
          );
        },
      ),
    );
  }
}
