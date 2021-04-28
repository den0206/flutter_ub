import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Car {
  Car({
    this.id,
    @required this.uid,
    @required this.model,
    @required this.color,
    @required this.number,
  });

  String id;
  String uid;
  String model;
  String color;
  String number;

  Map<String, dynamic> toMap() {
    return {
      CarKey.uid: uid,
      CarKey.model: model,
      CarKey.color: color,
      CarKey.number: number,
    };
  }

  Car.fromDocument(DocumentSnapshot document) {
    id = document.id;
    model = document.data()[CarKey.model] as String;
    color = document.data()[CarKey.color] as String;
    number = document.data()[CarKey.number] as String;
    uid = document.data()[CarKey.uid] as String;
  }
}

class CarKey {
  static final uid = "uid";
  static final color = "color";
  static final model = "model";
  static final number = "number";
}
