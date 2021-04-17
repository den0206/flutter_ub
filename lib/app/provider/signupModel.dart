import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ub/app/extension/firebaseref.dart';
import 'package:flutter_ub/app/model/FBUser.dart';

class SignUpModel extends ChangeNotifier {
  String email;
  String password;
  String fullname;
  int phomenumber;

  final _auth = FirebaseAuth.instance;

  Future<void> registerUser() async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      print(credential.user.uid);

      if (credential.user != null) {
        FBUser user = FBUser(credential.user.uid, fullname, email, phomenumber);

        firebaseRef(FirebaseRef.user).add(user.toMap());
        notifyListeners();
      }
    } catch (e) {
      print(e);
    }
  }
}
