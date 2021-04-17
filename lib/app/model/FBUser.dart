import 'package:cloud_firestore/cloud_firestore.dart';

class FBUser {
  FBUser(this.id, this.fullname, this.email, this.phone);

  FBUser.fromDocument(DocumentSnapshot document) {
    id = document.id;
    fullname = document.data()[UserKey.fullname] as String;
    email = document.data()[UserKey.email] as String;
    phone = document.data()[UserKey.phone] as int;
  }

  String id;
  String fullname;
  String email;
  int phone;

  Map<String, dynamic> toMap() {
    return {
      UserKey.id: id,
      UserKey.email: email,
      UserKey.fullname: fullname,
      UserKey.phone: phone,
    };
  }
}

class UserKey {
  static final id = "id";
  static final fullname = "fullname";
  static final email = "email";
  static final phone = "phone";
}
