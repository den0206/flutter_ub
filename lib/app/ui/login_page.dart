import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ub/app/extension/brand_colors.dart';
import 'package:flutter_ub/app/ui/signup_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                "Sign in",
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    TextField(
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: "Email",
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
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
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
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    SizedBox(
                      height: 50,
                      width: MediaQuery.of(context).size.width - 100,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: BrandColors.colorGreen,
                          onPrimary: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: Text(
                          "Login",
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {},
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          CupertinoPageRoute(
                            builder: (context) {
                              return SignUpPage();
                            },
                          ),
                        );
                      },
                      child: Text(
                        "sign up here",
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
