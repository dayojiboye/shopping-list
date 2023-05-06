import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shopping_list/constants/api.dart';
import 'package:shopping_list/constants/enums.dart';
import 'package:shopping_list/data/categories.dart';
import 'package:shopping_list/models/category.dart';
import 'package:shopping_list/models/grocery_item.dart';
import "package:http/http.dart" as http;
import 'package:shopping_list/utils/custom_snackbar.dart';
import 'package:shopping_list/widgets/app_progress_indicator.dart';
import 'package:shopping_list/widgets/app_text_button.dart';
import 'package:shopping_list/widgets/touchable_opacity.dart';

class NewItemScreen extends StatefulWidget {
  const NewItemScreen({super.key});

  @override
  State<NewItemScreen> createState() => _NewItemScreenState();
}

class _NewItemScreenState extends State<NewItemScreen> {
  final _formKey = GlobalKey<
      FormState>(); // gives us access to the underlying widget it is connected to

  String _enteredName = "";
  int _enteredQuantity = 1;
  Category _selectedCategory = categories[Categories.vegetables]!;
  bool _isSending = false;

  void _saveItem() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isSending = true;
      });

      try {
        final response = await http.post(
          const API(endpoint: "shopping-list.json").url,
          headers: {
            "Content-Type": "application/json",
          },
          body: json.encode(
            {
              "name": _enteredName,
              "quantity": _enteredQuantity,
              "category": _selectedCategory.title,
            },
          ),
        );

        if (response.statusCode == 200) {
          final Map<String, dynamic> resData = json.decode(response.body);

          if (!context.mounted) return;

          Navigator.of(context).pop(
            GroceryItem(
              id: resData["name"],
              name: _enteredName,
              quantity: _enteredQuantity,
              category: _selectedCategory,
            ),
          );
        }
      } catch (err) {
        setState(() {
          _isSending = false;
        });

        CustomSnackbar(
          context: context,
          variant: SnackbarVariant.ERROR,
          text: "An error occured! Please try again.",
        ).showFeedback();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add a new item"),
        leading: TouchableOpacity(
          decoration: const BoxDecoration(),
          child: const Icon(Icons.arrow_back_ios),
          onTap: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                maxLength: 50,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  label: Text("Name"),
                ),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      value.trim().length <= 1 ||
                      value.trim().length > 50) {
                    return "Must be between 1 and 50 characters.";
                  }
                  return null;
                },
                onSaved: (value) {
                  _enteredName = value!;
                },
              ), // instead of TextField()
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        label: Text("Quantity"),
                      ),
                      keyboardType: TextInputType.number,
                      initialValue: _enteredQuantity.toString(),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            int.tryParse(value) == null ||
                            int.tryParse(value)! <= 0) {
                          return "Must be a valid, positive number.";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _enteredQuantity = int.parse(value!);
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: DropdownButtonFormField(
                      value: _selectedCategory,
                      items: [
                        ...categories.entries.map(
                          (category) => DropdownMenuItem(
                            value: category.value,
                            child: Row(
                              children: [
                                Container(
                                  width: 16,
                                  height: 16,
                                  color: category.value.color,
                                ),
                                const SizedBox(width: 6),
                                Text(category.value.title),
                              ],
                            ),
                          ),
                        )
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedCategory = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 12,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AppTextButton(
                    onTap: () {
                      _formKey.currentState!.reset();
                    },
                    disabled: _isSending,
                    text: "Reset",
                  ),
                  const SizedBox(width: 16),
                  TouchableOpacity(
                    onTap: _saveItem,
                    disabled: _isSending,
                    child: _isSending
                        ? const SizedBox(
                            height: 16,
                            width: 16,
                            child: AppProgressIndicator(),
                          )
                        : const Text("Add Item"),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
