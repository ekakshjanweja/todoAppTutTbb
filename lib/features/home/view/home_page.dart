import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:todo_main/common/widgets/new_task_button.dart';
import 'package:todo_main/common/widgets/todo_card.dart';
import 'package:todo_main/features/auth/controller/auth_controller.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todaysDate = DateFormat.MMMMEEEEd().format(DateTime.now());
    var currentWidth = MediaQuery.of(context).size.width;
    var currentHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Padding(
          padding: EdgeInsets.symmetric(
            vertical: currentHeight * 0.08,
            horizontal: currentWidth * 0.08,
          ),
          child: Column(
            children: [
              //Upper Row

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  //Left

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Today\s Tasks',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        todaysDate,
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),

                  //Right

                  const NewTaskButton(),
                ],
              ),

              //Card Widget

              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: 10,
                  itemBuilder: (BuildContext context, int index) {
                    return const TodoCard();
                  },
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor:
              Theme.of(context).colorScheme.primary.withOpacity(0.4),
          onPressed: () {
            ref.watch(authControllerProvider.notifier).logOut();
          },
          child: const Icon(Icons.logout),
        ),
      ),
    );
  }
}
