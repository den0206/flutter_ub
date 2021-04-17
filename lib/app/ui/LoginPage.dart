import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ub/app/provider/loginModel.dart';
import 'package:flutter_ub/app/provider/userState.dart';
import 'package:flutter_ub/app/ui/SignupPage.dart';
import 'package:flutter_ub/app/widgets/custom_textFields.dart';
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
                  builder: (_, model, child) {
                    return Form(
                      key: _formKey,
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            CustomTextFields(
                              type: CustomTextType.email,
                              onChangged: (value) => model.email = value,
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
                              title: "Login",
                              onPressed: () {
                                if (_formKey.currentState.validate()) {
                                  model.loginUser(onSuccess: (uid) {
                                    final userState = Provider.of<UserState>(
                                        context,
                                        listen: false);

                                    userState.setUser(uid: uid);
                                  }, onFail: (error) {
                                    showErrorDialog(context, error);
                                  });
                                }
                              },
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pushNamed(SignUpPage.id);
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
