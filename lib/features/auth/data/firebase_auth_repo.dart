import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:izahs/features/auth/domain/entities/app_user.dart';
import 'package:izahs/features/auth/domain/repos/auth_repo.dart';

class FirebaseAuthRepo implements AuthRepo {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  @override
  Future<AppUser?> loginWithEmailPassword(String email, String password) async {
    try {
      UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      // fetch user document from firestore

      DocumentSnapshot userDoc = await firebaseFirestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      // check if doc exist
      if (!userDoc.exists) {
        return null;
      }

      // create user
      AppUser user = AppUser(
          uid: userCredential.user!.uid, email: email, name: userDoc['name']);
      // AppUser user =
      //     AppUser(uid: userCredential.user!.uid, email: email, name: '');

      // return user
      return user;
    } catch (e) {
      throw Exception('login failed' + e.toString());
    }
  }

  @override
  Future<AppUser?> registerWithEmailPassowrd(
      String name, String email, String password) async {
    try {
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      // create user
      AppUser user =
          AppUser(uid: userCredential.user!.uid, email: email, name: name);

      // save user data to firestore

      await firebaseFirestore
          .collection('users')
          .doc(user.uid)
          .set(user.toJson());

      // return user
      return user;
    } catch (e) {
      throw Exception('Registeration failed' + e.toString());
    }
  }

  @override
  Future<AppUser?> logout() async {
    await firebaseAuth.signOut();
  }

  @override
  Future<AppUser?> getCurrentUser() async {
    final firebaseUser = firebaseAuth.currentUser;

    if (firebaseUser == null) {
      return null; // ✅ Works because function is async
    }

    return AppUser(
      uid: firebaseUser.uid,
      email: firebaseUser.email,
      name: '',
    );
  }
}
