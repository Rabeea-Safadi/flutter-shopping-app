import 'package:flutter/material.dart';
import 'package:shopping_app/data/dummy_data.dart';
import 'package:shopping_app/models/grocery_item.dart';
import 'package:shopping_app/widgets/grocery_item.dart';
import 'package:shopping_app/widgets/new_item.dart';

class ShoppingApp extends StatefulWidget {
  const ShoppingApp({super.key});

  @override
  State<ShoppingApp> createState() => _ShoppingAppState();
}

class _ShoppingAppState extends State<ShoppingApp> {
  late final List<GroceryItem> groceryList = [];

  void _addItem() async {
    final GroceryItem newItem = await showModalBottomSheet(
      isScrollControlled: false,
      showDragHandle: true,
      useSafeArea: true,
      context: context,
      builder: (context) => const NewItem(),
    );

    setState(() {
      groceryList.add(newItem);
    });
  }

  void deleteItem(GroceryItem item) {
    setState(() {
      groceryList.remove(item);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Groceries'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addItem,
          ),
        ],
      ),
      body: groceryList.isNotEmpty
          ? GroceryList(grocerices: groceryList, onDeleteItem: deleteItem)
          : const Center(child: Text('No items...\nStart by tapping the add button')),
    );
  }
}
