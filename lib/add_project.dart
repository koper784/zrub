import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'classes.dart';

class MyAddProjPage extends StatefulWidget {
  @override
  _MyAddProjPageState createState() => _MyAddProjPageState();
}

class _MyAddProjPageState extends State<MyAddProjPage> {
  Project proj = Project(
      projDeadline: DateTime.now(),
      projDesc: 'Opis...',
      projIsDone: false,
      projProgress: 0.0,
      projTasks: [],
      projTitle: 'Pusty projekt');

  final _formKey = GlobalKey<FormState>();

  String title = '';
  String desc = '';

  _saveToStorage() {
    storage.setItem('projects', sprojs.toJson());
  }

  _addProject(Project proj) {
    setState(() {
      sprojs.items.add(proj);
      _saveToStorage();
    });
  }

  DateTime date = DateTime.now();

  Widget loadForm(Project proj) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                initialValue: proj.projTitle,
                decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Nazwa projektu',
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
              Padding(padding: const EdgeInsets.all(3.0)),
              Row(
                children: [
                  Text(
                    'Deadline: ',
                    style: TextStyle(fontSize: 20.0),
                  ),
                  Padding(padding: const EdgeInsets.all(3.0)),
                  Text(
                    '${date.day}.${date.month}.${date.year}',
                    style: TextStyle(fontSize: 20.0),
                  ),
                  Padding(padding: const EdgeInsets.all(3.0)),
                  ElevatedButton(
                      onPressed: () {
                        showDatePicker(
                                context: context,
                                initialDate: date,
                                firstDate: DateTime(2020),
                                lastDate: DateTime(2030))
                            .then((adate) {
                          setState(() {
                            date = adate ?? date;
                          });
                        });
                      },
                      child: Text('Wybierz date')),
                ],
              ),
              TextFormField(
                initialValue: proj.projDesc,
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
                      value.contains('"') ||
                      value.length > 1000) {
                    return 'Opis nie może być pusty, musi być krótszy niż 1000 znaków i nie może zawierać cudzysłowu.';
                  } else {
                    desc = value;
                    return null;
                  }
                },
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: ElevatedButton(
                  child: Text('Dodaj'),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      proj.projTitle = title;
                      proj.projDesc = desc;
                      proj.projDeadline = date;
                      _addProject(proj);
                      Navigator.pop(context, 'pipi');
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
        title: Text('Dodaj projekt'),
      ),
      body: loadForm(proj),
    );
  }
}
