import 'package:cloud_firestore/cloud_firestore.dart';

enum FirebaseRef {
  user,
  ride,
  test,
}

extension FirebaseRefExtension on FirebaseRef {
  String get path {
    switch (this) {
      case FirebaseRef.user:
        return "User";
      case FirebaseRef.ride:
        return "RideRequest";
      case FirebaseRef.test:
        return "Test";
      default:
        return "";
    }
  }
}

CollectionReference firebaseRef(FirebaseRef ref) {
  return FirebaseFirestore.instance.collection(ref.path);
}
