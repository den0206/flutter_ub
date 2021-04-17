import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ub/app/provider/userState.dart';
import 'package:flutter_ub/app/ui/LoginPage.dart';
import 'package:flutter_ub/app/ui/SignupPage.dart';
import 'package:provider/provider.dart';

import 'app/ui/HomePage.dart';

// void main() {
//   runApp(MyApp());
// }

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserState>(
          create: (context) => UserState(),
        ),
      ],
      child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            fontFamily: "Brand-Regular",
            primarySwatch: Colors.blue,
          ),
          home: RootPage(),
          routes: {
            LoginPage.id: (context) => LoginPage(),
            SignUpPage.id: (cotext) => SignUpPage(),
          }),
    );
  }
}

class RootPage extends StatelessWidget {
  const RootPage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasData) {
          return HomePage();
        }

        return LoginPage();
      },
    );
  }
}
