import 'package:flutter/material.dart';
import 'package:shopping_app/data/dummy_data.dart';
import 'package:shopping_app/models/category.dart';
import 'package:shopping_app/models/grocery_item.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Groceries',
      theme: ThemeData.dark().copyWith(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 147, 229, 250),
          brightness: Brightness.dark,
          surface: const Color.fromARGB(255, 42, 51, 59),
        ),
        scaffoldBackgroundColor: const Color.fromARGB(255, 50, 58, 60),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Your Groceries'),
        ),
        body: GroceryList(grocerices: groceryItems),
      ),
    );
  }
}

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

class GroceryList extends StatelessWidget {
  const GroceryList({super.key, required this.grocerices});

  final List<GroceryItem> grocerices;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: grocerices.length,
      itemBuilder: (context, index) {
        return ListTile(
          onTap: () {},
          title: Text(grocerices[index].name),
          leading: Container(
            width: 24,
            height: 24,
            color: grocerices[index].category.color,
          ),
          trailing: Text(grocerices[index].quantity.toString()),
        );
      },
    );
  }
}
