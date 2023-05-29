import 'package:flutter/material.dart';
import 'package:shopping_app/models/grocery_item.dart';

class GroceryList extends StatelessWidget {
  const GroceryList({super.key, required this.grocerices, required this.onDeleteItem});

  final List<GroceryItem> grocerices;
  final void Function(GroceryItem) onDeleteItem;

  void _dismissItem(GroceryItem item) {
    onDeleteItem(item);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: grocerices.length,
      itemBuilder: (context, index) {
        return Dismissible(
          background: Container(
            width: double.infinity,
            color: Colors.red,
          ),
          key: ValueKey(grocerices[index].id),
          onDismissed: (direction) => _dismissItem(grocerices[index]),
          child: ListTile(
            title: Text(grocerices[index].name),
            leading: Container(
              width: 24,
              height: 24,
              color: grocerices[index].category.color,
            ),
            trailing: Text(grocerices[index].quantity.toString()),
          ),
        );
      },
    );
  }
}
