import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ub/app/extension/validation.dart';
import 'package:flutter_ub/app/provider/signupModel.dart';
import 'package:flutter_ub/app/ui/login_page.dart';
import 'package:flutter_ub/app/widgets/custom_widgets.dart';
import 'package:provider/provider.dart';

class SignUpPage extends StatelessWidget {
  static const String id = "register";
  final _formKey = GlobalKey<FormState>();

  final fullnameController = TextEditingController();
  final phonenemberController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

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
                            TextFormField(
                              controller: fullnameController,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                labelText: "fullmail",
                                labelStyle: TextStyle(
                                  fontSize: 14,
                                ),
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 10,
                                ),
                              ),
                              style: TextStyle(
                                fontSize: 14,
                              ),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Your Name";
                                } else if (value.length < 3) {
                                  return "more 3";
                                } else {
                                  return null;
                                }
                              },
                              onChanged: (value) {
                                model.fullname = value;
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            CustomTextFields(
                              title: "Email",
                              onChangged: (value) => model.email = value,
                              validator: validateEmail,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              controller: phonenemberController,
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                labelText: "Phone",
                                labelStyle: TextStyle(
                                  fontSize: 14,
                                ),
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 10,
                                ),
                              ),
                              style: TextStyle(
                                fontSize: 14,
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Fill";
                                } else {
                                  return null;
                                }
                              },
                              onChanged: (value) =>
                                  model.phomenumber = int.parse(value),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              controller: passwordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                labelText: "Password",
                                labelStyle: TextStyle(
                                  fontSize: 14,
                                ),
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 10,
                                ),
                              ),
                              style: TextStyle(
                                fontSize: 14,
                              ),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Please add in a Passwrod";
                                } else if (value.length < 6) {
                                  return "More Long Password(6)";
                                } else {
                                  return null;
                                }
                              },
                              onChanged: (value) => model.password = value,
                            ),
                            SizedBox(
                              height: 40,
                            ),
                            SizedBox(
                              height: 50,
                              width: MediaQuery.of(context).size.width - 100,
                              child: CustomButton(
                                title: "SignUp",
                                onPressed: () {
                                  if (_formKey.currentState.validate()) {
                                    model.registerUser();
                                  }
                                },
                              ),
                            ),
                            TextButton(
                                onPressed: () {
                                  Navigator.pushNamedAndRemoveUntil(
                                      context, LoginPage.id, (route) => false);
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
