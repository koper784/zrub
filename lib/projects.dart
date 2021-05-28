import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:zrub/classes.dart';
import 'package:zrub/tasks.dart' as taskPage;
import 'dart:convert';

int getSelectedProject() {
  return _MyProjectsPageState.selectedProject;
}

void setSelectedProject(int n) {
  _MyProjectsPageState.selectedProject = n;
}

Future<List<Project>> getProjectAsset() async {
  return await _MyProjectsPageState.loadProjects();
}

class MyProjectsPage extends StatefulWidget {
  @override
  _MyProjectsPageState createState() => _MyProjectsPageState();
}

class _MyProjectsPageState extends State<MyProjectsPage> {
  static int selectedProject = 0;

  bool _displayDone = false;

  static Future<String> _loadProjectAsset() async {
    return await rootBundle.loadString('assets/sample_data.json');
  }

  static Future<List<Project>> loadProjects() async {
    //await wait(5);
    List<Project> projects = [];

    String jsonString = await _loadProjectAsset();
    final jsonResponse = json.decode(jsonString);
    for (int i = 0; i < jsonResponse.length; i++) {
      projects.add(new Project.fromJson(jsonResponse[i]));
    }
    return projects;
  }

  Widget _endProjButton(Project proj) {
    return ElevatedButton(
        onPressed: () {},
        child: Text(
          proj.projIsDone == true ? 'Wznów projekt' : 'Zakończ projekt',
        ));
  }

  List<Widget> _getProjectsWidgets(bool done, List<Project> projects) {
    List<Widget> projectsWidgets = [];

    for (int i = 0; i < projects.length; i++) {
      if (projects[i].projIsDone == done) {
        projectsWidgets.add(
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              primary: Colors.white,
              backgroundColor:
                  selectedProject == i ? Colors.blue.shade900 : Colors.blue,
              textStyle: TextStyle(
                fontSize: selectedProject == i ? 20 : 17,
              ),
              padding: const EdgeInsets.all(20.0),
            ),
            onPressed: () {
              setState(() {
                selectedProject = i;
                taskPage.setSelectedTask(0);
              });
            },
            child: Text(projects[i].projTitle),
          ),
        );
        projectsWidgets
            .add(Padding(padding: const EdgeInsets.symmetric(vertical: 3.0)));
      }
    }
    return projectsWidgets;
  }

  void _displayCurrentProjects() {
    setState(() {
      _displayDone = false;
    });
  }

  void _displayDoneProjects() {
    setState(() {
      _displayDone = true;
    });
  }

  List<Widget> _getProjInfo(bool done, Project proj) {
    return [
      Text(
        proj.projTitle,
        style: TextStyle(
          fontSize: 30,
        ),
      ),
      Padding(padding: const EdgeInsets.all(10.0)),
      Text('Opis',
          style: TextStyle(
            fontSize: 24,
          )),
      Padding(padding: const EdgeInsets.all(4.0)),
      Text(proj.projDesc,
          style: TextStyle(
            fontSize: 20,
          )),
      Padding(padding: const EdgeInsets.all(10.0)),
      Text('Postęp',
          style: TextStyle(
            fontSize: 24,
          )),
      Padding(padding: const EdgeInsets.all(4.0)),
      LinearProgressIndicator(
        value: proj.projProgress,
        minHeight: 20.0,
      ),
      Padding(padding: const EdgeInsets.all(10.0)),
      Text('Tagi',
          style: TextStyle(
            fontSize: 24,
          )),
      Padding(padding: const EdgeInsets.all(4.0)),
      Text(_getProjTags(proj),
          style: TextStyle(
            fontSize: 20,
          ))
    ];
  }

  String _getProjTags(Project proj) {
    List<String> tempTags = [];
    String tags = '';

    for (int i = 0; i < proj.projTasks.length; i++) {
      for (int j = 0; j < proj.projTasks[i].taskTags.length; j++) {
        tempTags.add(proj.projTasks[i].taskTags[j]);
      }
    }

    tempTags = tempTags.toSet().toList();

    for (int i = 0; i < tempTags.length; i++) {
      tags += tempTags[i] + ' ';
    }

    return tags;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Lista projektów - Zrub'),
        ),
        body: Row(
            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                width: 250.0,
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                color: Color(0xff83b0f7),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        'projekty',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              _displayCurrentProjects();
                            },
                            child: Text('Aktualne')),
                        ElevatedButton(
                            onPressed: () {
                              _displayDoneProjects();
                            },
                            child: Text('Zakończone')),
                      ],
                    ),
                    Padding(padding: const EdgeInsets.all(10.0)),
                    FutureBuilder(
                      future: loadProjects(),
                      builder:
                          (context, AsyncSnapshot<List<Project>> snapshot) {
                        List<Project> projects = snapshot.data ?? [];
                        if (snapshot.hasData) {
                          return Expanded(
                              child: ListView(
                                  children: _getProjectsWidgets(
                                      _displayDone, projects)));
                        } else if (snapshot.hasError) {
                          return Text("${snapshot.error}");
                        }
                        return CircularProgressIndicator();
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: FutureBuilder(
                  future: loadProjects(),
                  builder: (context, AsyncSnapshot<List<Project>> snapshot) {
                    List<Project> projects = snapshot.data ?? [];
                    if (snapshot.hasData) {
                      return Container(
                          padding: const EdgeInsets.all(8.0),
                          child: ListView(
                              children: _getProjInfo(
                                  _displayDone, projects[selectedProject])));
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }
                    return CircularProgressIndicator();
                  },
                ),
              ),
              Container(
                width: 250.0,
                color: Color(0xffc9c9c9),
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        'narzędzia',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: TextField(
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Wpisz tagi'),
                        )),
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                    ),
                    ElevatedButton(onPressed: () {}, child: Text('Szukaj')),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                    ),
                    ElevatedButton(
                        onPressed: () {}, child: Text('Dodaj projekt')),
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                    ),
                    ElevatedButton(
                        onPressed: () {}, child: Text('Usuń projekt')),
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                    ),
                    ElevatedButton(
                        onPressed: () {}, child: Text('Idź do zadań')),
                    //_endProjButton() TU MUSI BYC FUTURE BUILDER w calej kolumnie
                  ],
                ),
              ),
            ]));
  }
}
