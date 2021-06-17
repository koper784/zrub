import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zrub/projects.dart' as projPage;
import 'package:zrub/tasks.dart' as taskPage;
import 'classes.dart';
import 'package:localstorage/localstorage.dart';

class MyAddTaskPage extends StatefulWidget {
  @override
  _MyAddTaskPageState createState() => _MyAddTaskPageState();
}

class _MyAddTaskPageState extends State<MyAddTaskPage> {
  final LocalStorage storage = new LocalStorage('projects');

  Task task = Task(
      taskDesc: 'Opis...',
      taskIsDone: false,
      taskProgress: 0.0,
      taskTags: [],
      taskTitle: 'Puste zadanie');

  int dropdownDay = 1;
  int dropdownMonth = 1;
  int dropdownYear = 2021;
  String editPageTitle = '';

  String _getTaskTags(Task task) {
    String tags = '';

    for (int i = 0; i < task.taskTags.length; i++) {
      tags += task.taskTags[i] + ' ';
    }
    return tags;
  }

  final _formKey = GlobalKey<FormState>();

  Widget loadForm(Task task) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                initialValue: task.taskTitle,
                decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Nazwa zadania',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty || value.contains('"')) {
                    return 'Nazwa nie może być pusta i nie może zawierać cudzysłowu.';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: task.taskDesc,
                keyboardType: TextInputType.multiline,
                minLines: 1,
                maxLines: 10,
                decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Opis projektu',
                ),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      value.contains('"') ||
                      value.length > 1000) {
                    return 'Opis nie może być pusty, musi być krótszy niż 1000 znaków i nie może zawierać cudzysłowu.';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: _getTaskTags(task),
                decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Tagi',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty || value.contains('"')) {
                    //ZROBIC WALIDACJE REGEXEM
                    return 'Zadanie musi zawierać conajmniej jeden tag, wszystkie tagi muszą być poprawne "#tag"';
                  }
                  return null;
                },
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: ElevatedButton(
                  child: Text('Dodaj'),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('poprawnie'),
                      ));
                    }
                  },
                ),
              ),
            ],
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edytuj - $editPageTitle'),
      ),
      body: loadForm(task),
    );
  }
}
