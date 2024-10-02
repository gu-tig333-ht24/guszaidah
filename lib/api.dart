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

  // Detta är en konstraktur som har ett namn som retunerar en Task objekt.
  // Map<String, dynamic> json är datan som vi får från getTask() metoden.
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

  Future<void> getTask() async {
    print("Hämtar tasks");
    http.Response response =
        await http.get(Uri.parse("$ENDPOINT?key=$MY_API_KEY"));
    String body = response.body;
    // Här konverteras den JSON-strängen till en faktisk Dart-datstruktur.
    // Resultatet blir en lista, där varje objekt i listan är en Map<String, dynamic>
    List<dynamic> jsonData = jsonDecode(body);
    // Här använder jag map() för att gå igenom varje objekt i listan och
    // konverterar dessa JSON-mappningar till Task-objekt med hjälp av Task.fromJson.
    // och toList() omvandlar sedan resultatet till en lista med Task-objekt.
    lstTasks = jsonData.map((json) => Task.fromJson(json)).toList();

    /*
    // Istället för att använda map och toLoist() kan vi anväända en foor-loop.
    lstTasks.clear; // Här säkerställer vi bara att listan är tom så att ingen duplicering sker
    for (var json in jsonData) {
      lstTasks.add(Task.fromJson(json));
    }
    */

    // När alla uppgifter är hämtade och omvandlade anropas notifyListeners() 
    // för att meddela alla lyssnare att något har ändrats så att ListView uppdateras
    notifyListeners();
    print("Klar med att hämta tasks");
  }

  Future<void> addTask(Task task) async {
    lstTasks.add(task);
    notifyListeners();

    print("Börjar skicka tasks");
    http.Response response = await http.post(
      Uri.parse("$ENDPOINT?key=$MY_API_KEY"),
      // Content-Type: "application/json" innebär att vi skickar data i JSON-format
      headers: {"Content-Type": "application/json"},
      // Här använder vi jsonEncode() för att konvertera en Dart-struktur 
      // (i detta fall en Map) till en JSON-sträng.
      body: jsonEncode(
        {"title": task.taskName, "done": task.isDone},
      ),
    );
    print("Klar med att skicka tasks");
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
