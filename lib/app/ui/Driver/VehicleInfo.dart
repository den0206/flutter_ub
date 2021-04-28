import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ub/app/provider/VehicleInfoModel.dart';
import 'package:flutter_ub/app/provider/signupModel.dart';
import 'package:flutter_ub/app/provider/userState.dart';
import 'package:flutter_ub/app/ui/BranchView.dart';
import 'package:flutter_ub/app/widgets/custom_textFields.dart';
import 'package:flutter_ub/app/widgets/custom_widgets.dart';
import 'package:provider/provider.dart';

class VehicleInfoPage extends StatelessWidget {
  VehicleInfoPage({
    Key key,
  }) : super(key: key);

  static const String id = "vehicle";
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    SignUpModel signModel = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text("Vehicle"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Image.asset(
                "images/logo.png",
                width: 110,
                height: 110,
              ),
              ChangeNotifierProvider<VehicleInfoModel>(
                create: (context) => VehicleInfoModel(signModel),
                child: Consumer<VehicleInfoModel>(
                  builder: (context, model, child) {
                    return Padding(
                      padding: EdgeInsets.all(30),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            Text(
                              "Enter vehicle details",
                              style: TextStyle(
                                  fontFamily: "Brand-Bold", fontSize: 22),
                            ),
                            CustomTextFields(
                              type: CustomTextType.vehicle,
                              onChangged: (value) {
                                model.carModel = value;
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            CustomTextFields(
                              type: CustomTextType.vehicle,
                              onChangged: (value) {
                                model.carColor = value;
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            CustomTextFields(
                              type: CustomTextType.vehicle,
                              onChangged: (value) {
                                model.carNumber = value;
                              },
                            ),
                            SizedBox(
                              height: 40,
                            ),
                            CustomButton(
                              width: 200,
                              title: "Procees",
                              onPressed: () {
                                if (_formKey.currentState.validate()) {
                                  model.registerDriver(onSuccess: (user) {
                                    currentUser = user;
                                    Route route = MaterialPageRoute(
                                        builder: (context) => BranchView());
                                    Navigator.pushReplacement(context, route);
                                  }, onFail: (error) {
                                    showErrorDialog(context, error);
                                  });
                                }
                              },
                            ),
                            Text(signModel.fullname)
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
