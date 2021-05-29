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

  int dropdownDay = 1;
  int dropdownMonth = 1;
  int dropdownYear = 2021;

  final _formKey = GlobalKey<FormState>();

  Widget loadForm(Project proj) {
    List<int> monthsList = List<int>.generate(12, (i) => i + 1);
    List<int> daysList = List<int>.generate(31, (i) => i + 1);
    List<int> yearsList = List<int>.generate(30, (i) => i + 2021);

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
                  }
                  return null;
                },
              ),
              Row(
                children: [
                  Text('Deadline: dzień:'),
                  DropdownButton<int>(
                      value: proj.projDeadline.day,
                      onChanged: (int? newVal) {
                        setState(() {
                          dropdownDay = newVal ?? 1;
                        });
                      },
                      items: daysList.map<DropdownMenuItem<int>>((int val) {
                        return DropdownMenuItem<int>(
                            value: val, child: Text('$val'));
                      }).toList()),
                  Text('miesiąc:'),
                  DropdownButton<int>(
                      value: proj.projDeadline.month,
                      onChanged: (int? newVal) {
                        setState(() {
                          dropdownMonth = newVal ?? 1;
                        });
                      },
                      items: monthsList.map<DropdownMenuItem<int>>((int val) {
                        return DropdownMenuItem<int>(
                            value: val, child: Text('$val'));
                      }).toList()),
                  Text('rok:'),
                  DropdownButton<int>(
                      value: proj.projDeadline.year,
                      onChanged: (int? newVal) {
                        setState(() {
                          dropdownYear = newVal ?? 1;
                        });
                      },
                      items: yearsList.map<DropdownMenuItem<int>>((int val) {
                        return DropdownMenuItem<int>(
                            value: val, child: Text('$val'));
                      }).toList()),
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
                  }
                  return null;
                },
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: ElevatedButton(
                  child: Text('Dodaj'),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('poprawnie'),
                        //zrob walidacje daty
                      ));
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
