import 'dart:convert';

class Task {
  String taskTitle;
  String taskDesc;
  bool taskIsDone;
  List<String> taskTags;

  Task(
      {required this.taskTitle,
      required this.taskDesc,
      required this.taskIsDone,
      required this.taskTags});

  //bycmoze niepotrzebne
  factory Task.fromJson(Map<String, dynamic> parsedJson) {
    return Task(
        taskTitle: parsedJson['taskTitle'],
        taskDesc: parsedJson['taskDesc'],
        taskIsDone: parsedJson['taskIsDone'],
        taskTags: List<String>.from(parsedJson['taskTags']));
  }
}

class Project {
  String projTitle;
  DateTime projDeadline;
  double projProgress;
  String projDesc;
  bool projIsDone;
  List<Task> projTasks;

  Project(
      {required this.projTitle,
      required this.projDeadline,
      required this.projProgress,
      required this.projDesc,
      required this.projIsDone,
      required this.projTasks});

  factory Project.fromJson(Map<String, dynamic> parsedJson) {
    return Project(
        projTitle: parsedJson['projTitle'],
        projDeadline: DateTime.parse(parsedJson['projDeadline']),
        projProgress: parsedJson['projProgress'],
        projDesc: parsedJson['projDesc'],
        projIsDone: parsedJson['projIsDone'],
        projTasks: List<Task>.from(
            parsedJson['projTasks'].map((x) => Task.fromJson(x))));
    //projTasks prawdopodobnie nie bedzie dzialac
    //jesli nie to sprobowac nie wczytywac tego tutaj
    //tylko najpierw wczytac w tasku, zrobic liste
    //i wtedy wczytac poza konstruktorem
  }
}
