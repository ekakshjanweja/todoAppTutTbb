import 'package:flutter/material.dart';

class TodoCard extends StatelessWidget {
  const TodoCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var currentWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        showTodoTile(context: context);
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
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Test Task',
                    style: TextStyle(fontSize: 20),
                  ),
                  Divider(),
                  Text(
                    'Created at 7:48PM',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Icon(Icons.check),
            )
          ],
        ),
      ),
    );
  }
}

showTodoTile({required BuildContext context}) {
  return showModalBottomSheet(
    showDragHandle: true,
    context: context,
    builder: (context) => Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Test Task',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Lorem Ipsum Lorem Ipsum',
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
          IconButton(
            onPressed: () {},
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
