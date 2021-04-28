import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ub/app/extension/firebaseref.dart';
import 'package:flutter_ub/app/model/Car.dart';
import 'package:flutter_ub/app/model/FBUser.dart';
import 'package:flutter_ub/app/provider/signupModel.dart';

class VehicleInfoModel extends ChangeNotifier {
  VehicleInfoModel(this._signUpModel);

  String carModel;
  String carColor;
  String carNumber;

  final _auth = FirebaseAuth.instance;

  final SignUpModel _signUpModel;

  Future registerDriver(
      {@required Function(FBUser) onSuccess, @required Function onFail}) async {
    var connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult != ConnectivityResult.wifi &&
        connectivityResult != ConnectivityResult.mobile) {
      onFail("No Internet");
      return;
    }

    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: _signUpModel.email, password: _signUpModel.password);
      print(credential.user.uid);

      if (credential.user != null) {
        FBUser user = FBUser(
          credential.user.uid,
          _signUpModel.fullname,
          _signUpModel.email,
          _signUpModel.phomenumber,
          convertType(
            _signUpModel.typeString,
          ),
        );

        Car car = Car(
          uid: credential.user.uid,
          model: carModel,
          color: carColor,
          number: carNumber,
        );

        user.mycar = car;

        await firebaseRef(FirebaseRef.user)
            .doc(credential.user.uid)
            .set(user.toMap())
            .whenComplete(() {
          firebaseRef(FirebaseRef.user)
              .doc(credential.user.uid)
              .collection("Car")
              .add(car.toMap());
        });

        notifyListeners();
        onSuccess(user);
      }
    } catch (error) {
      onFail(error);
    }
  }
}
