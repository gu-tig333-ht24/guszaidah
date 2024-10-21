import 'package:flutter/material.dart';
import "package:http/http.dart" as http;
import "dart:convert";
import 'task.dart';
import 'api.dart';

class TaskManager extends ChangeNotifier {
  List<Task> lstTasks = [];
  String filter = "all";

  Future<void> getTask() async {
    print("Hämtar tasks");
    try {
      http.Response response =
          await http.get(Uri.parse("$ENDPOINT?key=$MY_API_KEY"));
      if (response.statusCode == 200) {
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
      } else {
        print("Misslycakdes med att hämta tasks: ${response.statusCode}");
      }
    } catch (e) {
      print("Ett fel uppstpd vid hämtning av tasks: $e");
    }
  }

  Future<void> addTask(Task task) async {
    print("Börjar skicka tasks");
    try {
      http.Response response = await http.post(
        Uri.parse("$ENDPOINT?key=$MY_API_KEY"),
        // Content-Type: "application/json" innebär att vi skickar data i JSON-format
        headers: {"Content-Type": "application/json"},
        // Här använder vi jsonEncode() för att konvertera en Dart-struktur
        // (i detta fall en Map) till en JSON-sträng.
        body: jsonEncode(
          {"id": task.id, "title": task.taskName, "done": task.isDone},
        ),
      );

      if (response.statusCode == 200) {
        jsonDecode(response.body);
        lstTasks.add(task);
        notifyListeners();
        print("Klar med att skicka tasks");
      } else {
        print("Misslycakdes med att skicka task: ${response.statusCode}");
      }
    } catch (e) {
      print("Ett fel uppstpd vid tillägg av tasks: $e");
    }
  }

  Future<void> removeTask(Task task) async {
    print("Tar bort tasks");
    try {
      http.Response response =
          await http.delete(Uri.parse("$ENDPOINT/${task.id}?key=$MY_API_KEY"));
      if (response.statusCode == 200) {
        lstTasks.remove(task);
        notifyListeners();
        print("Klar med att ta bort tasks");
      } else {
        print("Misslyckades med att ta bort tasks: ${response.statusCode}");
      }
    } catch (e) {
      print("Ett fel uppstod vid borttagning av tasks: $e");
    }
  }

  void checkBoxStatus(Task task) async {
    task.isDone = !task.isDone;
    print("Uppdaterar tasks");

    try {
      http.Response response = await http.put(
        Uri.parse("$ENDPOINT/${task.id}?key=$MY_API_KEY"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(
          {"title": task.taskName, "done": task.isDone},
        ),
      );

      if (response.statusCode == 200) {
        notifyListeners();
        print("Klar med att uppdatera tasks");
      } else {
        task.isDone = !task.isDone;
        print("Misslyckades med att uppdatera tasks: ${response.statusCode}");
      }
    } catch (e) {
      task.isDone = !task.isDone;
      print("Ett fel uppstod vid uppdatering av tasks: $e");
    }
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
