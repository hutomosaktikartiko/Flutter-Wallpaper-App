import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:wallyapp/config/config.dart';
import 'package:wallyapp/pages/home_page.dart';
import 'package:wallyapp/pages/sign_in_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainPage(),
      theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: primaryColor,
          fontFamily: "productsans"),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  @override
  void initState() {
    _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {
      print("onMessage: $message");
      String title = message["notification"]["title"] ?? "";
      String body = message["notification"]["body"] ?? "";

      print(title);
      print(body);
    }, onLaunch: (Map<String, dynamic> message) async {
      print("onLaunch: $message");
      String title = message["notification"]["title"] ?? "";
      String body = message["notification"]["body"] ?? "";

      print(title);
      print(body);
    }, onResume: (Map<String, dynamic> message) async {
      print("onResume: $message");
      String title = message["notification"]["title"] ?? "";
      String body = message["notification"]["body"] ?? "";

      print(title);
      print(body);
    });

    _firebaseMessaging.subscribeToTopic("promotion");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _auth.onAuthStateChanged,
        builder: (ctx, AsyncSnapshot<FirebaseUser> snapshot) {
          if (snapshot.hasData) {
            FirebaseUser user = snapshot.data;
            if (user != null) {
              return HomePage();
            } else {
              return SignInPage();
            }
          }

          return SignInPage();
        });
  }
}
