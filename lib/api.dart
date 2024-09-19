import 'package:flutter/material.dart';

import "package:http/http.dart" as http;
import "dart:convert";

// ignore: constant_identifier_names
const String ENDPOINT = "https://todoapp-api.apps.k8s.gu.se/todos";
// ignore: constant_identifier_names
const String MY_API_KEY = "46e13e17-91ca-49a3-bdc6-bb4f43b72804";

class Task {
  String id;
  String taskName;
  bool isDone = false;

  Task({
    this.id ="",
    required this.taskName, 
    required this.isDone
    }
  );

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json["id"],
      taskName: json["title"],
      isDone: json["done"],
    );
  }
}

class TaskManager extends ChangeNotifier {
  List<Task> lstTasks = [];
  String filter = "all";

  Future<void> addTask(Task task) async {
    lstTasks.add(task);
    notifyListeners();

    http.Response response = await http.post(
      Uri.parse("$ENDPOINT?key=$MY_API_KEY"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(
        {"title": task.taskName, "done": task.isDone},
      ),
    );
  }

  Future<void> getTask() async {
    http.Response response = await http.get(Uri.parse("$ENDPOINT?key=$MY_API_KEY"));
    String body = response.body;
    List<dynamic> jsonData = jsonDecode(body);
    lstTasks = jsonData.map((json) => Task.fromJson(json)).toList();
    notifyListeners();
  }

  Future<void> removeTask(Task task) async {
    lstTasks.remove(task);
    notifyListeners();

    http.Response response = await http.delete(Uri.parse("$ENDPOINT/${task.id}?key=$MY_API_KEY"));
  }

  void checkBoxStatus(Task task) async {
    if (task.isDone) {
      task.isDone = false;
    } else {
      task.isDone = true;
    }
    notifyListeners();

    http.Response response = await http.put(
      Uri.parse("$ENDPOINT/${task.id}?key=$MY_API_KEY"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(
        {"title": task.taskName, "done": task.isDone},
      ),
    );
  }

  List<Task> getFilteredTasks() {
    if (filter == "done") {
      return lstTasks.where((task) => task.isDone).toList();
    } else if (filter == "undone") {
      return lstTasks.where((task) => !task.isDone).toList();
    }
    return lstTasks;
  }

  void setFilter(String newFilter) {
    filter = newFilter;
    notifyListeners();
  }
}
