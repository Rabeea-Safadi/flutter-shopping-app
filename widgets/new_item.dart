import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shopping_app/data/categories.dart';
import 'package:shopping_app/models/category.dart';
import 'package:http/http.dart' as http;
import 'package:shopping_app/models/grocery_item.dart';

class NewItem extends StatefulWidget {
  const NewItem({super.key});

  @override
  State<NewItem> createState() => _NewItemState();
}

class _NewItemState extends State<NewItem> {
  final apiUrl = Uri.https('flutter-prep-f2b4a-default-rtdb.firebaseio.com', 'shopping-list.json');
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String _name;
  late int _quantity;
  Categories _category = Categories.other;
  bool _isProcessing = false;

  void _saveItem() async {
    final bool isItemValid = _formKey.currentState!.validate();

    if (!isItemValid) return;

    _formKey.currentState!.save();

    setState(() {
      _isProcessing = true;
    });
    final response = await http.post(
      apiUrl,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'name': _name,
        'quantity': _quantity,
        'category': _category.name,
      }),
    );

    if (!context.mounted) {
      return;
    }

    setState(() {
      _isProcessing = false;
    });
    final Map<String, dynamic> resData = json.decode(response.body);
    Navigator.of(context).pop(GroceryItem(
      id: resData['name'],
      name: _name,
      quantity: _quantity,
      category: categories[_category]!,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return getContent();
  }

  Widget getContent() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              maxLength: 50,
              decoration: const InputDecoration(
                label: Text('Name'),
              ),
              validator: (value) {
                if (value == null || value.isEmpty || value.trim().length <= 1 || value.trim().length > 50) {
                  return 'Name must be between 1 and 50 characters.';
                }

                return null;
              },
              onSaved: (newTitle) {
                _name = newTitle!;
              },
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      label: Text('Quantity'),
                    ),
                    initialValue: '1',
                    validator: (value) {
                      if (value == null || value.isEmpty || int.tryParse(value) == null || int.tryParse(value)! <= 0) {
                        return 'Quantity must a positive number.';
                      }

                      return null;
                    },
                    onSaved: (newQuantity) {
                      _quantity = int.tryParse(newQuantity!)!;
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButtonFormField(
                    value: _category,
                    onSaved: (newCategory) {
                      _category = newCategory!;
                    },
                    items: [
                      for (final category in categories.entries)
                        DropdownMenuItem(
                            value: category.key,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.square,
                                  color: category.value.color,
                                  size: 16,
                                ),
                                const SizedBox(width: 6),
                                Text(category.value.category),
                              ],
                            )),
                    ],
                    onChanged: (newCategory) {
                      setState(() {
                        _category = newCategory!;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: _isProcessing
                      ? null
                      : () {
                          _formKey.currentState!.reset();
                        },
                  child: const Text('Reset'),
                ),
                ElevatedButton(
                  onPressed: _isProcessing ? null : _saveItem,
                  child: _isProcessing
                      ? const SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(),
                        )
                      : const Text('Add Item'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
