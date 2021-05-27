import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:zrub/classes.dart';
import 'dart:convert';

class MyProjectsPage extends StatefulWidget {
  @override
  _MyProjectsPageState createState() => _MyProjectsPageState();
}

class _MyProjectsPageState extends State<MyProjectsPage> {
  int _selectedProject = 0;
  int _selectedTask = 0;
  bool _displayDone = false;

  Future<String> _loadProjectAsset() async {
    return await rootBundle.loadString('assets/sample_data.json');
  }

  Future<List<Project>> _loadProjects() async {
    //await wait(5);
    List<Project> projects = [];

    String jsonString = await _loadProjectAsset();
    final jsonResponse = json.decode(jsonString);
    for (int i = 0; i < jsonResponse.length; i++) {
      projects.add(new Project.fromJson(jsonResponse[i]));
    }
    return projects;
  }

  List<Widget> _getProjectsWidgets(
      bool done, AsyncSnapshot<List<Project>> snap) {
    List<Project> projects = snap.data ?? [];
    List<Widget> projectsWidgets = [];

    for (int i = 0; i < projects.length; i++) {
      if (projects[i].projIsDone == done) {
        projectsWidgets.add(
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              primary: Colors.white,
              backgroundColor:
                  _selectedProject == i ? Colors.blue.shade900 : Colors.blue,
              textStyle: TextStyle(
                fontSize: _selectedProject == i ? 20 : 17,
              ),
              padding: const EdgeInsets.all(20.0),
            ),
            onPressed: () {
              setState(() {
                _selectedProject = i;
                _selectedTask = 0; //zrob settera w tasku
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

  //jeszcze get all tags jako przyciski??

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
                      future: _loadProjects(),
                      builder:
                          (context, AsyncSnapshot<List<Project>> snapshot) {
                        if (snapshot.hasData) {
                          return Expanded(
                              child: ListView(
                                  children: _getProjectsWidgets(
                                      _displayDone, snapshot)));
                        } else if (snapshot.hasError) {
                          return Text("${snapshot.error}");
                        }
                        return CircularProgressIndicator();
                      },
                    ),
                    /*Expanded(
                      child: ListView(
                        //padding: const EdgeInsets.all(10.0),
                        children: _getProjects(),
                      ),
                    ),*/
                    Container(
                        padding: const EdgeInsets.all(5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FloatingActionButton(
                              onPressed: () {},
                              child: const Icon(Icons.add_box),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(2.0),
                            ),
                            FloatingActionButton(
                              onPressed: () {},
                              child: const Icon(Icons.delete),
                            )
                          ],
                        ))
                  ],
                ),
              ),
            ]));
  }
}
