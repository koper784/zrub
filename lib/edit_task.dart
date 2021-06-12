import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zrub/projects.dart' as projPage;
import 'package:zrub/tasks.dart' as taskPage;
import 'classes.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class MyEditTaskPage extends StatefulWidget {
  @override
  _MyEditTaskPageState createState() => _MyEditTaskPageState();
}

class _MyEditTaskPageState extends State<MyEditTaskPage> {
  @override
  void initState() {
    getSelProjTitle();
    super.initState();
    //teoretycznie moge tutaj wszystko wczytywac zamiast robic future buildery
  }

  int dropdownDay = 1;
  int dropdownMonth = 1;
  int dropdownYear = 2021;
  String editPageTitle = '';

  late List<Project> projects;
  late Project proj = projects[projPage.getSelectedProject()];

  void getSelProjTitle() async {
    List<Project> projs = await projPage.getProjectAsset();
    setState(() {
      editPageTitle = projs[projPage.getSelectedProject()]
          .projTasks[taskPage.getSelectedTask()]
          .taskTitle;
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

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/dzejson.json');
  }

  Future<File> writeJson(String data) async {
    final file = await _localFile;

    return file.writeAsString(data);
  }

  Widget loadForm() {
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
                  }
                  return null;
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
                  }
                  return null;
                },
              ),
              Slider(
                value: proj.projTasks[taskPage.getSelectedTask()].taskProgress,
                onChanged: (newProgress) {
                  setState(() => proj.projTasks[taskPage.getSelectedTask()]
                      .taskProgress = newProgress);
                },
                label: proj.projTasks[taskPage.getSelectedTask()].taskProgress
                    .round()
                    .toString(),
                max: 100.0,
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
                    return 'Zadanie musi zawierać conajmniej jeden tag i wszystkie tagi muszą być poprawne "#tag"';
                  }
                  return null;
                },
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: ElevatedButton(
                  child: Text('Zapisz'),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        projects[projPage.getSelectedProject()] = proj;
                        writeJson(jsonEncode(projects));
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
        future: projPage.getProjectAsset(),
        builder: (context, AsyncSnapshot<List<Project>> snapshot) {
          projects = snapshot.data ?? [];
          if (snapshot.hasData) {
            return loadForm();
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
