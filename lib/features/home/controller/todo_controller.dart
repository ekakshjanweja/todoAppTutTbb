import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_main/common/utils/show_snackbar.dart';
import 'package:todo_main/features/home/repository/todo_repository.dart';
import 'package:todo_main/models/todo_model.dart';

final todoControllerProvider = StateProvider<TodoController>(
  (ref) => TodoController(
    todoRepository: ref.watch(todoRepoProvider),
  ),
);

final getTodosProvider = StreamProvider.family((ref, String uid) {
  final todoController = ref.watch(todoControllerProvider);
  return todoController.getTodos(uid: uid);
});

class TodoController {
  final TodoRepository _todoRepository;

  TodoController({
    required TodoRepository todoRepository,
  }) : _todoRepository = todoRepository;

  void addTodo(
      {required TodoModel todoModel,
      required String uid,
      required BuildContext context}) {
    try {
      _todoRepository.addTodo(todoModel: todoModel, uid: uid);
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  Stream<List<TodoModel>> getTodos({required String uid}) {
    return _todoRepository.getTodos(uid: uid);
  }

  void updateTodo({
    required bool isCompleted,
    required String uid,
    required String todoId,
  }) {
    _todoRepository.updateTodo(
        isCompleted: isCompleted, uid: uid, todoId: todoId);
  }

  void deleteTodo({
    required String uid,
    required String todoId,
  }) {
    _todoRepository.deleteTodo(uid: uid, todoId: todoId);
  }
}
