import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_main/features/auth/repository/auth.dart';
import 'package:todo_main/models/user_model.dart';

final userProvider = StateProvider<UserModel?>((ref) => null);

final authControllerProvider = StateNotifierProvider<AuthController, bool>(
  (ref) => AuthController(auth: ref.watch(authProvider), ref: ref),
);

final authStateChangesProvider = StreamProvider((ref) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.authStateChanges;
});

final getUserDataProvider = StreamProvider.family((ref, String uid) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.getUserData(uid: uid);
});

class AuthController extends StateNotifier<bool> {
  final Auth _auth;
  final Ref _ref;

  AuthController({
    required Auth auth,
    required Ref ref,
  })  : _ref = ref,
        _auth = auth,
        super(false);

  Stream<User?> get authStateChanges => _auth.authStateChanges;

  void signInwithGoogle({required BuildContext context}) async {
    state = true;
    final user = await _auth.signInWithGoogle();
    state = false;
    user.fold(
      (failure) => ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(failure.message))),
      (userModel) =>
          _ref.read(userProvider.notifier).update((state) => userModel),
    );
  }

  Stream<UserModel> getUserData({required String uid}) {
    return _auth.getUserData(uid: uid);
  }

  void logOut() async {
    _auth.logOut();
  }
}
