import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_main/common/providers/firebase_provider.dart';
import 'package:todo_main/features/home/controller/todo_controller.dart';
import 'package:todo_main/models/todo_model.dart';
import 'package:uuid/uuid.dart';

class NewTaskButton extends ConsumerWidget {
  const NewTaskButton({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        final todoId = const Uuid().v1();

        final todoModel = TodoModel(
          todo: 'Test Todo',
          time: DateTime.now(),
          isCompleted: false,
          todoId: todoId,
          desc: 'Test Todo Description',
        );

        ref.watch(todoControllerProvider).addTodo(
              todoModel: todoModel,
              uid: ref.watch(firebaseAuthProvider).currentUser!.uid,
              context: context,
            );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.4),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Row(
          children: [
            Icon(Icons.add),
            SizedBox(
              width: 10,
            ),
            Text('New Task'),
          ],
        ),
      ),
    );
  }
}
