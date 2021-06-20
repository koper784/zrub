import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zrub/projects.dart' as projPage;
import 'classes.dart';

class MyAddTaskPage extends StatefulWidget {
  @override
  _MyAddTaskPageState createState() => _MyAddTaskPageState();
}

class _MyAddTaskPageState extends State<MyAddTaskPage> {
  bool validateTags(String str) {
    str += ' ';
    RegExp exp = RegExp(r"^#\w+$");
    String word = "";
    List<String> words = [];

    for (int i = 0; i < str.length; i++) {
      if (str[i] == ' ') {
        if (word == "") continue;
        words.add(word);
        word = "";
      } else if (str[i] != ' ') word += str[i];
    }
    if (words.length == 0) return false;
    for (String w in words) {
      if (!exp.hasMatch(w)) return false;
    }
    return true;
  }

  String title = '';
  String desc = '';
  List<String> tags = [];

  Task task = Task(
      taskDesc: 'Opis...',
      taskIsDone: false,
      taskProgress: 0.0,
      taskTags: ['#dsds'],
      taskTitle: 'Puste zadanie');

  List<String> stringToTags(String str) {
    str += ' ';
    List<String> tags = [];
    String word = "";

    for (int i = 0; i < str.length; i++) {
      if (str[i] == ' ') {
        if (word == "") continue;
        tags.add(word);
        word = "";
      } else if (str[i] != ' ') {
        word += str[i];
      }
    }

    return tags;
  }

  _saveToStorage() {
    storage.setItem('projects', sprojs.toJson());
  }

  _addTask(Task task) {
    setState(() {
      sprojs.items[projPage.getSelectedProject()].projTasks.add(task);
      _saveToStorage();
    });
  }

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
                  } else {
                    title = value;
                    return null;
                  }
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
                  } else {
                    desc = value;
                    return null;
                  }
                },
              ),
              TextFormField(
                initialValue: _getTaskTags(task),
                decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Tagi',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty || !validateTags(value)) {
                    return 'Zadanie musi zawierać conajmniej jeden tag, wszystkie tagi muszą być poprawne "#tag"';
                  } else {
                    tags = stringToTags(value);
                    return null;
                  }
                },
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: ElevatedButton(
                  child: Text('Dodaj'),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      task.taskDesc = desc;
                      task.taskTitle = title;
                      task.taskTags = tags;
                      _addTask(task);
                      projPage.setProgresses();
                      Navigator.pop(context);
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
