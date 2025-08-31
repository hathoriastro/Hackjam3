import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

ValueNotifier<AuthServices> authService = ValueNotifier(AuthServices());

class AuthServices {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => firebaseAuth.authStateChanges();

  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    return await firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential> createAccount({
    required String email,
    required String password,
    required String username,
  }) async {
    UserCredential userCredential = await firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);

    await FirebaseFirestore.instance
        .collection("users")
        .doc(userCredential.user!.uid)
        .set({
          "username": username,
          "email": email,
          "createdAt": FieldValue.serverTimestamp(),
        });

    return userCredential;
  }

  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }
}
