import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:instagram_clone/resources/storage_method.dart';
import 'package:instagram_clone/utils/utils.dart';
import '../model//user_model.dart' as model;

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // getting user
  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot documentSnapshot =
        await _firestore.collection('users').doc(currentUser.uid).get();

    return model.User.fromSnap(documentSnapshot);
  }

  // signing up the user
  Future<String> signUpUser({
    required BuildContext context,
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List file,
  }) async {
    String res = 'Some  error occured';

    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          username.isNotEmpty ||
          bio.isNotEmpty) {
        // register user
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
// adding profile pic to starage
        String photoUrl = await StorageMethod()
            .uploadImageToStorage("profilePics", file, false);
// initializing a user model
        model.User user = model.User(
          username: username,
          uid: cred.user!.uid,
          email: email,
          bio: bio,
          followers: [],
          following: [],
          photoUrl: photoUrl,
        );
        // adding user to database
        _firestore.collection('users').doc(cred.user!.uid).set(user.toJson());
        res = 'success';
      }
    } on FirebaseAuthException catch (err) {
      if (err.code == 'invalid-email') {
        snackBar(context, 'Enter a valid email addresss');
      }
      if (err.code == 'weak-password') {
        snackBar(context, 'Your password should be greater than 8 characters');
      }
      if (err.code == 'email-already-in-use') {
        snackBar(context, 'Email address already in use');
      } else {
        snackBar(context, err.toString());
      }
    } catch (err) {
      snackBar(context, err.toString());
      res = err.toString();
    }
    return res;
  }

  // login user function

  Future<String> loginUser({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    String res = 'Some error occured';

    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        UserCredential cred = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        res = 'success';
      } else {
        snackBar(context, 'Please Field must not be empty');
      }
    } on FirebaseAuthException catch (err) {
      if (err.code == 'network-request-failed') {
        snackBar(context, 'Please check your connection');
      }
    } catch (e) {
      snackBar(context, e.toString());
    }

    return res;
  }
}
