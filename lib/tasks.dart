import 'package:flutter/material.dart';
import 'package:zrub/projects.dart' as projPage;
import 'classes.dart';
import 'edit_task.dart' as editTaskPage;
import 'add_task.dart';

int getSelectedTask() {
  return _MyTasksPageState.selectedTask;
}

void setSelectedTask(int n) {
  _MyTasksPageState.selectedTask = n;
}

class MyTasksPage extends StatefulWidget {
  @override
  _MyTasksPageState createState() => _MyTasksPageState();
}

class _MyTasksPageState extends State<MyTasksPage> {
  static int selectedTask = 0;
  bool _displayDone = false;
  String selectedProjTitle =
      sprojs.items[projPage.getSelectedProject()].projTitle;

  _saveToStorage() {
    storage.setItem('projects', sprojs.toJson());
  }

  _deleteTask() {
    setState(() {
      sprojs.items[projPage.getSelectedProject()].projTasks
          .removeAt(selectedTask);
      selectedTask = 0;
    });
    _saveToStorage();
  }

  void _displayCurrentTasks() {
    setState(() {
      _displayDone = false;
    });
  }

  void _displayDoneTasks() {
    setState(() {
      _displayDone = true;
    });
  }

  List<Widget> _getTasksWidgets(bool done, List<Task> tasks) {
    List<Widget> tasksWidgets = [];

    for (int i = 0; i < tasks.length; i++) {
      if (tasks[i].taskIsDone == done) {
        tasksWidgets.add(
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              primary: Colors.white,
              backgroundColor:
                  selectedTask == i ? Colors.blue.shade900 : Colors.blue,
              textStyle: TextStyle(
                fontSize: selectedTask == i ? 20 : 17,
              ),
              padding: const EdgeInsets.all(20.0),
            ),
            onPressed: () {
              setState(() {
                selectedTask = i;
              });
            },
            child: Text(tasks[i].taskTitle),
          ),
        );
        tasksWidgets
            .add(Padding(padding: const EdgeInsets.symmetric(vertical: 3.0)));
      }
    }

    return tasksWidgets;
  }

  List<Widget> _getTaskInfo(bool done, Task task) {
    return [
      Text(
        task.taskTitle,
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
      Text(task.taskDesc,
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
        value: task.taskProgress,
        minHeight: 20.0,
      ),
      Padding(padding: const EdgeInsets.all(10.0)),
      Text('Tagi',
          style: TextStyle(
            fontSize: 24,
          )),
      Padding(padding: const EdgeInsets.all(4.0)),
      Text(_getTaskTags(task),
          style: TextStyle(
            fontSize: 20,
          ))
    ];
  }

  String _getTaskTags(Task task) {
    String tags = '';

    for (int i = 0; i < task.taskTags.length; i++) {
      tags += task.taskTags[i] + ' ';
    }
    return tags;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Lista zadań - $selectedProjTitle'),
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
                        'zadania',
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
                              _displayCurrentTasks();
                            },
                            child: Text('Aktualne')),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: _displayDone == true
                                  ? Colors.grey.shade800
                                  : Colors.grey,
                            ),
                            onPressed: () {
                              _displayDoneTasks();
                            },
                            child: Text('Zakończone')),
                      ],
                    ),
                    Padding(padding: const EdgeInsets.all(10.0)),
                    FutureBuilder(
                      future: storage.ready,
                      builder: (context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
                          return Expanded(
                              child: ListView(
                                  children: _getTasksWidgets(
                                      _displayDone,
                                      sprojs
                                          .items[projPage.getSelectedProject()]
                                          .projTasks)));
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
                  future: storage.ready,
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      return Container(
                          padding: const EdgeInsets.all(8.0),
                          child: ListView(
                              children: _getTaskInfo(
                                  _displayDone,
                                  sprojs.items[projPage.getSelectedProject()]
                                      .projTasks[selectedTask])));
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }
                    return Container(
                        alignment: Alignment.center,
                        child: CircularProgressIndicator());
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
                              .pushNamed('/addTask')
                              .then((value) => setState(() {}));
                          ;
                        },
                        child: Text('Dodaj zadanie')),
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.of(context)
                              .pushNamed('/editTask')
                              .then((value) => setState(() {}));
                          ;
                        },
                        child: Text('Edytuj zadanie')),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          _deleteTask();
                        },
                        child: Text('Usuń zadanie')),
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                    ),
                    //_endTaskButton() TU MUSI BYC FUTURE BUILDER w calej kolumnie
                  ],
                ),
              ),
            ]));
  }
}
