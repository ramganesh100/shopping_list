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
    seedData();
  }

  void seedData() {
    if (box.isEmpty) {
      final categories = ['A', 'B', 'C'];

      for (int i = 1; i <= 100; i++) {
        box.add(Item(
          name: "Item $i",
          category: categories[i % 3],
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pro Item Selector"),
      ),

      body: ValueListenableBuilder(
        valueListenable: box.listenable(),
        builder: (context, Box<Item> box, _) {
          final items = box.values.toList();

          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (_, index) {
              final item = items[index];

              return ListTile(
                title: Text(item.name),
                subtitle: Text("Category ${item.category}"),

                trailing: Icon(
                  item.isSelected
                      ? Icons.check_circle
                      : Icons.circle_outlined,
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

      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.shopping_cart),
        label: Text("Selected"),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (_) => SelectedSheet(),
          );
        },
      ),
    );
  }
}