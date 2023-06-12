import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_main/features/auth/controller/auth_controller.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  void signInWithGoogle(WidgetRef ref, BuildContext context) {
    ref
        .read(authControllerProvider.notifier)
        .signInwithGoogle(context: context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Login Page'),
            FilledButton.tonal(
              onPressed: () {
                signInWithGoogle(ref, context);
              },
              child: const Text('Login With Google'),
            ),
          ],
        ),
      ),
    );
  }
}
