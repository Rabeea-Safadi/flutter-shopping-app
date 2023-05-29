import 'package:flutter/material.dart';
import 'package:shopping_app/models/grocery_item.dart';

class GroceryRow extends StatelessWidget {
  const GroceryRow({super.key, required this.item});

  final GroceryItem item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Row(
        children: [
          Icon(
            Icons.square,
            color: item.category.color,
            size: 25,
          ),
          const SizedBox(width: 25),
          Text(item.name, style: const TextStyle(fontSize: 18)),
          const Spacer(),
          Text(item.quantity.toString(), style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}
