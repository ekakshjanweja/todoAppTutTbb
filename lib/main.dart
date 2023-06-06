import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_main/features/auth/controller/auth_controller.dart';
import 'package:todo_main/features/home/view/home_page.dart';
import 'package:todo_main/firebase_options.dart';
import 'package:todo_main/features/auth/view/login_page.dart';
import 'package:todo_main/models/user_model.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  UserModel? userModel;

  void getUserData(WidgetRef ref, User data) async {
    userModel = await ref
        .watch(authControllerProvider.notifier)
        .getUserData(uid: data.uid)
        .first;

    ref.read(userProvider.notifier).update((state) => userModel);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(authStateChangesProvider).when(
          data: (data) {
            if (data != null) {
              getUserData(ref, data);
            }
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: ThemeData.dark(useMaterial3: true),
              home: userModel != null ? const HomePage() : const LoginPage(),
            );
          },
          error: (error, stackTrace) => Scaffold(
            body: Center(
              child: Text(error.toString()),
            ),
          ),
          loading: () => const CircularProgressIndicator(),
        );
  }
}
