import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:todo_main/common/providers/firebase_provider.dart';
import 'package:todo_main/common/utils/failure.dart';
import 'package:todo_main/common/utils/type_defs.dart';
import 'package:todo_main/models/user_model.dart';

final authProvider = Provider<Auth>(
  (ref) => Auth(
    firebaseAuth: ref.read(firebaseAuthProvider),
    firebaseFirestore: ref.read(firebaseFirestoreProvider),
    googleSignIn: ref.read(googleSignInProvider),
  ),
);

class Auth {
  //Private Variables
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firebaseFirestore;
  final GoogleSignIn _googleSignIn;

  Auth({
    required FirebaseAuth firebaseAuth,
    required FirebaseFirestore firebaseFirestore,
    required GoogleSignIn googleSignIn,
  })  : _firebaseAuth = firebaseAuth,
        _firebaseFirestore = firebaseFirestore,
        _googleSignIn = googleSignIn;

  CollectionReference get _users => _firebaseFirestore.collection('users');

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  FutureEither<UserModel> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleUser!.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(credential);

      UserModel userModel;

      if (userCredential.additionalUserInfo!.isNewUser) {
        userModel = UserModel(
          uid: userCredential.user!.uid,
          name: userCredential.user!.displayName ?? '',
          profilePic: userCredential.user!.photoURL ?? '',
        );
        await _users.doc(userModel.uid).set(userModel.toMap());
      } else {
        userModel = await getUserData(uid: userCredential.user!.uid).first;
      }
      return right(userModel);
    } on FirebaseAuthException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(message: e.toString()));
    }
  }

  Stream<UserModel> getUserData({
    required String uid,
  }) {
    return _users.doc(uid).snapshots().map(
      (event) {
        return UserModel.fromMap(
          event.data() as Map<String, dynamic>,
        );
      },
    );
  }

  void logOut() async {
    await _googleSignIn.signOut();
    await _firebaseAuth.signOut();
  }
}
