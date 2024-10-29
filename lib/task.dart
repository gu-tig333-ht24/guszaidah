class Task {
  String? id;
  String taskName;
  bool done = false;

  Task({this.id, required this.taskName, required this.done});

  // Detta är en konstraktur som har ett namn som retunerar en Task objekt.
  // Map<String, dynamic> json är datan som vi får från getTask() metoden.
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json["id"]?.toString(),
      taskName: json["title"],
      done: json["done"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "title": taskName,
      "done": done,
    };
  }
}
