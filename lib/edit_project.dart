import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zrub/projects.dart' as projPage;
import 'classes.dart';
import 'package:localstorage/localstorage.dart';

class MyEditProjPage extends StatefulWidget {
  @override
  _MyEditProjPageState createState() => _MyEditProjPageState();
}

class _MyEditProjPageState extends State<MyEditProjPage> {
  @override
  void initState() {
    getSelProj();
    super.initState();
  }

  Project sproj = Project(
      projDeadline: DateTime.now(),
      projDesc: 'Opis...',
      projIsDone: false,
      projProgress: 0.0,
      projTasks: [],
      projTitle: 'Pusty projekt');

  void getSelProj() async {
    List<Project> projs = await projPage.getProjectAsset();
    setState(() {
      sproj = projs[projPage.getSelectedProject()];
    });
  }

  _saveToStorage() {
    storage.setItem('projects', sprojs.toJson());
  }

  _editProject(int index, Project proj) {
    setState(() {
      sprojs.items[index] = proj;
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
                      _editProject(projPage.getSelectedProject(), proj);
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
        title: Text('Edytuj - ${sproj.projTitle}'),
      ),
      body: FutureBuilder(
        future: projPage.getProjectAsset(),
        builder: (context, AsyncSnapshot<List<Project>> snapshot) {
          List<Project> projects = snapshot.data ?? [];
          if (snapshot.hasData) {
            return loadForm(projects[projPage.getSelectedProject()]);
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
