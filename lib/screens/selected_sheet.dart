import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/item.dart';

class SelectedSheet extends StatelessWidget {
  final box = Hive.box<Item>('itemsBox');

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: ValueListenableBuilder(
        valueListenable: box.listenable(),
        builder: (_, Box<Item> box, __) {
          final selectedItems =
              box.values.where((item) => item.isSelected).toList();

          if (selectedItems.isEmpty) {
            return Center(child: Text("No items selected"));
          }

          return ListView.builder(
            itemCount: selectedItems.length,
            itemBuilder: (_, index) {
              final item = selectedItems[index];

              return Card(
                child: ListTile(
                  title: Text(item.name),
                  trailing: IconButton(
                    icon: Icon(Icons.remove_circle),
                    onPressed: () {
                      item.isSelected = false;
                      item.save();
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
