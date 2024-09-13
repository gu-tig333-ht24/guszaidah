import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class Task {
  String taskName;
  bool isDone;

  Task(this.taskName, this.isDone);
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
    List<Task> lstTasks = [
      Task("Write a book", false),
      Task("Do homework", false),
      Task("Write a book", true),
      Task("Watch TV", false),
      Task("Nap", false),
      Task("Shop groceries", false),
      Task("Have fun", false),
      Task("Meditate", false),
    ];

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
                    child: Text("all", style: TextStyle(fontSize: 14)),
                  ),
                  const PopupMenuItem<String>(
                    child: Text("done", style: TextStyle(fontSize: 14)),
                  ),
                  const PopupMenuItem<String>(
                    child: Text("undone", style: TextStyle(fontSize: 14)),
                  ),
                ];
              },
              onSelected: (String value) {
                // ~~~~~~~~
              },
              padding: EdgeInsets.zero,
              offset: Offset(0, 40),
            )
          ], // actions
        ),
        body: ListView.separated(
          itemBuilder: (context, index) => taskRow(lstTasks[index]),
          itemCount: lstTasks.length,
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
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MySecPage()));
            },
            backgroundColor: Colors.grey,
            shape: CircleBorder(),
            child: const Icon(Icons.add, size: 60, color: Colors.white),
          ),
        ));
  }

  Widget taskRow(Task task) {
    return Padding(
        padding: EdgeInsets.only(top: 10, bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Checkbox(
              value: task.isDone,
              onChanged: (bool? value) {
                // ~~~~~~~~~~
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
              icon: Icon(Icons.close),
              onPressed: () {
                // ~~~~~~~~~~
              },
            )
          ],
        ));
  }
}

class MySecPage extends StatelessWidget {
  const MySecPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("TIG333 TODO"),
        centerTitle: true,
        backgroundColor: Colors.grey,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      
      body: Padding(
        padding: EdgeInsets.only(top: 40, right: 30, left: 30, bottom: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: "What are you going to do?",
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.black, width: 2),
                  borderRadius: BorderRadius.circular(5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.black, width: 2),
                  borderRadius: BorderRadius.circular(5),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              ),
            ),
            const SizedBox(height: 20),
            TextButton.icon(
              onPressed: () {
                // ~~~~~~~~
              },
              label: Text(
                "+ ADD",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
