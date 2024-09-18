import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'main.dart';

class MySecPage extends StatelessWidget {
  MySecPage({super.key});

  final TextEditingController _taskController = TextEditingController();

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
              controller: _taskController, // Kopplar controllern till TextField
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
                // När jag använder readså säger jag till Provider att jag 
                // inte är intresserad av att lyssna på förändringar i TaskManager. 
                // Det betyder att MySecPage inte kommer att uppdateras om något 
                // i TaskManager ändras.

                // jag använder read för att komma åt TaskManager-instansen och 
                // lägga till en uppgift (addTask). Detta är en engångsåtgärd. 
                // När jag trycker på "+ ADD"-knappen läggs en ny uppgift till, 
                // men själva skärmen (MySecPage) behöver inte uppdateras, vilket 
                // är varför jag använder read.
                final taskManager = context.read<TaskManager>();
                String taskName = _taskController.text;
                taskManager.addTask(Task(taskName, false));
                _taskController.clear();
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
