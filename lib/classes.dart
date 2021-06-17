import 'dart:convert';
import 'package:localstorage/localstorage.dart';

final LocalStorage storage = new LocalStorage('projects');

ProjectList sprojs = ProjectList(items: []);

class Task {
  String taskTitle;
  String taskDesc;
  bool taskIsDone;
  List<String> taskTags;
  double taskProgress;

  Task(
      {required this.taskTitle,
      required this.taskDesc,
      required this.taskIsDone,
      required this.taskTags,
      required this.taskProgress});

  factory Task.fromJson(Map<String, dynamic> parsedJson) {
    return Task(
        taskTitle: parsedJson['taskTitle'],
        taskDesc: parsedJson['taskDesc'],
        taskIsDone: parsedJson['taskIsDone'],
        taskProgress: parsedJson['taskProgress'],
        taskTags: List<String>.from(parsedJson['taskTags']));
  }

  Map<String, dynamic> toJson() {
    return {
      "taskTitle": this.taskTitle,
      "taskProgress": this.taskProgress,
      "taskDesc": this.taskDesc,
      "taskIsDone": this.taskIsDone,
      "taskTags": jsonEncode(this.taskTags)
    };
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
  }

  Map<String, dynamic> toJson() {
    return {
      "projTitle": this.projTitle,
      "projDeadline": this.projDeadline.toIso8601String(),
      "projProgress": this.projProgress,
      "projDesc": this.projDesc,
      "projIsDone": this.projIsDone,
      "projTasks": jsonEncode(this.projTasks)
    };
  }
}

class ProjectList {
  List<Project> items = [];

  ProjectList({required this.items});

  toJson() {
    return items.map((item) {
      return item.toJson();
    }).toList();
  }
}
