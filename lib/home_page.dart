import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_main/features/auth/controller/auth_controller.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  void showSnackBar({
    required BuildContext context,
    required String content,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(content),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Home Page'),
            FilledButton.tonal(
              onPressed: () {
                ref.read(authControllerProvider.notifier).logOut();
              },
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
