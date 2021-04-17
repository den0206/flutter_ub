import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ub/app/provider/loginModel.dart';
import 'package:flutter_ub/app/ui/signup_page.dart';
import 'package:flutter_ub/app/widgets/custom_widgets.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key key}) : super(key: key);
  final _formKey = GlobalKey<FormState>();

  static const String id = "login";

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LoginModel>(
      create: (context) => LoginModel(),
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
                  "Log in",
                  textAlign: TextAlign.center,
                ),
                Consumer<LoginModel>(
                  builder: (context, model, child) {
                    return Form(
                      key: _formKey,
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            CustomTextFields(
                              title: "Email",
                              onChangged: (value) => model.email,
                              validator: (value) {},
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            CustomTextFields(
                              title: "Psssword",
                              isSecure: true,
                              onChangged: (value) => model.password = value,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Please add in a Passwrod";
                                } else if (value.length < 6) {
                                  return "More Long Password(6)";
                                } else {
                                  return null;
                                }
                              },
                            ),
                            SizedBox(
                              height: 40,
                            ),
                            SizedBox(
                              height: 50,
                              width: MediaQuery.of(context).size.width - 100,
                              child: CustomButton(
                                title: "Login",
                                onPressed: () {
                                  if (_formKey.currentState.validate()) {
                                    model.loginUser();
                                  }
                                },
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pushNamedAndRemoveUntil(
                                    context, SignUpPage.id, (route) => false);
                              },
                              child: Text(
                                "sign up here",
                                style: TextStyle(color: Colors.grey),
                              ),
                            )
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
