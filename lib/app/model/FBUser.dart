import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_ub/app/model/Car.dart';
import 'package:flutter_ub/app/style/style.dart';

class FBUser {
  FBUser(this.id, this.fullname, this.email, this.phone, this.type);

  FBUser.fromDocument(DocumentSnapshot document) {
    id = document.id;
    fullname = document.data()[UserKey.fullname] as String;
    email = document.data()[UserKey.email] as String;
    phone = document.data()[UserKey.phone] as int;

    final typeString = document.data()[UserKey.type] as String;
    type = convertType(typeString);
  }

  String id;
  String fullname;
  String email;
  int phone;
  UserType type;
  Car car;

  Map<String, dynamic> toMap() {
    return {
      UserKey.id: id,
      UserKey.email: email,
      UserKey.fullname: fullname,
      UserKey.phone: phone,
      UserKey.type: type.title,
    };
  }
}

enum UserType { Passanger, Driver }

extension UserTypeExtension on UserType {
  String toShortString() {
    return this.toString().split('.').last;
  }

  String get title {
    switch (this) {
      case UserType.Passanger:
        return kPassanger;
      case UserType.Driver:
        return kDriver;
      default:
        return "";
    }
  }
}

UserType convertType(String typeString) {
  switch (typeString) {
    case kPassanger:
      return UserType.Passanger;
    case kDriver:
      return UserType.Driver;
    default:
      return UserType.Passanger;
  }
}

class UserKey {
  static final id = "id";
  static final fullname = "fullname";
  static final email = "email";
  static final phone = "phone";
  static final type = "type";
  static final token = "token";
}
