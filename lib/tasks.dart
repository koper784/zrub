import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyTasksPage extends StatefulWidget {
  @override
  _MyTasksPageState createState() => _MyTasksPageState();
}

class _MyTasksPageState extends State<MyTasksPage> {
  List<Widget> _getTasks() {
    List<Widget> tasksList = [];

    return tasksList;
  }

  List<Widget> _getDetails() {
    List<Widget> detailsList = [];

    return detailsList;
  }

  double _getProgress() {
    return 0.0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Lista zadań - Zrub'),
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
                    Expanded(
                      child: ListView(
                          //padding: const EdgeInsets.all(10.0),
                          children: _getTasks()),
                    ),
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
                    Container(
                        padding: const EdgeInsets.all(5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FloatingActionButton(
                                onPressed: () {},
                                child: const Icon(Icons.edit)),
                          ],
                        ))
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(0.0),
                ),
              ),
              Container(
                width: 250.0,
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                color: Color(0xffc9c9c9),
                child: Column(
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
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                    ),
                    OutlinedButton(
                      onPressed: () {},
                      child: Text('Zawieś'),
                      style: OutlinedButton.styleFrom(
                        primary: Colors.white,
                        backgroundColor: Colors.grey.shade600,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                    ),
                    OutlinedButton(
                      onPressed: () {},
                      child: Text('Zakończ'),
                      style: OutlinedButton.styleFrom(
                        primary: Colors.white,
                        backgroundColor: Colors.grey.shade600,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        'opcje zadania',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                    ),
                    OutlinedButton(
                      onPressed: () {},
                      child: Text('Zawieś'),
                      style: OutlinedButton.styleFrom(
                        primary: Colors.white,
                        backgroundColor: Colors.grey.shade600,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                    ),
                    OutlinedButton(
                      onPressed: () {},
                      child: Text('Zakończ'),
                      style: OutlinedButton.styleFrom(
                        primary: Colors.white,
                        backgroundColor: Colors.grey.shade600,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        'o projekcie',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      'Postęp',
                      style: TextStyle(fontSize: 18),
                    ),
                    LinearProgressIndicator(
                      value: _getProgress(),
                      minHeight: 10.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                    ),
                    Text('Deadline', style: TextStyle(fontSize: 18)),
                    /*Text(DateFormat.yMMMMd('en_US')
                        .format(projects[_selectedProject]['projDeadline'])),*/
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                    ),
                    Text('Tagi', style: TextStyle(fontSize: 18)),
                    //Text(_getAllTags()),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                    ),
                  ],
                ),
              ),
              Container(
                width: 250.0,
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
                              hintText: 'Wpisz kluczowe hasło'),
                        )),
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                    ),
                    ElevatedButton(onPressed: () {}, child: Text('Szukaj')),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                    ),
                    ElevatedButton(
                        onPressed: () {}, child: Text('Sortuj projekty')),
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                    ),
                    ElevatedButton(
                        onPressed: () {}, child: Text('Sortuj zadania')),
                  ],
                ),
              ),
            ]));
  }
}
