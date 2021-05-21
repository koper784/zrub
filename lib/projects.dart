import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyProjectsPage extends StatefulWidget {
  @override
  _MyProjectsPageState createState() => _MyProjectsPageState();
}

class _MyProjectsPageState extends State<MyProjectsPage> {
  List<Widget> _getProjects() {
    List<Widget> projectsList = [];

    return projectsList;
  }

  void _displayCurrentProjects() {
    //pokaz nieukonczone projekty
  }

  void _displayDoneProjects() {
    //pokaz ukonczone projekty
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
                    Expanded(
                      child: ListView(
                        //padding: const EdgeInsets.all(10.0),
                        children: _getProjects(),
                      ),
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
            ]));
  }
}
