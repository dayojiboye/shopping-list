import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shopping_list/constants/api.dart';
import 'package:shopping_list/constants/enums.dart';
import 'package:shopping_list/data/categories.dart';
import 'package:shopping_list/models/category.dart';
import 'package:shopping_list/models/grocery_item.dart';
import "package:http/http.dart" as http;
import 'package:shopping_list/utils/custom_snackbar.dart';
import 'package:shopping_list/widgets/app_text_button.dart';
import 'package:shopping_list/widgets/app_text_form_field.dart';
import 'package:shopping_list/widgets/categories_button.dart';
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
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
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
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: [
                AppTextFormField(
                  textCapitalization: TextCapitalization.words,
                  hintText: "Enter a name",
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
                ),
                const SizedBox(height: 16), // instead of TextField()
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: AppTextFormField(
                        hintText: "Enter a quantity",
                        maxLength: null,
                        initialValue: _enteredQuantity.toString(),
                        keyboardType: TextInputType.number,
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
                    CategoriesButton(
                      selectedCategory: _selectedCategory,
                      categories: categories,
                      onSelect: (value) {
                        setState(() {
                          _selectedCategory = value!;
                        });
                      },
                    )
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    AppTextButton(
                      onTap: () {
                        _formKey.currentState!.reset();
                        setState(() {
                          _selectedCategory =
                              categories[Categories.vegetables]!;
                        });
                      },
                      disabled: _isSending,
                      text: "Reset",
                    ),
                    const SizedBox(width: 16),
                    TouchableOpacity(
                      onTap: _saveItem,
                      disabled: _isSending,
                      loading: _isSending,
                      child: const Text(
                        "Add Item",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
