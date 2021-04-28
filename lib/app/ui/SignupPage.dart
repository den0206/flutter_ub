import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ub/app/model/FBUser.dart';
import 'package:flutter_ub/app/provider/signupModel.dart';
import 'package:flutter_ub/app/provider/userState.dart';
import 'package:flutter_ub/app/style/style.dart';
import 'package:flutter_ub/app/ui/Driver/VehicleInfo.dart';
import 'package:flutter_ub/app/widgets/custom_textFields.dart';
import 'package:flutter_ub/app/widgets/custom_widgets.dart';
import 'package:provider/provider.dart';

class SignUpPage extends StatelessWidget {
  static const String id = "register";
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SignUpModel>(
      create: (context) => SignUpModel(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Title'),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 70,
                ),
                Image(
                  alignment: Alignment.center,
                  width: 100,
                  height: 100,
                  image: AssetImage("images/logo.png"),
                ),
                SizedBox(
                  height: 40,
                ),
                Text(
                  "Sign Up",
                  textAlign: TextAlign.center,
                ),
                Consumer<SignUpModel>(
                  builder: (context, model, child) {
                    return Form(
                      key: _formKey,
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            CupertinoSlidingSegmentedControl(
                              groupValue: model.typeString,
                              thumbColor: Colors.white,
                              children: const <String, Widget>{
                                kPassanger: Text(kPassanger),
                                kDriver: Text(kDriver),
                              },
                              onValueChanged: (value) {
                                model.chageValue(value);
                              },
                            ),
                            CustomTextFields(
                              type: CustomTextType.fullname,
                              onChangged: (value) => model.fullname = value,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            CustomTextFields(
                              type: CustomTextType.email,
                              onChangged: (value) => model.email = value,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            CustomTextFields(
                              type: CustomTextType.phone,
                              onChangged: (value) =>
                                  model.phomenumber = int.parse(value),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            CustomTextFields(
                              type: CustomTextType.password,
                              onChangged: (value) => model.password = value,
                            ),
                            SizedBox(
                              height: 40,
                            ),
                            CustomButton(
                              width: MediaQuery.of(context).size.width - 100,
                              title: model.type == UserType.Passanger
                                  ? "Sign Up"
                                  : "Proceed",
                              onPressed: () {
                                if (_formKey.currentState.validate()) {
                                  if (model.type == UserType.Passanger) {
                                    model.registerUser(
                                      onSuccess: (user) {
                                        currentUser = user;
                                        Navigator.of(context).pop();
                                      },
                                      onFail: (error) {
                                        showErrorDialog(context, error);
                                      },
                                    );
                                  } else {
                                    print("Call");
                                    Navigator.pushNamed(
                                        context, VehicleInfoPage.id,
                                        arguments: model);
                                  }
                                }
                              },
                            ),
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  "Login",
                                  style: TextStyle(
                                    color: Colors.grey,
                                  ),
                                ))
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
