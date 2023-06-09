import 'package:flutter/material.dart';
import 'package:shopping_app/data/categories.dart';
import 'package:shopping_app/models/category.dart';
import 'package:shopping_app/models/grocery_item.dart';

class NewItem extends StatefulWidget {
  const NewItem({super.key});

  @override
  State<NewItem> createState() => _NewItemState();
}

class _NewItemState extends State<NewItem> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String _name;
  late int _quantity;
  Categories _category = Categories.other;

  void _saveItem() {
    final bool isItemValid = _formKey.currentState!.validate();

    if (!isItemValid) return;

    _formKey.currentState!.save();

    Navigator.of(context).pop(GroceryItem(
      id: DateTime.now().toString(),
      name: _name,
      quantity: _quantity,
      category: categories[_category]!,
    ));
  }

  @override
  Widget build(BuildContext context) {
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
                  onPressed: () {
                    _formKey.currentState!.reset();
                  },
                  child: const Text('Reset'),
                ),
                ElevatedButton(
                  onPressed: _saveItem,
                  child: const Text('Add Item'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
