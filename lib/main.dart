import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'projects.dart';
import 'tasks.dart';
import 'edit_project.dart';
import 'edit_task.dart';

void main() {
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
