import 'package:hive/hive.dart';

part 'item.g.dart';

@HiveType(typeId: 0)
class Item extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  bool isSelected;

  @HiveField(2)
  String group;

  Item({
    required this.name,
    required this.group,
    this.isSelected = false,
  });
}
