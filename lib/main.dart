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
  int _selectedProject =
      0; //aktualnie klikniety projekt, potrzebny do _getTasks()
  int _selectedTask = 0; //analogicznie

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
          'end': DateTime(2021, 4, 15),
          'daysLeft':
              0, //ZROB JAKAS FUNKCJE ZEBY TO OBLICZAC I POKAZYWAC ILE DO KONCA ALBO ILE SPOZNIENIA
          'isDone': false,
          'tags': [
            '#work',
            '#a',
            '#it',
            '#pipipupu'
          ]
        },
        {
          'taskTitle': 'A zadanie 2',
          'description': 'to jest drugie zadanie projektu A',
          'begin': DateTime(2021, 1, 3),
          'end': DateTime(2021, 1, 4),
          'daysLeft':
              0, //ZROB JAKAS FUNKCJE ZEBY TO OBLICZAC I POKAZYWAC ILE DO KONCA ALBO ILE SPOZNIENIA
          'isDone': false,
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
          'isDone': false,
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
          'isDone': false,
          'tags': [
            '#stop',
            '#a',
            '#hehe',
          ]
        },
        {
          'taskTitle': 'B zadanie 3',
          'description': 'to jest trzecie zadanie projektu B',
          'begin': DateTime(2021, 1, 4),
          'end': DateTime(2021, 1, 7),
          'daysLeft':
              0, //ZROB JAKAS FUNKCJE ZEBY TO OBLICZAC I POKAZYWAC ILE DO KONCA ALBO ILE SPOZNIENIA
          'isDone': false,
          'tags': [
            '#stop',
            '#a',
            '#hehe',
          ]
        },
      ],
    },
    {
      'projectTitle': 'projekt PIPI',
      'deadline': DateTime(2021, 10, 1),
      'progress': 0, //FUNKCJA ZEBY OBLICZAC NA PODSTAWIE % WYKONANIA ZADAN
      'tasks': [
        {
          'taskTitle': 'PP zadanie 1',
          'description': 'to jest pierwsze zadanie projektu PP',
          'begin': DateTime(2021, 1, 1),
          'end': DateTime(2021, 1, 3),
          'daysLeft':
              0, //ZROB JAKAS FUNKCJE ZEBY TO OBLICZAC I POKAZYWAC ILE DO KONCA ALBO ILE SPOZNIENIA
          'isDone': false,
          'tags': [
            '#work',
            '#a',
            '#it',
          ]
        },
      ],
    },
  ];

  List<Widget> _getDetails() {
    DateTime taskEnd = projects[_selectedProject]['tasks'][_selectedTask]['end'];
    Duration daysLeft = taskEnd.isBefore(DateTime.now()) ? -taskEnd.difference(DateTime.now()) : taskEnd.difference(DateTime.now()) + Duration(days: 1);
    String progress = taskEnd.isBefore(DateTime.now()) ? 'opóźnienie ' : 'pozostało ';
    Widget tags;

    String tagsList = "";

    for (int i = 0; i < projects[_selectedProject]['tasks'][_selectedTask]['tags'].length; i++) {
      tagsList += projects[_selectedProject]['tasks'][_selectedTask]['tags'][i] + ' ';
    }

    List<Widget> detailsList = [
      Text('opis', style: TextStyle(fontSize: 18)),
      Container(
        color: Colors.white,
        child: Text(projects[_selectedProject]['tasks'][_selectedTask]['description']),
      ),
      Text('postęp', style: TextStyle(fontSize: 18)),
      Container(
        color: Colors.white,
        child: Text('$progress ${daysLeft.inDays} dni'),
      ),
      Text('tagi', style: TextStyle(fontSize: 18)),
    ];
    tags = Container(
      color: Colors.white,
      child: Text(tagsList),
    );

    detailsList.add(tags);

    return detailsList;
  }

  List<Widget> _getTasks() {
    List<Widget> tasksList = [];

    for (int i = 0; i < projects[_selectedProject]['tasks'].length; i++) {
      tasksList.add(OutlinedButton(
        style: OutlinedButton.styleFrom(
          primary: Colors.white,
          backgroundColor: Colors.blue,
          textStyle: TextStyle(
            fontSize: 18,
          ),
          padding: const EdgeInsets.all(20.0),
        ),
        onPressed: () {
          //_showDetails(); //nie wiem, w jakis sposob aktualizowac
          setState(() {
            _selectedTask = i;
          });
        },
        child: Text(projects[_selectedProject]['tasks'][i]['taskTitle']),
      ));
      tasksList.add(Padding(padding: const EdgeInsets.symmetric(vertical: 3.0))); //moze szybsze by bylo opakowanie przycisku w container
    }

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
        onPressed: () {
          setState(() {
            _selectedProject = i;
            _selectedTask = 0;
          });
        },
        child: Text(projects[i]['projectTitle']),
      ));
      projectsList.add(Padding(padding: const EdgeInsets.symmetric(vertical: 3.0))); //moze szybsze by bylo opakowanie przycisku w container
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
        //mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                Expanded(
                  child: ListView(
                    //padding: const EdgeInsets.all(10.0),
                    children: _getProjects(),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
          ),
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
                Expanded(
                  child: ListView(
                      //padding: const EdgeInsets.all(10.0),
                      children: _getTasks()),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
          ),
          Container(
            width: 250.0,
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            color: Color(0xff83b0f7),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    'szczegóły',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView(
                    children: _getDetails(),
                  )),
              ],
            ),
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
