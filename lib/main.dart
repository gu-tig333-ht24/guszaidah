import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'my_sec_page.dart';
import 'api.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => TaskManager(),
      child: MyApp(),
    ),
  );
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

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  
  // initState() är en metod som anropas en gång när widgetens tillstånd (state) 
  // skapas för första gången. I den här appen används den för att göra en 
  // API-förfrågan och hämta uppgifterna från servern
  void initState() {
    super.initState();
    // Här anropas getTask()-metoden från TaskManager och vi når metoden genom att
    // använda provider. Och vi använder read eftersom vi vill bara nå metoden
    context.read<TaskManager>().getTask();
  }

  @override
  Widget build(BuildContext context) {
    // När du använder context.watch<TaskManager>(), lyssnar widgeten (MyHomePage
    // i det här fallet) på förändringar i TaskManager. Om någon av metoderna i
    // TaskManager kallar på notifyListeners(), kommer widgeten att byggas om
    // (uppdateras) automatiskt.

    // Vad menas med förädnringar i det här sammanhanget ? Det som menas är att
    // varje gång vi lägger/tar bort en item från listan så beräknas det som förändring
    // eftersom i addTask/RemoveTask metoderna har jag lagt notifyListeners().
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
        ],
        // actions
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
            // Jag använder read här eftersom det är en engångsåtgärd när är
            // användaren markerar eller avmarkerar Checkbox-en.

            // I det här fallet vill vi inte att själva taskRow-widgeten ska
            // lyssna på förändringar i TaskManager. Det är MyHomePage som redan
            // lyssnar på alla förändringar genom att använda watch.

            // Genom att använda read, undviker vi att skapa en onödig lyssnare
            // inom varje Checkbox.
            context.read<TaskManager>().checkBoxStatus(task);
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
            // Vi använder context.read<TaskManager>() för att ta bort en uppgift
            // eftersom detta är en engångsåtgärd. Vi behöver bara anropa metoden
            // removeTask en gång.Om vi använder context.watch<TaskManager>() i
            // detta sammanhang skulle vi skapa en lyssnare i varje taskRow,
            // vilket är onödigt eftersom taskRow inte behöver uppdateras
            // självständigt när listan i TaskManager ändras. Det är MyHomePage
            // som behöver uppdateras.
            context.read<TaskManager>().removeTask(task);

            // Eller
            // final taskManager = context.read<TaskManager>();
            // taskManager.removeTask(task);
          },
        ),
      ],
    ),
  );
}
