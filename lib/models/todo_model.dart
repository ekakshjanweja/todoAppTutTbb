class TodoModel {
  final String todo;
  final DateTime time;
  final bool isCompleted;
  final String todoId;
  final String desc;

  TodoModel({
    required this.todo,
    required this.time,
    required this.isCompleted,
    required this.todoId,
    required this.desc,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'todo': todo,
      'time': time.millisecondsSinceEpoch,
      'isCompleted': isCompleted,
      'todoId': todoId,
      'desc': desc,
    };
  }

  factory TodoModel.fromMap(Map<String, dynamic> map) {
    return TodoModel(
      todo: map['todo'] as String,
      time: DateTime.fromMillisecondsSinceEpoch(map['time'] as int),
      isCompleted: map['isCompleted'] as bool,
      todoId: map['todoId'] as String,
      desc: map['desc'] as String,
    );
  }
}
