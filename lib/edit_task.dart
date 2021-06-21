import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zrub/projects.dart' as projPage;
import 'package:zrub/tasks.dart' as taskPage;
import 'classes.dart';

class MyEditTaskPage extends StatefulWidget {
  @override
  _MyEditTaskPageState createState() => _MyEditTaskPageState();
}

class _MyEditTaskPageState extends State<MyEditTaskPage> {
  String title = '';
  String desc = '';
  List<String> tags = [];

  String editPageTitle = sprojs.items[projPage.getSelectedProject()]
      .projTasks[taskPage.getSelectedTask()].taskTitle;

  _saveToStorage() {
    storage.setItem('projects', sprojs.toJson());
  }

  _editTask(Project proj) {
    setState(() {
      sprojs.items[projPage.getSelectedProject()]
              .projTasks[taskPage.getSelectedTask()] =
          proj.projTasks[taskPage.getSelectedTask()];
      sprojs.items[projPage.getSelectedProject()]
          .projTasks[taskPage.getSelectedTask()]
          .setDone();
      _saveToStorage();
    });
  }

  String _getTaskTags(Task task) {
    String tags = '';

    for (int i = 0; i < task.taskTags.length; i++) {
      tags += task.taskTags[i] + ' ';
    }
    return tags;
  }

  final _formKey = GlobalKey<FormState>();

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

  Widget loadForm(Project proj) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                initialValue:
                    proj.projTasks[taskPage.getSelectedTask()].taskTitle,
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
                initialValue:
                    proj.projTasks[taskPage.getSelectedTask()].taskDesc,
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
                      value.contains('"') || //wiadomo
                      value.length > 1000) {
                    return 'Opis nie może być pusty, musi być krótszy niż 1000 znaków i nie może zawierać cudzysłowu.';
                  } else {
                    desc = value;
                    return null;
                  }
                },
              ),
              Slider(
                value: sprojs.items[projPage.getSelectedProject()]
                    .projTasks[taskPage.getSelectedTask()].taskProgress,
                onChanged: (newProgress) {
                  setState(() => proj.projTasks[taskPage.getSelectedTask()]
                      .taskProgress = newProgress);
                },
                label: proj.projTasks[taskPage.getSelectedTask()].taskProgress
                    .toString(),
                max: 1.0,
                min: 0.0,
                divisions: 100,
              ),
              TextFormField(
                initialValue:
                    _getTaskTags(proj.projTasks[taskPage.getSelectedTask()]),
                decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Tagi',
                ),
                validator: (value) {
                  if (value == null || value == "" || !validateTags(value)) {
                    return 'Zadanie musi zawierać co najmniej jeden tag i wszystkie tagi muszą być poprawne "#tag"';
                  } else {
                    tags = stringToTags(value);
                    return null;
                  }
                },
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: ElevatedButton(
                  child: Text('Zapisz'),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        proj.projTasks[taskPage.getSelectedTask()].taskTitle =
                            title;
                        proj.projTasks[taskPage.getSelectedTask()].taskDesc =
                            desc;
                        proj.projTasks[taskPage.getSelectedTask()].taskTags =
                            tags;
                        _editTask(proj);
                        projPage.setProgresses();
                        Navigator.pop(context);
                      });
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
      body: FutureBuilder(
        future: storage.ready,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return loadForm(sprojs.items[projPage.getSelectedProject()]);
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
