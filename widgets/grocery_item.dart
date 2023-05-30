import 'package:flutter/material.dart';
import 'package:shopping_app/models/grocery_item.dart';
import 'package:http/http.dart' as http;

class GroceryList extends StatelessWidget {
  const GroceryList({super.key, required this.grocerices, required this.onDeleteItem});

  final List<GroceryItem> grocerices;
  final void Function(GroceryItem) onDeleteItem;

  void _dismissItem(BuildContext context, GroceryItem item) async {
    final apiUrl = Uri.https('flutter-prep-f2b4a-default-rtdb.firebaseio.com', 'shopping-list/${item.id}.json');
    await http.delete(apiUrl);
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
          onDismissed: (direction) => _dismissItem(context, grocerices[index]),
          confirmDismiss: (direction) async {
            bool isConfirmed = false;

            await showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text(
                    'Delete',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                    ),
                  ),
                  content: const Text(
                    'Are you sure?',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  actions: [
                    OutlinedButton(
                      onPressed: () {
                        isConfirmed = true;
                        Navigator.of(context).pop();
                      },
                      child: const Text('Yes'),
                    ),
                    OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('No'),
                    ),
                  ],
                );
              },
            );

            print('isConfirmed: $isConfirmed');
            return isConfirmed;
          },
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
