import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ub/app/extension/firebaseref.dart';
import 'package:flutter_ub/app/model/FBUser.dart';

class UserState extends ChangeNotifier {
  FBUser currentUser;
  final _auth = FirebaseAuth.instance;

  UserState() {
    print("Init User state");
    setUser();
  }

  Stream<User> get state {
    return FirebaseAuth.instance.authStateChanges();
  }

  Future setUser({String uid}) async {
    final userId = uid ?? _auth.currentUser.uid;
    if (userId != null) {
      print("Set user");
      final doc = await firebaseRef(FirebaseRef.user).doc(userId).get();

      currentUser = FBUser.fromDocument(doc);

      notifyListeners();
    } else {
      print("No User");
    }
  }

  Future logout() async {
    currentUser = null;
    await FirebaseAuth.instance.signOut();
    notifyListeners();
  }
}
