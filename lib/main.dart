import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'my_sec_page.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => TaskManager(),
      child: MyApp(),
    ),
  );
}

class Task {
  String taskName;
  bool isDone = false;

  Task(this.taskName, this.isDone);
}

class TaskManager extends ChangeNotifier {
  List<Task> lstTasks = [];
  String filter = "all";

  void addTask(Task task) {
    lstTasks.add(task);
    notifyListeners();
  }

  void removeTask(Task task) {
    lstTasks.remove(task);
    notifyListeners();
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

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Flutter To Do List",
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Jag använder "watch" här eftersom jag vill att denna vy (HomePage) ska uppdateras
    // varje gång listan i TaskManager ändras, t.ex. när en ny uppgift läggs till
    // eller när en uppgift tas bort. Genom att använda "watch" kommer widgeten
    // automatiskt att lyssna på förändringar i TaskManager och uppdatera sig
    // när notifyListeners() anropas, vilket gör att användargränssnittet visar
    // den aktuella listan med uppgifter.
    final taskManager = context.watch<TaskManager>();
    var filteredTasks = taskManager.getFilteredTasks();

    return Scaffold(
      appBar: AppBar(
        title: const Text("TIG333 TODO"),
        centerTitle: true,
        backgroundColor: Colors.grey,
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert),
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem<String>(
                  value: "all",
                  child: Text("all", style: TextStyle(fontSize: 14)),
                ),
                const PopupMenuItem<String>(
                  value: "done",
                  child: Text("done", style: TextStyle(fontSize: 14)),
                ),
                const PopupMenuItem<String>(
                  value: "undone",
                  child: Text("undone", style: TextStyle(fontSize: 14)),
                ),
              ];
            },
            onSelected: (String value) {
              final taskManager = context.read<TaskManager>();
              taskManager.setFilter(value);
            },
            padding: EdgeInsets.zero,
            offset: Offset(0, 40),
          ),
        ], // actions
      ),
      body: ListView.separated(
        itemBuilder: (context, index) => taskRow(context, filteredTasks[index]),
        itemCount: filteredTasks.length,
        separatorBuilder: (context, index) => const Divider(
          color: Colors.grey,
          thickness: 1,
          height: 1,
        ),
      ),
      floatingActionButton: SizedBox(
        width: 60,
        height: 60,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => MySecPage()));
          },
          backgroundColor: Colors.grey,
          shape: CircleBorder(),
          child: const Icon(Icons.add, size: 60, color: Colors.white),
        ),
      ),
    );
  }
}

Widget taskRow(BuildContext context, Task task) {
  return Padding(
    padding: const EdgeInsets.only(top: 10, bottom: 10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Checkbox(
          value: task.isDone,
          onChanged: (bool? value) {
            if (task.isDone) {
              task.isDone = false;
            } else {
              task.isDone = true;
            }

            final taskManager = context.read<TaskManager>();
            taskManager.notifyListeners();
          },
        ),
        Expanded(
          child: Text(
            task.taskName,
            style: TextStyle(
                fontSize: 24,
                decoration: task.isDone
                    ? TextDecoration.lineThrough
                    : TextDecoration.none),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            // Här använder vi read eftersom det är en engångsåtgärd
            final taskManager = context.read<TaskManager>();
            taskManager.removeTask(task);
          },
        ),
      ],
    ),
  );
}
