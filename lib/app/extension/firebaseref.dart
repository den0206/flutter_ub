import 'package:cloud_firestore/cloud_firestore.dart';

enum FirebaseRef { user, ride, location }

extension FirebaseRefExtension on FirebaseRef {
  String get path {
    switch (this) {
      case FirebaseRef.user:
        return "User";
      case FirebaseRef.ride:
        return "RideRequest";
      case FirebaseRef.location:
        return "Location";
      default:
        return "";
    }
  }
}

CollectionReference firebaseRef(FirebaseRef ref) {
  return FirebaseFirestore.instance.collection(ref.path);
}
