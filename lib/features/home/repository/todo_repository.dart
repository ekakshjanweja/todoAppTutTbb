import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_main/common/providers/firebase_provider.dart';
import 'package:todo_main/models/todo_model.dart';

final todoRepoProvider = Provider<TodoRepository>(
  (ref) => TodoRepository(
    firebaseFirestore: ref.watch(firebaseFirestoreProvider),
  ),
);

class TodoRepository {
  final FirebaseFirestore _firebaseFirestore;

  TodoRepository({
    required FirebaseFirestore firebaseFirestore,
  }) : _firebaseFirestore = firebaseFirestore;

  CollectionReference get _users => _firebaseFirestore.collection('users');

  void addTodo({required TodoModel todoModel, required String uid}) async {
    await _firebaseFirestore
        .collection('users')
        .doc(uid)
        .collection('todos')
        .doc(todoModel.todoId)
        .set(todoModel.toMap());
  }

  Stream<List<TodoModel>> getTodos({required String uid}) {
    return _users
        .doc(uid)
        .collection('todos')
        .orderBy('time', descending: true)
        .snapshots()
        .asyncMap((event) {
      List<TodoModel> todos = [];

      for (var element in event.docs) {
        var todo = TodoModel.fromMap(element.data());
        todos.add(todo);
      }

      return todos;
    });
  }

  void updateTodo({
    required bool isCompleted,
    required String uid,
    required String todoId,
  }) {
    _users
        .doc(uid)
        .collection('todos')
        .doc(todoId)
        .update({'isCompleted': isCompleted});
  }

  void deleteTodo({
    required String uid,
    required String todoId,
  }) {
    _users.doc(uid).collection('todos').doc(todoId).delete();
  }
}
