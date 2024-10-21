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