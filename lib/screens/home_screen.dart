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

  final List<String> groups = ["Kitchen", "Bathroom", "Cleaning", "Other"];

  @override
  void initState() {
    super.initState();
    box = Hive.box<Item>('itemsBox');
    seedDefaultItems();
  }

  // 🔥 Default items (close to 100 total)
  void seedDefaultItems() {
    if (box.isNotEmpty) return;

    final data = {
      "Kitchen": [
        "Rice",
        "Wheat Flour",
        "Sugar",
        "Salt",
        "Oil",
        "Turmeric",
        "Chili Powder",
        "Cumin",
        "Mustard Seeds",
        "Tea",
        "Coffee",
        "Milk",
        "Ghee",
        "Butter",
        "Onion",
        "Potato",
        "Garlic",
        "Ginger",
        "Tomato",
        "Green Chili",
        "Paneer",
        "Curd",
        "Lentils",
        "Beans",
        "Peas"
      ],
      "Bathroom": [
        "Soap",
        "Shampoo",
        "Toothpaste",
        "Toothbrush",
        "Facewash",
        "Comb",
        "Hair Oil",
        "Towel",
        "Razor",
        "Shaving Cream",
        "Bucket",
        "Mug"
      ],
      "Cleaning": [
        "Detergent",
        "Dishwash",
        "Scrubber",
        "Floor Cleaner",
        "Broom",
        "Mop",
        "Dust Cloth",
        "Trash Bags",
        "Phenyl",
        "Glass Cleaner"
      ],
      "Other": [
        "Notebook",
        "Pen",
        "Batteries",
        "Charger",
        "Extension Board",
        "Light Bulb",
        "Umbrella",
        "Matches",
        "Candles",
        "Tape"
      ]
    };

    data.forEach((group, items) {
      for (var name in items) {
        box.add(Item(name: name, group: group));
      }
    });
  }

  // ➕ Add item
  void addItem(String group) {
    if (box.length >= 100) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Limit reached (100 items)")),
      );
      return;
    }

    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text("Add to $group"),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: "Item name"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (controller.text.trim().isNotEmpty) {
                  box.add(Item(
                    name: controller.text.trim(),
                    group: group,
                  ));
                }
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
      appBar: AppBar(title: Text("Grouped Item Selector")),
      body: ValueListenableBuilder(
        valueListenable: box.listenable(),
        builder: (context, Box<Item> box, _) {
          return ListView(
            children: groups.map((group) {
              final items =
                  box.values.where((item) => item.group == group).toList();

              return ExpansionTile(
                title: Text(group),
                children: [
                  ...items.map((item) => ListTile(
                        title: Text(item.name),
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
                      )),

                  // ➕ Add button per group
                  TextButton.icon(
                    onPressed: () => addItem(group),
                    icon: Icon(Icons.add),
                    label: Text("Add Item"),
                  ),
                ],
              );
            }).toList(),
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
