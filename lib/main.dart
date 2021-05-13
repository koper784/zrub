import 'package:flutter/material.dart';

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
      home: MyHomePage(title: 'Lista zadań - Zrub'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //zmienne i metody

  //tymczasowa zmienna z projektami
  List projects = [
    {
      'projectTitle': 'projekt A',
      'deadline': DateTime(2021, 10, 1),
      'progress': 0, //FUNKCJA ZEBY OBLICZAC NA PODSTAWIE % WYKONANIA ZADAN
      'tasks': [
        {
          'taskTitle': 'A zadanie 1',
          'description': 'to jest pierwsze zadanie projektu A',
          'begin': DateTime(2021, 1, 1),
          'end': DateTime(2021, 1, 3),
          'daysLeft':
              0, //ZROB JAKAS FUNKCJE ZEBY TO OBLICZAC I POKAZYWAC ILE DO KONCA ALBO ILE SPOZNIENIA
          'tags': [
            '#work',
            '#a',
            '#it',
          ]
        },
        {
          'taskTitle': 'A zadanie 2',
          'description': 'to jest drugie zadanie projektu A',
          'begin': DateTime(2021, 1, 3),
          'end': DateTime(2021, 1, 4),
          'daysLeft':
              0, //ZROB JAKAS FUNKCJE ZEBY TO OBLICZAC I POKAZYWAC ILE DO KONCA ALBO ILE SPOZNIENIA
          'tags': [
            '#stop',
            '#a',
            '#hehe',
          ]
        },
      ],
    },
    {
      'projectTitle': 'projekt B',
      'deadline': DateTime(2021, 10, 1),
      'progress': 0, //FUNKCJA ZEBY OBLICZAC NA PODSTAWIE % WYKONANIA ZADAN
      'tasks': [
        {
          'taskTitle': 'B zadanie 1',
          'description': 'to jest pierwsze zadanie projektu B',
          'begin': DateTime(2021, 1, 1),
          'end': DateTime(2021, 1, 3),
          'daysLeft':
              0, //ZROB JAKAS FUNKCJE ZEBY TO OBLICZAC I POKAZYWAC ILE DO KONCA ALBO ILE SPOZNIENIA
          'tags': [
            '#work',
            '#a',
            '#it',
          ]
        },
        {
          'taskTitle': 'B zadanie 2',
          'description': 'to jest drugie zadanie projektu B',
          'begin': DateTime(2021, 1, 3),
          'end': DateTime(2021, 1, 4),
          'daysLeft':
              0, //ZROB JAKAS FUNKCJE ZEBY TO OBLICZAC I POKAZYWAC ILE DO KONCA ALBO ILE SPOZNIENIA
          'tags': [
            '#stop',
            '#a',
            '#hehe',
          ]
        },
      ],
    }
  ];

  void showTasks(int n) {
    
  }

  List<Widget> _getTasks() {
    List<Widget> tasksList = [];



    return tasksList;
  }

  List<Widget> _getProjects() {
    List<Widget> projectsList = [];

    for (int i = 0; i < projects.length; i++) {
      projectsList.add(OutlinedButton(
        style: OutlinedButton.styleFrom(
          primary: Colors.white,
          backgroundColor: Colors.blue,
          textStyle: TextStyle(
            fontSize: 18,
            ),
          padding: const EdgeInsets.all(20.0),
        ),
        onPressed: () => showTasks(i),
        child: Text(projects[i]['projectTitle']),
      ));
    }
    return projectsList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Container(
            width: 200.0,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    'projekty',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(5.0),
                    children: _getProjects(),
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  'zadania',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          ),
          Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  'szczegóły',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          ),
          Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  'opcje projektu',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          ),
          Column(
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
              )
            ],
          ),
        ],
      ),
    );
  }
}
