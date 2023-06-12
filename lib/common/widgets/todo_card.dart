import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:todo_main/common/providers/firebase_provider.dart';
import 'package:todo_main/features/home/controller/todo_controller.dart';
import 'package:todo_main/models/todo_model.dart';

class TodoCard extends ConsumerStatefulWidget {
  final TodoModel todoModel;
  const TodoCard({super.key, required this.todoModel});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TodoCardState();
}

class _TodoCardState extends ConsumerState<TodoCard> {
  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat.Hm().format(widget.todoModel.time);
    var currentWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        showTodoTile(context: context, todoModel: widget.todoModel, ref: ref);
      },
      child: Container(
        width: currentWidth,
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
        margin: const EdgeInsets.symmetric(
          vertical: 24,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.todoModel.todo,
                    style: TextStyle(
                      fontSize: 20,
                      decoration: widget.todoModel.isCompleted
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                  const Divider(),
                  Text(
                    'Created at $formattedDate',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: GestureDetector(
                onTap: () {
                  var isCompleteCurrent = widget.todoModel.isCompleted;
                  setState(() {
                    isCompleteCurrent = !isCompleteCurrent;
                  });
                  ref.watch(todoControllerProvider).updateTodo(
                        isCompleted: isCompleteCurrent,
                        uid: ref.watch(firebaseAuthProvider).currentUser!.uid,
                        todoId: widget.todoModel.todoId,
                      );
                },
                child: Icon(
                  Icons.check,
                  color: widget.todoModel.isCompleted
                      ? Theme.of(context).colorScheme.primary
                      : Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

showTodoTile({
  required BuildContext context,
  required TodoModel todoModel,
  required WidgetRef ref,
}) {
  return showModalBottomSheet(
    showDragHandle: true,
    context: context,
    builder: (context) => Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                todoModel.todo,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                todoModel.desc,
                style: const TextStyle(fontSize: 20),
              ),
            ],
          ),
          IconButton(
            onPressed: () {
              ref.watch(todoControllerProvider).deleteTodo(
                    uid: ref.watch(firebaseAuthProvider).currentUser!.uid,
                    todoId: todoModel.todoId,
                  );
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.delete,
              color: Theme.of(context).colorScheme.error,
            ),
          ),
        ],
      ),
    ),
  );
}
