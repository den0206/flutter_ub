import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ub/app/extension/firebaseref.dart';
import 'package:flutter_ub/app/provider/userState.dart';
import 'package:flutter_ub/app/ui/login_page.dart';
import 'package:flutter_ub/app/ui/signup_page.dart';
import 'package:flutter_ub/app/widgets/custom_widgets.dart';
import 'package:provider/provider.dart';

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
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          fontFamily: "Brand-Regular",
          primarySwatch: Colors.blue,
        ),
        home: RootPage(),
        routes: {
          LoginPage.id: (context) => LoginPage(),
          SignUpPage.id: (cotext) => SignUpPage(),
        });
  }
}

class RootPage extends StatelessWidget {
  const RootPage({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserState>(
          create: (context) => UserState(),
        )
      ],
      child: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasData) {
            return Scaffold(
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(child: Text("alreadya")),
                  CustomButton(
                    title: "logout",
                    backColor: Colors.red,
                    onPressed: () {
                      final auth =
                          Provider.of<UserState>(context, listen: false);

                      auth.logout();
                    },
                  )
                ],
              ),
            );
          }

          return LoginPage();
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;
  static const String id = "main";

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            MaterialButton(
              height: 50,
              minWidth: 300,
              color: Colors.green,
              child: Text("Connection"),
              onPressed: () {
                firebaseRef(FirebaseRef.test).add({"aa": 1});
              },
            ),
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
