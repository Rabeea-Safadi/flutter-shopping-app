import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shopping_app/data/categories.dart';
import 'package:shopping_app/models/grocery_item.dart';
import 'package:shopping_app/widgets/grocery_item.dart';
import 'package:shopping_app/widgets/new_item.dart';
import 'package:http/http.dart' as http;

class ShoppingApp extends StatefulWidget {
  const ShoppingApp({super.key});

  @override
  State<ShoppingApp> createState() => _ShoppingAppState();
}

class _ShoppingAppState extends State<ShoppingApp> {
  List<GroceryItem> groceryList = [];
  bool _isLoading = true;
  String? _error;

  void _loadItems() async {
    final apiUrl = Uri.https('flutter-prep-f2b4a-default-rtdb.firebaseio.com', 'shopping-list.json');
    final response = await http.get(apiUrl);

    if (response.statusCode >= 400) {
      setState(() {
        _error = 'Failed to fetch data, please try again later.';
      });
      return;
    }

    final listData = json.decode(response.body);
    final List<GroceryItem> loadedItems = [];

    if (listData == null) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    for (final item in listData.entries) {
      final itemCategory = categories.entries.where((cat) => cat.key.name == item.value['category']).first;

      loadedItems.add(GroceryItem(
        id: item.key,
        name: item.value['name'],
        quantity: item.value['quantity'],
        category: itemCategory.value,
      ));
    }

    setState(() {
      groceryList = loadedItems;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  void _addItem() async {
    final newItem = await showModalBottomSheet(
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
      body: getContent(),
    );
  }

  Widget getContent() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_error != null) {
      return Text(_error!);
    }

    return groceryList.isNotEmpty
        ? GroceryList(grocerices: groceryList, onDeleteItem: deleteItem)
        : const Center(child: Text('No items...\nStart by tapping the add button'));
  }
}
