import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/item.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  // 🔗 Register adapter
  Hive.registerAdapter(ItemAdapter());

  // 📦 Open box
  await Hive.openBox<Item>('itemsBox');

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      // 🎨 Theme (fixed version)
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
        ),
        useMaterial3: true,
      ),

      home: HomeScreen(),
    );
  }
}
