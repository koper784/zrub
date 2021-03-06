import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zrub/projects.dart' as projPage;
import 'classes.dart';

class MyEditProjPage extends StatefulWidget {
  @override
  _MyEditProjPageState createState() => _MyEditProjPageState();
}

class _MyEditProjPageState extends State<MyEditProjPage> {
  Project sproj = Project(
      projDeadline: DateTime.now(),
      projDesc: 'Opis...',
      projIsDone: false,
      projProgress: 0.0,
      projTasks: [],
      projTitle: 'Pusty projekt');

  _saveToStorage() {
    storage.setItem('projects', sprojs.toJson());
  }

  _saveProject(Project proj) {
    setState(() {
      sprojs.items[projPage.getSelectedProject()] = proj;
      _saveToStorage();
    });
  }

  final _formKey = GlobalKey<FormState>();

  DateTime date = DateTime.now();

  Widget loadForm(Project proj) {
    String title = '';
    String desc = '';

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
                  child: Text('Zapisz'),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      proj.projTitle = title;
                      proj.projDesc = desc;
                      proj.projDeadline = date;
                      _saveProject(proj);
                      Navigator.pop(context);
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
        title: Text(
            'Edytuj - ${sprojs.items[projPage.getSelectedProject()].projTitle}'),
      ),
      body: FutureBuilder(
        future: storage.ready,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return loadForm(sprojs.items[projPage.getSelectedProject()]);
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
