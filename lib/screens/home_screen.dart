import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/item.dart';
import 'selected_sheet.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Box<Item> box;

  @override
  void initState() {
    super.initState();
    box = Hive.box<Item>('itemsBox');
  }

  void addItem(String name) {
    if (box.length >= 100) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Limit reached (100 items)")),
      );
      return;
    }

    if (name.trim().isEmpty) return;

    box.add(Item(name: name.trim()));
  }

  void showAddDialog() {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text("Add Item"),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: "Enter item name"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                addItem(controller.text);
                Navigator.pop(context);
              },
              child: Text("Add"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Item Selector (Max 100)"),
      ),

      body: ValueListenableBuilder(
        valueListenable: box.listenable(),
        builder: (context, Box<Item> box, _) {
          final items = box.values.toList();

          if (items.isEmpty) {
            return Center(child: Text("No items yet. Add some!"));
          }

          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (_, index) {
              final item = items[index];

              return ListTile(
                title: Text(item.name),
                trailing: Icon(
                  item.isSelected ? Icons.check_circle : Icons.circle_outlined,
                  color: item.isSelected ? Colors.green : null,
                ),
                onTap: () {
                  item.isSelected = !item.isSelected;
                  item.save();
                },
              );
            },
          );
        },
      ),

      // ➕ Add item
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "add",
            child: Icon(Icons.add),
            onPressed: showAddDialog,
          ),
          SizedBox(height: 10),
          FloatingActionButton.extended(
            heroTag: "selected",
            icon: Icon(Icons.shopping_cart),
            label: Text("Selected"),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (_) => SelectedSheet(),
              );
            },
          ),
        ],
      ),
    );
  }
}
