import 'package:flutter/material.dart';
import 'projects.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zrub',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyProjectsPage(),
    );
  }
}
