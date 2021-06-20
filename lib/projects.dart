import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'classes.dart';
import 'package:zrub/tasks.dart' as taskPage;
import 'dart:convert';
import 'edit_project.dart' as editProjPage;
import 'add_project.dart';
import 'package:localstorage/localstorage.dart';

int getSelectedProject() {
  return _MyProjectsPageState.selectedProject;
}

void setSelectedProject(int n) {
  _MyProjectsPageState.selectedProject = n;
}

setProgresses() {
  for (int i = 0; i < sprojs.items.length; i++) {
    sprojs.items[i].setProgress();
  }
}

Future<List<Project>> getProjectAsset() async {
  return await _MyProjectsPageState.loadProjects();
}

class MyProjectsPage extends StatefulWidget {
  @override
  _MyProjectsPageState createState() => _MyProjectsPageState();
}

class _MyProjectsPageState extends State<MyProjectsPage> {
  @override
  void initState() {
    super.initState();
  }

  List<Project> projects = [];
  //List<Project> projectsToSave = [];
  bool initialized = false;

  static int selectedProject = 0;

  bool _displayDone = false;

  static Future<String> _loadProjectAsset() async {
    return await rootBundle.loadString('assets/sample_data.json');
  }

  static Future wait(int seconds) {
    return new Future.delayed(Duration(seconds: seconds), () => {});
  }

  static Future<List<Project>> loadProjects() async {
    //await wait(1);
    List<Project> projects = [];

    String jsonString = await _loadProjectAsset();
    final jsonResponse = json.decode(jsonString);
    for (int i = 0; i < jsonResponse.length; i++) {
      projects.add(new Project.fromJson(jsonResponse[i]));
    }
    return projects;
  }

  _saveToStorage() {
    storage.setItem('projects', sprojs.toJson());
  }

  _deleteProj() {
    setState(() {
      sprojs.items.removeAt(selectedProject);
      selectedProject = 0;
    });
    _saveToStorage();
  }

  Widget _endProjButton() {
    return ElevatedButton(
        onPressed: () {
          setState(() {
            sprojs.items[selectedProject].projIsDone =
                !sprojs.items[selectedProject].projIsDone;
            _saveToStorage();
          });
        },
        child: Text(
          sprojs.items[selectedProject].projIsDone == true
              ? 'Wznów projekt'
              : 'Zakończ projekt',
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
          title: Text('Lista projektów'),
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
                            style: ElevatedButton.styleFrom(
                              primary: _displayDone == false
                                  ? Colors.grey.shade800
                                  : Colors.grey,
                            ),
                            onPressed: () {
                              _displayCurrentProjects();
                            },
                            child: Text('Aktualne')),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: _displayDone == true
                                  ? Colors.grey.shade800
                                  : Colors.grey,
                            ),
                            onPressed: () {
                              _displayDoneProjects();
                            },
                            child: Text('Zakończone')),
                      ],
                    ),
                    Padding(padding: const EdgeInsets.all(10.0)),
                    FutureBuilder(
                        future: storage.ready,
                        builder: (context, AsyncSnapshot snapshot) {
                          if (snapshot.hasData) {
                            if (!initialized) {
                              var items = storage.getItem('projects');
                              if (items != null) {
                                sprojs.items = List<Project>.from(
                                    items.map((x) => Project.fromJson(x)));
                              }
                            }
                            initialized = true;

                            return Expanded(
                                child: ListView(
                                    children: _getProjectsWidgets(
                                        _displayDone, sprojs.items)));
                          } else if (snapshot.hasError) {
                            return Text("${snapshot.error}");
                          }
                          return CircularProgressIndicator();
                        }),
                  ],
                ),
              ),
              Expanded(
                child: FutureBuilder(
                  future: storage.ready,
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData && sprojs.items.length > 0) {
                      return Container(
                          padding: const EdgeInsets.all(8.0),
                          child: ListView(
                              children: _getProjInfo(_displayDone,
                                  sprojs.items[selectedProject])));
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }
                    if (sprojs.items.length == 0) {
                      return Container(
                          alignment: Alignment.center,
                          child: Text('Nic tu nie ma'));
                    } else {
                      return Container(
                          alignment: Alignment.center,
                          child: CircularProgressIndicator());
                    }
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
                        onPressed: () {
                          Navigator.of(context)
                              .pushNamed('/addProj')
                              .then((value) => setState(() {}));
                        },
                        child: Text('Dodaj projekt')),
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.of(context)
                              .pushNamed('/editProj')
                              .then((value) => setState(() {}));
                        },
                        child: Text('Edytuj projekt')),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          _deleteProj();
                        },
                        child: Text('Usuń projekt')),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.of(context)
                              .pushNamed('/tasks')
                              .then((value) => setState(() {}));
                        },
                        child: Text('Idź do zadań')),
                    Padding(padding: const EdgeInsets.all(10.0)),
                    FutureBuilder(
                      future: storage.ready,
                      builder: (context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData && sprojs.items.length > 0) {
                          return _endProjButton();
                        } else if (snapshot.hasError) {
                          return Text("${snapshot.error}");
                        }
                        if (sprojs.items.length == 0) {
                          return Text('');
                        } else {
                          return Container(
                              alignment: Alignment.center,
                              child: CircularProgressIndicator());
                        }
                      },
                    ),
                  ],
                ),
              ),
            ]));
  }
}
