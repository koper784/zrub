import 'package:flutter/material.dart';
import 'package:zrub/add_project.dart';
import 'package:zrub/add_task.dart';
import 'package:zrub/edit_project.dart';
import 'package:zrub/edit_task.dart';
import 'package:zrub/tasks.dart';
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
      initialRoute: '/projects',
      routes: {
        '/projects': (context) => MyProjectsPage(),
        '/addProj': (context) => MyAddProjPage(),
        '/editProj': (context) => MyEditProjPage(),
        '/tasks': (context) => MyTasksPage(),
        '/addTask': (context) => MyAddTaskPage(),
        '/editTask': (context) => MyEditTaskPage()
      },
    );
  }
}
