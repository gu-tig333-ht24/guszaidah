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

  Task({this.id = "", required this.taskName, required this.isDone});

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

    print("Börjar skicka tasks");
    http.Response response = await http.post(
      Uri.parse("$ENDPOINT?key=$MY_API_KEY"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(
        {"title": task.taskName, "done": task.isDone},
      ),
    );
    print("Klar med att skicka tasks");
  }

  Future<void> getTask() async {
    print("Hämtar tasks");
    http.Response response =
        await http.get(Uri.parse("$ENDPOINT?key=$MY_API_KEY"));
    String body = response.body;
    List<dynamic> jsonData = jsonDecode(body);
    lstTasks = jsonData.map((json) => Task.fromJson(json)).toList();
    notifyListeners();
    print("Klar med att hämta tasks");
  }

  Future<void> removeTask(Task task) async {
    lstTasks.remove(task);
    notifyListeners();

    print("Tar bort tasks");
    // ignore: unused_local_variable
    http.Response response =
        await http.delete(Uri.parse("$ENDPOINT/${task.id}?key=$MY_API_KEY"));
    print("Klar med att ta bort tasks");
  }

  void checkBoxStatus(Task task) async {
    if (task.isDone) {
      task.isDone = false;
    } else {
      task.isDone = true;
    }
    notifyListeners();

    print("Uppdaterar tasks");
    http.Response response = await http.put(
      Uri.parse("$ENDPOINT/${task.id}?key=$MY_API_KEY"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(
        {"title": task.taskName, "done": task.isDone},
      ),
    );
    print("Klar med att uppdatera tasks");
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
